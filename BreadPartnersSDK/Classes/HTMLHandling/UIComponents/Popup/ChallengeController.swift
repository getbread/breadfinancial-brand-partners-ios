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

        // Only check for completion after initial load
        if hasInitialLoadCompleted {
            // If we navigated back to the original URL after challenge
            if urlString == originalURL {
                decisionHandler(.cancel)

                self.dismiss(animated: true) {
                    self.retryRequest?()
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
        
        decisionHandler(.cancel)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if !hasInitialLoadCompleted {
            hasInitialLoadCompleted = true
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("ChallengeController: Navigation failed - \(error.localizedDescription)")
    }
}
