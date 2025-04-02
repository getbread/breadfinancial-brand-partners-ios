//------------------------------------------------------------------------------
//  File:          BreadFinancialWebViewInterstitial.swift
//  Author(s):     Bread Financial
//  Date:          27 March 2025
//
//  Descriptions:  This file is part of the BreadPartnersSDK for iOS,
//  providing UI components and functionalities to integrate Bread Financial
//  services into partner applications.
//
//  © 2025 Bread Financial
//------------------------------------------------------------------------------

@preconcurrency import WebKit

/// Manages WebView interactions and events within the SDK.
internal class BreadFinancialWebViewInterstitial: NSObject,
    WKNavigationDelegate, WKScriptMessageHandler
{

    init(
        logger:Logger,
        callback: @escaping (BreadPartnerEvents) -> Void
    ) {
        self.logger = logger
        self.callback = callback
    }

    var onPageLoadCompleted: ((Result<URL, Error>) -> Void)?

    let logger: Logger
    let callback: ((BreadPartnerEvents) -> Void)

    func createWebView(with url: URL) -> WKWebView {

        let contentController = WKUserContentController()
        contentController.add(self, name: "messageHandler")

        let config = WKWebViewConfiguration()
        config.websiteDataStore = WKWebsiteDataStore.default()
        config.userContentController = contentController

        let webView = WKWebView(frame: .zero, configuration: config)
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        } else {
            UserDefaults.standard.set(true, forKey: "WebKitDeveloperExtras")
        }

        webView.navigationDelegate = self

        Logger().logLoadingURL(url: url)
        let request = URLRequest(url: url)
        webView.load(request)

        return webView
    }

    func loadPage(for webView: WKWebView) async throws -> URL {
        try await withCheckedThrowingContinuation { continuation in
            onPageLoadCompleted = { result in
                switch result {
                case .success(let url):
                    continuation.resume(returning: url)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func webView(
        _ webView: WKWebView, didFail navigation: WKNavigation!,
        withError error: Error
    ) {
        onPageLoadCompleted?(.failure(error))
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let url = webView.url {
            onPageLoadCompleted?(.success(url))
        }
    }

    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        if let parsedData = message.body as? [String: Any],
           let action = parsedData["action"] as? [String: Any],
           let type = action["type"] as? String {
            
            switch type {
                
            case "HEIGHT_CHANGED":
                break
                
            case "LOAD_ADOBE_TRACKING_ID":
                if let payload = action["payload"] as? [String: Any] {
                    if let adobeTrackingId = payload["adobeTrackingId"] {
                        if(logger.isLoggingEnabled){
                            logger.printLog("BreadPartnersSDK: AdobeTrackingID: \(adobeTrackingId)")
                        }
                    }
                }
                
            case "VIEW_PAGE":
                if let payload = action["payload"] as? [String: Any],
                   let pageName = payload["pageName"] as? String {
                    callback(.screenName(name: pageName))
                }
                
            case "CANCEL_APPLICATION":
                callback(.popupClosed)
                
            case "SUBMIT_APPLICATION":
                callback(.screenName(name: "submit-application"))
                
            case "RECEIVE_APPLICATION_RESULT":
                if let payload = action["payload"] as? [String: Any] {
                    logger.logApplicationResultDetails(payload)
                    callback(.webViewSuccess(result: payload))
                }
                
            case "APPLICATION_COMPLETED":
                callback(.screenName(name: "application-completed"))
                callback(.popupClosed)
            case "OFFER_RESPONSE":
                if let payload = action["payload"] as? String {
                    if(payload == "NO" || payload == "NOT_ME" ){
                        callback(.popupClosed)
                    }
                }                
            default:
                logger.printLog("BreadPartnersSDK: WebViewMessage: \(message.body)")
            }
        }

    }
}
