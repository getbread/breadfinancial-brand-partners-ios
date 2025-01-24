import Foundation
import SwiftSoup

protocol HTMLParserProtocol {
    func parse(_ htmlContent: String) throws -> Document
}

internal class SwiftSoupParser: HTMLParserProtocol {
    func parse(_ htmlContent: String) throws -> Document {
        return try SwiftSoup.parse(htmlContent)
    }
}

protocol HTMLContentParserProtocol {
    func extractTextPlacementModel(htmlContent: String) throws -> TextPlacementModel?
    func extractPopupPlacementModel(from htmlContent: String) throws -> PopupPlacementModel?
    func extractPrimaryCTAButtonAttributes(from document: Document, selector: String) -> PrimaryActionButtonModel?
    func buildDynamicBodyModel(from document: Document) throws -> PopupPlacementModel.DynamicBodyModel
    func handleActionType(from response: String) -> PlacementActionType?
    func handleOverlayType(from response: String) -> PlacementOverlayType?
}

internal class HTMLContentParser:HTMLContentParserProtocol{
    
    private let htmlParser: HTMLParserProtocol
    
    init(htmlParser: HTMLParserProtocol = SwiftSoupParser()) {
        self.htmlParser = htmlParser
    }
    
    func extractTextPlacementModel(htmlContent: String) throws -> TextPlacementModel? {
        let document = try htmlParser.parse(htmlContent)
        
        // Extract attributes
        let actionContentId = try document.select("[data-action-content-id]").attr("data-action-content-id")
        let actionTarget = try document.select("[data-action-target]").attr("data-action-target")
        let actionType = try document.select("[data-action-type]").attr("data-action-type")
        
        // Extract text content
        let actionLink = try document.select(".epjs-body-action a").text()
        let contentText = try document.select(".epjs-body").first()?.ownText().trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let paymentDetailsSup = try document.select("sup").text()
        
        // Extract Payment details
        var paymentDetails = try document.select(".ep-text-placement").text()
        paymentDetails = paymentDetails
            .replacingOccurrences(of: actionLink, with: "")
            .replacingOccurrences(of: paymentDetailsSup, with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Combine contentText and paymentDetails into finalContentText
        let finalContentText: String = {
            switch (contentText.isEmpty, paymentDetails.isEmpty) {
            case (true, true): return ""
            case (true, false): return paymentDetails + " "
            case (false, true): return contentText + " "
            default:
                return contentText == paymentDetails
                ? contentText + " "
                : contentText + " " + paymentDetails + " "
            }
        }()
        
        // Create and return the TextPlacementModel
        return TextPlacementModel(
            actionType: actionType.isEmpty ? nil : actionType,
            actionTarget: actionTarget.isEmpty ? nil : actionTarget,
            contentText: finalContentText.isEmpty ? nil : finalContentText,
            actionLink: actionLink.isEmpty ? nil : actionLink,
            actionContentId: actionContentId.isEmpty ? nil : actionContentId
        )
    }
    
    func extractPopupPlacementModel(from htmlContent: String) throws -> PopupPlacementModel? {
        let document = try SwiftSoup.parse(htmlContent)
        
        // Extract overlay-related attributes
        let overlayType = try document.select("[data-overlay-metadata]").first()?.attr("data-overlay-type") ?? ""
        let brandLogoUrl = try document.select(".brand.logo img").first()?.attr("src") ?? ""
        let webViewUrl = try document.select("iframe").first()?.attr("src") ?? ""
        let overlayTitle = try document.select(".epjs-css-overlay-title").first()?.text() ?? ""
        let overlaySubtitle = try document.select(".epjs-css-overlay-subtitle").first()?.text() ?? ""
        let overlayContainerBarHeading = try document.select(".epjs-css-overlay-body-title-bar").first()?.ownText() ?? ""
        let bodyHeader = try document.select(".epjs-css-overlay-header").first()?.text() ?? ""
        let disclosure = try document.select(".epjs-css-overlay-disclosures").first()?.text() ?? ""
        
        // Extract primary action button attributes
        let primaryActionButtonAttributes = extractPrimaryCTAButtonAttributes(
            from: document,
            selector: ".action-button"
        )
        
        // Build dynamic body model
        let dynamicBodyModel = try buildDynamicBodyModel(from: document)
        
        // Construct and return the PopupPlacementModel
        return PopupPlacementModel(
            overlayType: overlayType,
            brandLogoUrl: brandLogoUrl,
            webViewUrl: webViewUrl,
            overlayTitle: overlayTitle,
            overlaySubtitle: overlaySubtitle,
            overlayContainerBarHeading: overlayContainerBarHeading,
            bodyHeader: bodyHeader,
            primaryActionButtonAttributes: primaryActionButtonAttributes,
            dynamicBodyModel: dynamicBodyModel,
            disclosure: disclosure
        )
    }
    
    // Extract attributes for the primary CTA button
    func extractPrimaryCTAButtonAttributes(from document: Document, selector: String) -> PrimaryActionButtonModel? {
        guard let button = try? document.select(selector).first() else {
            return nil
        }
        
        // Extract button attributes
        let dataContentFetch = try? button.attr("data-content-fetch")
        let dataActionTarget = try? button.attr("data-action-target")
        let dataActionType = try? button.attr("data-action-type")
        let dataActionContentId = try? button.attr("data-action-content-id")
        let dataLocation = try? button.attr("data-location")
        let buttonText = try? button.select("span").text()
        let overlayType = try? document.select(".epjs-css-modal-footer").first()?.attr("data-overlay-type")
        
        return PrimaryActionButtonModel(
            dataOverlayType: overlayType,
            dataContentFetch: dataContentFetch,
            dataActionTarget: dataActionTarget,
            dataActionType: dataActionType,
            dataActionContentId: dataActionContentId,
            dataLocation: dataLocation,
            buttonText: buttonText
        )
    }
    
    // Build the dynamic body model
    func buildDynamicBodyModel(from document: Document) throws -> PopupPlacementModel.DynamicBodyModel {
        var dynamicBodyModel = PopupPlacementModel.DynamicBodyModel(bodyDiv: [:])
        guard let bodyContainer = try document.select(".epjs-css-overlay-body-content").first() else {
            return dynamicBodyModel
        }
        
        let valueProps = try bodyContainer.select(".epjs-css-overlay-value-prop")
        let connectors = try bodyContainer.select(".epjs-css-overlay-value-prop-connector")
        
        var sequenceCounter = 1
        
        // Extract value props
        for valueProp in valueProps.array() {
            let bodyContent = PopupPlacementModel.DynamicBodyContent(
                tagValuePairs: try valueProp.children()
                    .reduce(into: [:]) { dict, child in
                        dict[child.tagName()] = try child.text()
                    }
            )
            dynamicBodyModel.bodyDiv["div\(sequenceCounter)"] = bodyContent
            sequenceCounter += 1
        }
        
        // Extract connectors
        for connector in connectors.array() {
            let connectorContent = PopupPlacementModel.DynamicBodyContent(
                tagValuePairs: ["connector": try connector.text()]
            )
            dynamicBodyModel.bodyDiv["div\(sequenceCounter)"] = connectorContent
            sequenceCounter += 1
        }
        
        return dynamicBodyModel
    }
    
    
    func handleActionType(from response: String) -> PlacementActionType? {
        if let actionType = PlacementActionType(rawValue: response) {
            return actionType
        } else {
            return nil
        }
    }
    
    func handleOverlayType(from response: String) -> PlacementOverlayType? {
        if let overlayType = PlacementOverlayType(rawValue: response) {
            return overlayType
        } else {
            return nil
        }
    }
}
