import Foundation
import UIKit

protocol HTMLContentRendererProtocol {
    func handleTextPlacement(
        responseModel: PlacementsResponse,
        sdkConfiguration: BreadPartnerSDKConfigurations)
    func createPopupOverlay(
        popupPlacementModel: PopupPlacementModel,
        overlayType: PlacementOverlayType
    )
}

internal class HTMLContentRenderer: HTMLContentRendererProtocol {

    private var sdkConfiguration: BreadPartnerSDKConfigurations?
    private let apiClient: APIClientProtocol
    private let alertHandler: AlertHandlerProtocol
    private let commonUtils: CommonUtilsProtocol
    private let analyticsManager: AnalyticsManagerProtocol
    private let logger: LoggerProtocol
    private let htmlContentParser: HTMLContentParserProtocol
    private let dispatchQueue: DispatchQueue
    private let brandConfiguration: BrandConfigResponse?
    private let recaptchaManager: RecaptchaManagerProtocol

    private let callback: ((BreadPartnerEvents) -> Void)

    init(
        apiClient: APIClientProtocol,
        alertHandler: AlertHandlerProtocol,
        commonUtils: CommonUtilsProtocol,
        analyticsManager: AnalyticsManagerProtocol,
        logger: LoggerProtocol,
        htmlContentParser: HTMLContentParserProtocol,
        dispatchQueue: DispatchQueue,
        sdkConfiguration: BreadPartnerSDKConfigurations?,
        brandConfiguration: BrandConfigResponse?,
        recaptchaManager: RecaptchaManagerProtocol,
        callback: @escaping ((BreadPartnerEvents) -> Void)
    ) {
        self.apiClient = apiClient
        self.alertHandler = alertHandler
        self.commonUtils = commonUtils
        self.analyticsManager = analyticsManager
        self.logger = logger
        self.htmlContentParser = htmlContentParser
        self.dispatchQueue = dispatchQueue
        self.sdkConfiguration = sdkConfiguration
        self.brandConfiguration = brandConfiguration
        self.recaptchaManager = recaptchaManager
        self.callback = callback
    }

    func handleTextPlacement(
        responseModel: PlacementsResponse,
        sdkConfiguration: BreadPartnerSDKConfigurations
    ) {
        self.sdkConfiguration = sdkConfiguration
        do {
            guard
                let placementContent = responseModel.placementContent?.first?
                    .contentData?.htmlContent
            else {
                return alertHandler.showAlert(
                    title: Constants.nativeSDKAlertTitle(),
                    message: Constants.noTextPlacementError, showOkButton: true)
            }

            guard
                let textPlacementModel =
                    try htmlContentParser.extractTextPlacementModel(
                        htmlContent: placementContent)
            else {
                return alertHandler.showAlert(
                    title: Constants.nativeSDKAlertTitle(),
                    message: Constants.textPlacementParsingError,
                    showOkButton: true)
            }

            logger.logTextPlacementModelDetails(textPlacementModel)
            analyticsManager.sendViewPlacement(placementResponse: responseModel)

            return createTextView(
                with: textPlacementModel,
                responseModel: responseModel,
                textPlacementStyling: sdkConfiguration.textPlacementStyling!)

        } catch {
            alertHandler.showAlert(
                title: Constants.nativeSDKAlertTitle(),
                message: Constants.catchError(
                    message: error.localizedDescription), showOkButton: true)
        }
    }

    func createTextView(
        with textPlacementModel: TextPlacementModel,
        responseModel: PlacementsResponse,
        textPlacementStyling: TextPlacementStyling
    ) {
        DispatchQueue.main.async {
            let textView = InteractiveText(
                frame: textPlacementStyling.textViewFrame)

            let normalAttributes: [NSAttributedString.Key: Any] = [
                .font: textPlacementStyling.normalFont,
                .foregroundColor: textPlacementStyling.normalTextColor,
            ]

            let clickableAttributes: [NSAttributedString.Key: Any] = [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .font: textPlacementStyling.clickableFont!,
                .foregroundColor: textPlacementStyling.clickableTextColor,
                .link: textPlacementModel.actionLink ?? "",
            ]

            let normalText = NSAttributedString(
                string: textPlacementModel.contentText ?? "",
                attributes: normalAttributes
            )

            let clickableText = NSAttributedString(
                string: textPlacementModel.actionLink ?? "",
                attributes: clickableAttributes
            )

            let combinedText = NSMutableAttributedString()
            combinedText.append(normalText)
            combinedText.append(clickableText)

            textView.linkTextAttributes = [
                .foregroundColor: textPlacementStyling.clickableTextColor,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
            ]

            textView.configure(with: combinedText) { link in
                self.handleLinkInteraction(
                    link: link,
                    textPlacementModel: textPlacementModel,
                    responseModel: responseModel
                )
            }

            self.callback(.renderTextView(view: textView))
        }
    }

    private func handleLinkInteraction(
        link: String,
        textPlacementModel: TextPlacementModel,
        responseModel: PlacementsResponse
    ) {
        if let actionType = htmlContentParser.handleActionType(
            from: textPlacementModel.actionType ?? "")
        {
            switch actionType {
            case .showOverlay:
                handlePopupPlacement(
                    responseModel: responseModel,
                    textPlacementModel: textPlacementModel)
            default:
                return alertHandler.showAlert(
                    title: Constants.nativeSDKAlertTitle(),
                    message: Constants.missingTextPlacementError,
                    showOkButton: true)
            }
        } else {
            return alertHandler.showAlert(
                title: Constants.nativeSDKAlertTitle(),
                message: Constants.noTextPlacementError, showOkButton: true)
        }
    }

    func handlePopupPlacement(
        responseModel: PlacementsResponse,
        textPlacementModel: TextPlacementModel
    ) {
        guard
            let popupPlacementHTMLContent = responseModel.placementContent?
                .first(where: {
                    $0.id == textPlacementModel.actionContentId
                }),
            let popupPlacementModel =
                try? htmlContentParser.extractPopupPlacementModel(
                    from: popupPlacementHTMLContent.contentData?.htmlContent
                        ?? "")
        else {
            return alertHandler.showAlert(
                title: Constants.nativeSDKAlertTitle(),
                message: Constants.popupPlacementParsingError,
                showOkButton: true)
        }

        logger.logPopupPlacementModelDetails(popupPlacementModel)

        guard
            let overlayType = htmlContentParser.handleOverlayType(
                from: popupPlacementModel.overlayType)
        else {
            return alertHandler.showAlert(
                title: Constants.nativeSDKAlertTitle(),
                message: Constants.missingPopupPlacementError,
                showOkButton: true)
        }

        analyticsManager.sendClickPlacement(placementResponse: responseModel)
        createPopupOverlay(
            popupPlacementModel: popupPlacementModel, overlayType: overlayType)
    }

    func createPopupOverlay(
        popupPlacementModel: PopupPlacementModel,
        overlayType: PlacementOverlayType
    ) {
        DispatchQueue.main.async {
            let popupViewController = PopupController(
                sdkConfiguration: self.sdkConfiguration!,
                popupModel: popupPlacementModel,
                overlayType: overlayType,
                apiClient: self.apiClient,
                alertHandler: self.alertHandler,
                commonUtils: self.commonUtils,
                brandConfiguration: self.brandConfiguration,
                recaptchaManager: self.recaptchaManager,
                callback: self.callback
            )
            self.configurePopupPresentation(popupViewController)
        }

    }

    private func configurePopupPresentation(
        _ popupViewController: PopupController
    ) {
        callback(.textClicked)
        popupViewController.modalPresentationStyle = .overCurrentContext
        popupViewController.modalTransitionStyle = .crossDissolve
        popupViewController.view.backgroundColor = UIColor.black
            .withAlphaComponent(0.5)
        callback(.renderPopupView(view: popupViewController))
    }
}
