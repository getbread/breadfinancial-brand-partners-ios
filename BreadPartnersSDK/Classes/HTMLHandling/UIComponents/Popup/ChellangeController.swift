//------------------------------------------------------------------------------
//  File:          PopupController.swift
//  Author(s):     Bread Financial
//  Date:          3 DEcember 2025
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
    private let retryRequest: (() -> Void)?
    private var hasInitialLoadCompleted = false

    init(htmlContent: String, originalURL: String, callback: ((BreadPartnerEvents) -> Void)? = nil, retryRequest: (() -> Void)? = nil) {
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

        closeButton = UIButton(type: .system)
        closeButton.setTitle("✕", for: .normal)
        closeButton.titleLabel?.font = .systemFont(ofSize: 24)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)

        let config = WKWebViewConfiguration()
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        config.defaultWebpagePreferences = preferences

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
        webView.loadHTMLString(htmlContent, baseURL: URL(string: originalURL))
    }

    @objc private func closeButtonTapped() {
        callback?(.popupClosed)
        dismiss(animated: true)
    }

    // MARK: - WKNavigationDelegate

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }

        let urlString = url.absoluteString
        print("ChallengeController: Initial webView called for URL: \(urlString)")
        print("Olga: \(hasInitialLoadCompleted)")

        // Only check for completion after initial load
        if hasInitialLoadCompleted {
            // If we navigated back to the original URL after challenge
            print("Olga: originalURL: \(originalURL), currentURL: \(urlString)")
            if urlString == originalURL {
                print("ChallengeController: Redirected back to original URL")
                decisionHandler(.cancel)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    print("ChallengeController: Challenge completed successfully")
                    self.callback?(.challengeCompleted)
                    print("ChallengeController: Challenge completed callback sent")
                    self.dismiss(animated: true)
                }
                return
            } else if (urlString.isEmpty) {
                decisionHandler(.cancel)

                DispatchQueue.main.async() {
                    self.dismiss(animated: true)
                }
                return
            }
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

        print("ChallengeController: Blocked navigation to: \(urlString)")
        decisionHandler(.cancel)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if !hasInitialLoadCompleted {
            hasInitialLoadCompleted = true
            print("ChallengeController: Initial page load completed")
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("ChallengeController: Navigation failed - \(error.localizedDescription)")
    }
}
