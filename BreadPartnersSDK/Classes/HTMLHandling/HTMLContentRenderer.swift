import Foundation
import UIKit

protocol HTMLContentRendererProtocol {
    func handleTextPlacement(
        responseModel: PlacementsResponse)
    func createPopupOverlay(
        popupPlacementModel: PopupPlacementModel,
        overlayType: PlacementOverlayType
    )
}

internal class HTMLContentRenderer: HTMLContentRendererProtocol {

    var setupConfig: BreadPartnersSetupConfig?
    var placementsConfiguration: PlacementsConfiguration?
    let apiClient: APIClientProtocol
    let alertHandler: AlertHandlerProtocol
    let commonUtils: CommonUtilsProtocol
    let analyticsManager: AnalyticsManagerProtocol
    let logger: LoggerProtocol
    let htmlContentParser: HTMLContentParserProtocol
    let dispatchQueue: DispatchQueue
    let brandConfiguration: BrandConfigResponse?
    let recaptchaManager: RecaptchaManagerProtocol
    var splitTextAndAction: Bool = false

    let callback: ((BreadPartnerEvents) -> Void)

    init(
        apiClient: APIClientProtocol,
        alertHandler: AlertHandlerProtocol,
        commonUtils: CommonUtilsProtocol,
        analyticsManager: AnalyticsManagerProtocol,
        logger: LoggerProtocol,
        htmlContentParser: HTMLContentParserProtocol,
        dispatchQueue: DispatchQueue,
        setupConfig: BreadPartnersSetupConfig?,
        placementsConfiguration: PlacementsConfiguration?,
        brandConfiguration: BrandConfigResponse?,
        recaptchaManager: RecaptchaManagerProtocol,
        splitTextAndAction: Bool = false,
        callback: @escaping ((BreadPartnerEvents) -> Void)
    ) {
        self.apiClient = apiClient
        self.alertHandler = alertHandler
        self.commonUtils = commonUtils
        self.analyticsManager = analyticsManager
        self.logger = logger
        self.htmlContentParser = htmlContentParser
        self.dispatchQueue = dispatchQueue
        self.setupConfig = setupConfig
        self.placementsConfiguration = placementsConfiguration
        self.brandConfiguration = brandConfiguration
        self.recaptchaManager = recaptchaManager
        self.splitTextAndAction = splitTextAndAction
        self.callback = callback
    }

    var textPlacementModel: TextPlacementModel? = nil
    var responseModel: PlacementsResponse? = nil
    var textPlacementStyling: TextPlacementStyling? = nil

    func handleTextPlacement(
        responseModel: PlacementsResponse
    ) {
        self.responseModel = responseModel
        
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
                let parseTextPlacementModel =
                    try htmlContentParser.extractTextPlacementModel(
                        htmlContent: placementContent)
            else {
                return alertHandler.showAlert(
                    title: Constants.nativeSDKAlertTitle(),
                    message: Constants.textPlacementParsingError,
                    showOkButton: true)
            }

            textPlacementModel = parseTextPlacementModel
            textPlacementStyling = placementsConfiguration?.textPlacementStyling
            guard let textPlacementModel = textPlacementModel,
                  let textPlacementStyling = textPlacementStyling else {
                return
            }
            logger.logTextPlacementModelDetails(textPlacementModel)
            analyticsManager.sendViewPlacement(placementResponse: responseModel)

            DispatchQueue.main.async {
                if self.splitTextAndAction {
                    return self.renderTextAndButton()
                } else {
                    return self.renderSingleTextView()
                }
            }

        } catch {
            alertHandler.showAlert(
                title: Constants.nativeSDKAlertTitle(),
                message: Constants.catchError(
                    message: error.localizedDescription), showOkButton: true)
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
                setupConfig: self.setupConfig!,
                sdkConfiguration: self.placementsConfiguration!,
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
