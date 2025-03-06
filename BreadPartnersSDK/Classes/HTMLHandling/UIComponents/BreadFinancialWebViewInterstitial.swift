@preconcurrency import WebKit

internal class BreadFinancialWebViewInterstitial: NSObject,
    WKNavigationDelegate, WKScriptMessageHandler
{

    var onPageLoadCompleted: ((Result<URL, Error>) -> Void)?

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
        print("BreadPartnersSDK: WebViewMessage: \(message.body)")
    }
}
