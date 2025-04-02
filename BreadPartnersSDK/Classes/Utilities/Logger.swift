//------------------------------------------------------------------------------
//  File:          Logger.swift
//  Author(s):     Bread Financial
//  Date:          27 March 2025
//
//  Descriptions:  This file is part of the BreadPartnersSDK for iOS,
//  providing UI components and functionalities to integrate Bread Financial
//  services into partner applications.
//
//  © 2025 Bread Financial
//------------------------------------------------------------------------------

import Foundation

/// Class responsible for logging information for debugging and tracking purposes.
internal class Logger: NSObject {

    override init() {
        super.init()
    }

    var isLoggingEnabled: Bool = true
    var callback: (BreadPartnerEvents) -> Void = { _ in }
    
    let dashLineFifty = String(repeating: "-", count: 50)
    let dashLineFifteen = String(repeating: "-", count: 15)
    let dashLineTen = String(repeating: "-", count: 10)

    public func debugPrint(
        _ items: Any..., separator: String = " ", terminator: String = "\n"
    ) {
        guard isLoggingEnabled else { return }
        let logMessage = items.map { "\($0)" }.joined(separator: separator)
        Swift.print(logMessage, terminator: terminator)
        callback(.onSDKEventLog(logs: logMessage))
    }

    func printLog(
        _ items: Any..., separator: String = " ", terminator: String = "\n"
    ) {
        guard isLoggingEnabled else { return }
        debugPrint(items)
    }

    func logRequestDetails(
        url: URL, method: String, headers: [String: String]?, body: Data?
    ) {
        guard isLoggingEnabled else { return }
        debugPrint("\n\(dashLineFifteen) Request Details \(dashLineFifteen)")
        debugPrint("URL     : \(url)")
        debugPrint("Method  : \(method)")
        if let headers = headers {
            debugPrint("Headers : \(headers)")
        } else {
            debugPrint("Headers : None")
        }
        if let body = body,
            let jsonObject = try? JSONSerialization.jsonObject(
                with: body, options: []),
            let prettyData = try? JSONSerialization.data(
                withJSONObject: jsonObject, options: .prettyPrinted),
            let prettyJsonString = String(data: prettyData, encoding: .utf8)
        {
            debugPrint("Body    : \(prettyJsonString)")
        } else {
            debugPrint("Body    : None or Unformatted")
        }
        debugPrint("\(dashLineFifty)\n")
    }

    func logResponseDetails(
        url: URL, statusCode: Int, headers: [AnyHashable: Any], body: Data?
    ) {
        guard isLoggingEnabled else { return }
        debugPrint("\n\(dashLineFifteen) Response Details \(dashLineFifteen)")
        debugPrint("URL         : \(url)")
        debugPrint("Status Code : \(statusCode)")
        debugPrint("Headers     : \(headers)")
        if let body = body,
            let jsonObject = try? JSONSerialization.jsonObject(
                with: body, options: []),
            let prettyData = try? JSONSerialization.data(
                withJSONObject: jsonObject, options: .prettyPrinted),
            let prettyJsonString = String(data: prettyData, encoding: .utf8)
        {
            debugPrint("Body        : \(prettyJsonString)")
        } else if let body = body,
            let bodyString = String(data: body, encoding: .utf8)
        {
            debugPrint("Body        : \(bodyString)")
        } else {
            debugPrint("Body        : None or Unformatted")
        }
        debugPrint("\(dashLineFifty)\n")
    }

    func logTextPlacementModelDetails(_ model: TextPlacementModel) {
        guard isLoggingEnabled else { return }
        debugPrint(
            "\n\(dashLineTen) Text Placement Model Details \(dashLineTen)")
        debugPrint("Action Type       : \(model.actionType ?? "N/A")")
        debugPrint("Action Target     : \(model.actionTarget ?? "N/A")")
        debugPrint("Content Text      : \(model.contentText ?? "N/A")")
        debugPrint("Action Link       : \(model.actionLink ?? "N/A")")
        debugPrint("Action Content ID : \(model.actionContentId ?? "N/A")")
        debugPrint("\(dashLineFifty)\n")
    }

    func logPopupPlacementModelDetails(_ model: PopupPlacementModel) {
        guard isLoggingEnabled else { return }
        debugPrint(
            "\n\(dashLineTen) Popup Placement Model Details \(dashLineTen)")
        debugPrint("Overlay Type                  : \(model.overlayType)")
        debugPrint("Location                      : \(model.location ?? "")")
        debugPrint("Brand Logo URL                : \(model.brandLogoUrl)")
        debugPrint("WebView URL                   : \(model.webViewUrl)")
        debugPrint("Overlay Title                 : \(model.overlayTitle)")
        debugPrint("Overlay Subtitle              : \(model.overlaySubtitle)")
        debugPrint(
            "Overlay Container Bar Heading : \(model.overlayContainerBarHeading)"
        )
        debugPrint("Body Header                   : \(model.bodyHeader)")
        debugPrint("Disclosure                    : \(model.disclosure)")

        if let primaryActionButton = model.primaryActionButtonAttributes {
            debugPrint(
                "\n\(dashLineTen) Primary Action Button Details \(dashLineTen)")
            debugPrint(
                "  Data Overlay Type       : \(primaryActionButton.dataOverlayType ?? "N/A")"
            )
            debugPrint(
                "  Data Content Fetch      : \(primaryActionButton.dataContentFetch ?? "N/A")"
            )
            debugPrint(
                "  Data Action Target      : \(primaryActionButton.dataActionTarget ?? "N/A")"
            )
            debugPrint(
                "  Data Action Type        : \(primaryActionButton.dataActionType ?? "N/A")"
            )
            debugPrint(
                "  Data Action Content ID  : \(primaryActionButton.dataActionContentId ?? "N/A")"
            )
            debugPrint(
                "  Data Location           : \(primaryActionButton.dataLocation ?? "N/A")"
            )
            debugPrint(
                "  Button Text             : \(primaryActionButton.buttonText ?? "N/A")"
            )
        } else {
            debugPrint(
                "\(dashLineTen) Primary Action Button: N/A \(dashLineTen)")
        }

        if !model.dynamicBodyModel.bodyDiv.isEmpty {
            var logOutput =
                "\n\(dashLineTen) Dynamic Body Model Details \(dashLineTen)\n"
            for (key, bodyContent) in model.dynamicBodyModel.bodyDiv {
                logOutput += "  Body Div Key [\(key)]:\n"
                for (tag, value) in bodyContent.tagValuePairs {
                    logOutput += "    - \(tag): \(value)\n"
                }
            }
            logOutput += "\(dashLineFifty)\n"
            debugPrint(logOutput)
        } else {
            debugPrint(
                "\n\(dashLineTen) Dynamic Body Model Details \(dashLineTen)")
            debugPrint("Dynamic Body Model: N/A")
            debugPrint("\(dashLineFifty)\n")
        }
    }

    func logLoadingURL(url: URL) {
        guard isLoggingEnabled else { return }
        debugPrint("\(dashLineFifteen) WebView URL \(dashLineFifteen)")
        debugPrint(
            url.absoluteString.trimmingCharacters(in: .whitespacesAndNewlines))
        debugPrint("\(dashLineFifty)")
    }

    func logReCaptchaToken(token: String) {
        guard isLoggingEnabled else { return }
        debugPrint("\(dashLineFifteen) ReCAPTCHA TOKEN \(dashLineFifteen)")
        debugPrint(token)
        debugPrint("\(dashLineFifty)")
    }

    func logApplicationResultDetails(_ payload: [String: Any]) {
        guard isLoggingEnabled else { return }
        debugPrint("\n\(dashLineTen) Application Result Details \(dashLineTen)")
        debugPrint("Application ID     : \(payload["applicationId"] ?? "N/A")")
        debugPrint("Call ID            : \(payload["callId"] ?? "N/A")")
        debugPrint("Card Type          : \(payload["cardType"] ?? "N/A")")
        debugPrint("Email Address      : \(payload["emailAddress"] ?? "N/A")")
        debugPrint("Message            : \(payload["message"] ?? "N/A")")
        debugPrint("Mobile Phone       : \(payload["mobilePhone"] ?? "N/A")")
        debugPrint("Result             : \(payload["result"] ?? "N/A")")
        debugPrint("Status             : \(payload["status"] ?? "N/A")")
        debugPrint("\(dashLineFifty)\n")
    }

}
