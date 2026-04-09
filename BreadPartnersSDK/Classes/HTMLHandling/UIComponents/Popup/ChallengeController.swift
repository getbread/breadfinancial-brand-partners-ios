//------------------------------------------------------------------------------
//  File:          ChallengeController.swift
//  Author(s):     Bread Financial
//  Date:          3 December 2025
//
//  Descriptions:  This file is part of the BreadPartnersSDK for iOS,
//  providing UI components and functionalities to integrate Bread Financial
//  services into partner applications.
//
//  © 2025 Bread Financial
//------------------------------------------------------------------------------

import WebKit

internal class ChallengeController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    
    private let htmlContent: String
    private let originalURL: String
    private let retryRequest: (String) -> Void
    
    private var challengeCompleted = false
    private var initialCookies: String = ""
    private var pageLoadTime: Date?
    private let mainQueue = DispatchQueue.main
    private var cookieCheckRunnable: (() -> Void)?
    private let minimumWaitTimeMs: TimeInterval = 3.0 // 3 seconds
    
    private var webView: WKWebView!
    private var closeButton: UIButton!
    private var hasInitialLoadCompleted = false
    
    init(htmlContent: String,
         originalURL: String,
         retryRequest: @escaping (String) -> Void) {
        self.htmlContent = htmlContent
        self.originalURL = originalURL
        self.retryRequest = retryRequest
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadHTMLContent()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        closeButton = UIButton(type: .system)
        closeButton.setTitle("✕", for: .normal)
        closeButton.titleLabel?.font = .systemFont(ofSize: 24)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        
        if #available(iOS 14.0, *) {
            let preferences = WKWebpagePreferences()
            preferences.allowsContentJavaScript = true
            config.defaultWebpagePreferences = preferences
        }
        
        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }
        
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            
            webView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadHTMLContent() {
        if let originalURL = URL(string: originalURL) {
            webView.loadHTMLString(htmlContent, baseURL: originalURL)
        }
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        
        // After initial page load, block navigation (captcha completion signal)
        if hasInitialLoadCompleted && !challengeCompleted {
            mainQueue.asyncAfter(deadline: .now() + 0.5) {
                self.checkForCompletionNow()
            }
            decisionHandler(.cancel)
            return
        }
        
        // Allow necessary domains
        let allowedDomains = ["comenity.net", "breadfinancial.com", "hcaptcha.com", "gstatic.com", "newassets.hcaptcha.com"]
        
        if let host = url.host {
            if allowedDomains.contains(where: { host.contains($0) }) {
                decisionHandler(.allow)
                return
            }
        }
        
        // Allow data URIs and about:blank
        if url.scheme == "data" || url.scheme == "about" {
            decisionHandler(.allow)
            return
        }
        
        decisionHandler(.cancel)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if !hasInitialLoadCompleted {
            hasInitialLoadCompleted = true
            pageLoadTime = Date()
            
            // Capture initial cookies and start monitoring
            webView.getCookies { [weak self] cookies in
                self?.initialCookies = cookies
                self?.startCookieMonitoring(webView)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("ChallengeController: Navigation failed - \(error.localizedDescription)")
    }
    
    private func startCookieMonitoring(_ webView: WKWebView) {
        cookieCheckRunnable = { [weak self] in
            guard let self = self, !self.challengeCompleted else { return }
            
            webView.getCookies { [weak self] currentCookies in
                guard let self = self else { return }
                
                let elapsedTime = Date().timeIntervalSince(self.pageLoadTime ?? Date())
                
                // Wait for minimum time before checking
                if elapsedTime < self.minimumWaitTimeMs {
                    print("Still in initial load period (\(Int(elapsedTime))ms elapsed), waiting...")
                    self.mainQueue.asyncAfter(deadline: .now() + 0.5) {
                        self.cookieCheckRunnable?()
                    }
                    return
                }
                
                // Check for session cookie changes
                let hasSessionCookie = currentCookies.contains("incap_ses_")
                let sessionCookieChanged = hasSessionCookie &&
                    self.extractSessionCookie(self.initialCookies) != self.extractSessionCookie(currentCookies)
                
                if currentCookies != self.initialCookies && !currentCookies.isEmpty && sessionCookieChanged {
                    self.challengeCompleted = true
                    
                    self.mainQueue.asyncAfter(deadline: .now() + 0.5) {
                        self.completeCaptcha(currentCookies)
                    }
                } else {
                    // Continue checking every 500ms
                    self.mainQueue.asyncAfter(deadline: .now() + 0.5) {
                        self.cookieCheckRunnable?()
                    }
                }
            }
        }
        
        // Start checking after initial delay
        mainQueue.asyncAfter(deadline: .now() + 1.0) {
            self.cookieCheckRunnable?()
        }
    }
    
    private func extractSessionCookie(_ cookies: String) -> String {
        let pattern = "incap_ses_\\d+_\\d+=[^;]+"
        if let regex = try? NSRegularExpression(pattern: pattern) {
            let range = NSRange(cookies.startIndex..<cookies.endIndex, in: cookies)
            if let match = regex.firstMatch(in: cookies, range: range) {
                return String(cookies[Range(match.range, in: cookies)!])
            }
        }
        return ""
    }
    
    private func checkForCompletionNow() {
        guard !challengeCompleted else { return }
        
        webView.getCookies { [weak self] currentCookies in
            guard let self = self else { return }
            
            let elapsedTime = Date().timeIntervalSince(self.pageLoadTime ?? Date())
            
            // If navigation happens after minimum wait time, treat as completion
            if elapsedTime >= self.minimumWaitTimeMs && !currentCookies.isEmpty {
                self.challengeCompleted = true
                
                self.mainQueue.asyncAfter(deadline: .now() + 0.5) {
                    self.completeCaptcha(currentCookies)
                }
            } else if elapsedTime < self.minimumWaitTimeMs {
                print("Navigation too soon (\(Int(elapsedTime))ms < \(Int(self.minimumWaitTimeMs))ms) - likely false positive")
            } else {
                print("No cookies available - cannot complete")
            }
        }
    }
    
    private func completeCaptcha(_ cookies: String) {
        print("Completing captcha with cookies: \(cookies.prefix(100))...")
        dismiss(animated: true) { [weak self] in
            self?.retryRequest(cookies)
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        // Handle script messages if needed
    }
    
    deinit {
        // Clean up cookie monitoring
        webView?.configuration.userContentController.removeAllUserScripts()
    }
}

extension WKWebView {
    private var httpCookieStore: WKHTTPCookieStore {
        return WKWebsiteDataStore.default().httpCookieStore
    }
    
    func getCookies(completion: @escaping (String) -> Void) {
        var cookieString = ""
        httpCookieStore.getAllCookies { cookies in
            for cookie in cookies {
                cookieString.append("\(cookie.name)=\(cookie.value); ")
            }
            completion(cookieString)
        }
    }
}
