import Foundation

protocol LoggerProtocol {
    var isLoggingEnabled: Bool { get set }
    func logRequestDetails(url: URL, method: String, headers: [String: String]?, body: Data?)
    func logResponseDetails(url: URL, statusCode: Int, headers: [AnyHashable: Any], body: Data?)
    func logTextPlacementModelDetails(_ model: TextPlacementModel)
    func logPopupPlacementModelDetails(_ model: PopupPlacementModel)
    func logLoadingURL(url: URL)
    func logReCaptchaToken(token: String)
}

internal class Logger: NSObject, LoggerProtocol {
    
    override init() {
          super.init()
      }
        
    var isLoggingEnabled: Bool = true
    
    let dashLineFifty = String(repeating: "-", count: 50)
    let dashLineFifteen = String(repeating: "-", count: 15)
    let dashLineTen = String(repeating: "-", count: 10)
    
    func logRequestDetails(url: URL, method: String, headers: [String: String]?, body: Data?) {
        guard isLoggingEnabled else { return }
        print("\n\(dashLineFifteen) Request Details \(dashLineFifteen)")
        print("URL     : \(url)")
        print("Method  : \(method)")
        if let headers = headers {
            print("Headers : \(headers)")
        } else {
            print("Headers : None")
        }
        if let body = body,
           let jsonObject = try? JSONSerialization.jsonObject(with: body, options: []),
           let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
           let prettyJsonString = String(data: prettyData, encoding: .utf8) {
            print("Body    : \(prettyJsonString)")
        } else {
            print("Body    : None or Unformatted")
        }
        print("\(dashLineFifty)\n")
    }
    
    func logResponseDetails(url: URL, statusCode: Int, headers: [AnyHashable: Any], body: Data?) {
        guard isLoggingEnabled else { return }
        print("\n\(dashLineFifteen) Response Details \(dashLineFifteen)")
        print("URL         : \(url)")
        print("Status Code : \(statusCode)")
        print("Headers     : \(headers)")
        if let body = body,
           let jsonObject = try? JSONSerialization.jsonObject(with: body, options: []),
           let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
           let prettyJsonString = String(data: prettyData, encoding: .utf8) {
            print("Body        : \(prettyJsonString)")
        } else if let body = body, let bodyString = String(data: body, encoding: .utf8) {
            print("Body        : \(bodyString)")
        } else {
            print("Body        : None or Unformatted")
        }
        print("\(dashLineFifty)\n")
    }
    
    func logTextPlacementModelDetails(_ model: TextPlacementModel) {
        guard isLoggingEnabled else { return }
        print("\n\(dashLineTen) Text Placement Model Details \(dashLineTen)")
        print("Action Type       : \(model.actionType ?? "N/A")")
        print("Action Target     : \(model.actionTarget ?? "N/A")")
        print("Content Text      : \(model.contentText ?? "N/A")")
        print("Action Link       : \(model.actionLink ?? "N/A")")
        print("Action Content ID : \(model.actionContentId ?? "N/A")")
        print("\(dashLineFifty)\n")
    }
    
    func logPopupPlacementModelDetails(_ model: PopupPlacementModel) {
        guard isLoggingEnabled else { return }
        print("\n\(dashLineTen) Popup Placement Model Details \(dashLineTen)")
        print("Overlay Type                  : \(model.overlayType)")
        print("Location                      : \(model.location ?? "")")
        print("Brand Logo URL                : \(model.brandLogoUrl)")
        print("WebView URL                   : \(model.webViewUrl)")
        print("Overlay Title                 : \(model.overlayTitle)")
        print("Overlay Subtitle              : \(model.overlaySubtitle)")
        print("Overlay Container Bar Heading : \(model.overlayContainerBarHeading)")
        print("Body Header                   : \(model.bodyHeader)")
        print("Disclosure                    : \(model.disclosure)")
        
        if let primaryActionButton = model.primaryActionButtonAttributes {
            print("\n\(dashLineTen) Primary Action Button Details \(dashLineTen)")
            print("  Data Overlay Type       : \(primaryActionButton.dataOverlayType ?? "N/A")")
            print("  Data Content Fetch      : \(primaryActionButton.dataContentFetch ?? "N/A")")
            print("  Data Action Target      : \(primaryActionButton.dataActionTarget ?? "N/A")")
            print("  Data Action Type        : \(primaryActionButton.dataActionType ?? "N/A")")
            print("  Data Action Content ID  : \(primaryActionButton.dataActionContentId ?? "N/A")")
            print("  Data Location           : \(primaryActionButton.dataLocation ?? "N/A")")
            print("  Button Text             : \(primaryActionButton.buttonText ?? "N/A")")
        } else {
            print("\(dashLineTen) Primary Action Button: N/A \(dashLineTen)")
        }
        
        if !model.dynamicBodyModel.bodyDiv.isEmpty {
            var logOutput = "\n\(dashLineTen) Dynamic Body Model Details \(dashLineTen)\n"
            for (key, bodyContent) in model.dynamicBodyModel.bodyDiv {
                logOutput += "  Body Div Key [\(key)]:\n"
                for (tag, value) in bodyContent.tagValuePairs {
                    logOutput += "    - \(tag): \(value)\n"
                }
            }
            logOutput += "\(dashLineFifty)\n"
            print(logOutput)
        } else {
            print("\n\(dashLineTen) Dynamic Body Model Details \(dashLineTen)")
            print("Dynamic Body Model: N/A")
            print("\(dashLineFifty)\n")
        }
    }
    
    func logLoadingURL(url: URL) {
        guard isLoggingEnabled else { return }
        print("\(dashLineFifteen) WebView URL \(dashLineFifteen)")
        print(url.absoluteString.trimmingCharacters(in: .whitespacesAndNewlines))
        print("\(dashLineFifty)")
    }
    
    func logReCaptchaToken(token: String) {
        guard isLoggingEnabled else { return }
        print("\(dashLineFifteen) ReCAPTCHA TOKEN \(dashLineFifteen)")
        print(token)
        print("\(dashLineFifty)")
    }
}
