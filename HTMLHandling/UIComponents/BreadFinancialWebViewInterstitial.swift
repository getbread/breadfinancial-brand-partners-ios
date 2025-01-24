@preconcurrency import WebKit

internal class BreadFinancialWebViewInterstitial: NSObject, WKNavigationDelegate,
    WKScriptMessageHandler
{

    var onPageLoadCompleted: ((Result<URL, Error>) -> Void)?

    func createWebView(with url: URL) -> WKWebView {

        // Create a WKUserScript with the JS code
        let userScript = WKUserScript(
            source: jsScript, injectionTime: .atDocumentStart,
            forMainFrameOnly: false)

        // Add the script to the content controller
        let contentController = WKUserContentController()
        contentController.addUserScript(userScript)

        // Add a message handler to WKWebView
        contentController.add(self, name: "message")

        // Configure WKWebView
        let config = WKWebViewConfiguration()
        config.websiteDataStore = WKWebsiteDataStore.default()
        let webpagePreferences = WKWebpagePreferences()
        webpagePreferences.allowsContentJavaScript = true
        config.defaultWebpagePreferences = webpagePreferences
        config.userContentController = contentController

        // Create and configure the WKWebView
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self

        // Log and load the requested URL
        Logger().logLoadingURL(url: url)
        let request = URLRequest(url: url)
        webView.load(request)

        return webView
    }

    func webView(
        _ webView: WKWebView, didFail navigation: WKNavigation!,
        withError error: Error
    ) {
        print("Error loading page: \(error.localizedDescription)")

        onPageLoadCompleted?(.failure(error))
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        print(
            "Navigation action detected, URL: \(navigationAction.request.url?.absoluteString ?? "")"
        )
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(
            "WebView finished loading, URL: \(webView.url?.absoluteString ?? "")"
        )

        if let url = webView.url {
            onPageLoadCompleted?(.success(url))
        }

        webView.evaluateJavaScript(jsScript) { result, error in
            if let error = error {
                print("JavaScript evaluation failed: \(error)")
            } else {
                print("JavaScript successfully injected.")
            }
        }
    }

    let jsScript = """
        window.addEventListener('load', () => {
            try {
                window.webkit.messageHandlers.message.postMessage(
                    JSON.stringify({
                        action: {
                            type: "IS_LOADED",
                            payload: {
                                name: "Page loaded",
                                ack: false
                            },
                        },
                        fmcMessage: true
                    })
                );
            } catch (err) {
                console.error('Error sending message:', err);
            }
        });
        window.addEventListener('message', (event) => {
            try {
                window.webkit.messageHandlers.message.postMessage(
                    JSON.stringify({
                        action: {
                            type: "HANDSHAKE",
                            payload: {
                                name: event.data,
                                ack: false
                            },
                        },
                        fmcMessage: true
                    })
                );
            } catch (err) {
                console.error('Error sending message:', err);
            }
        });
        """

    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        print("UserContentController: Message: \(message.body)")
    }

}
