@preconcurrency import WebKit

internal class BreadFinancialWebViewInterstitial: NSObject,
    WKNavigationDelegate, WKScriptMessageHandler
{

    var onPageLoadCompleted: ((Result<URL, Error>) -> Void)?

    func createWebView(with url: URL) -> WKWebView {
        let userScript = WKUserScript(
            source: jsScript, injectionTime: .atDocumentStart,
            forMainFrameOnly: false
        )

        let contentController = WKUserContentController()
        contentController.addUserScript(userScript)
        contentController.add(self, name: "message")

        let config = WKWebViewConfiguration()
        config.websiteDataStore = WKWebsiteDataStore.default()
        config.userContentController = contentController

        let webView = WKWebView(frame: .zero, configuration: config)
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
        print("Error loading page: \(error.localizedDescription)")
        onPageLoadCompleted?(.failure(error))
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(
            "WebView finished loading, URL: \(webView.url?.absoluteString ?? "")"
        )
        if let url = webView.url {
            onPageLoadCompleted?(.success(url))
        }
    }

    let jsScript = """
        setTimeout(function() {
            try {
                window.webkit.messageHandlers.message.postMessage(
                    {
                        action: {
                            type: "SAY_HELLO",
                            payload: {
                                name: "Sdk",
                                ack: false
                            },
                        },
                        fmcMessage: true
                    },
                    "*"
                );
            } catch (err) {
                console.error('Error sending initial message:', err);
            }

            window.addEventListener('message', (event) => {
                try {
                    window.webkit.messageHandlers.message.postMessage(
                        {
                            action: {
                                type: "message",
                                payload: {
                                    name: event.data,
                                    ack: false
                                },
                            },
                            fmcMessage: true
                        },
                        "*"
                    );
                } catch (err) {
                    console.error('Error sending HANDSHAKE message:', err);
                }
            });
        }, 10000);
        """

    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        print("UserContentController: Message: \(message.body)")
    }
}
