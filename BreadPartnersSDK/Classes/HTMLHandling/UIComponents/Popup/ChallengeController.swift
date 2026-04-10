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

internal class ChallengeController: UIViewController, WKNavigationDelegate {

    private var webView: WKWebView!
    private var closeButton: UIButton!
    private let htmlContent: String
    private let originalURL: String
    private let callback: ((BreadPartnerEvents) -> Void)?
    private let retryRequest: ((String) -> Void)?
    private let mainQueue = DispatchQueue.main
    private var hasInitialLoadCompleted = false
    private var isCheckingForCompletion = false

    init(htmlContent: String, originalURL: String, callback: ((BreadPartnerEvents) -> Void)? = nil, retryRequest: ((String) -> Void)? = nil) {
        self.htmlContent = htmlContent
        self.originalURL = originalURL
        self.callback = callback
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

        // Setup close button
        closeButton = UIButton(type: .system)
        closeButton.setTitle("✕", for: .normal)
        closeButton.titleLabel?.font = .systemFont(ofSize: 24)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)

        // Setup WebView configuration
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

        // Setup constraints - full screen modal
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
        callback?(.popupClosed)
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


        // After initial page load and challenge not completed, block navigation and check for completion
        if hasInitialLoadCompleted && !isCheckingForCompletion {
            self.checkForCompletionNow()
            decisionHandler(.cancel)
            return
        }
        
        // Allow necessary domains first (these are safe)
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
        
        // Block all other navigation
        decisionHandler(.cancel)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Page loaded successfully
        if !hasInitialLoadCompleted {
            hasInitialLoadCompleted = true
            print("[ChallengeController] Page loaded successfully")
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("[ChallengeController] Navigation failed - \(error.localizedDescription)")
    }

    private func checkForCompletionNow() {
        // Prevent multiple simultaneous checks
        if isCheckingForCompletion {
            return
        }
        
        isCheckingForCompletion = true
        
        webView.getCookies { [weak self] currentCookies in
            guard let self = self else { return }

            if !currentCookies.isEmpty {
                print("[ChallengeController] Cookies found: \(currentCookies.prefix(100))...")

                // Give a small delay for any final cookies to settle
                self.mainQueue.asyncAfter(deadline: .now() + 0.5) {
                    self.dismiss(animated: true) { [weak self] in
                        self?.retryRequest?(currentCookies)
                    }
                }
            } else {
                print("[ChallengeController] No cookies available - cannot complete")
                self.isCheckingForCompletion = false
            }
        }
    }

    deinit {
        webView?.navigationDelegate = nil
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
