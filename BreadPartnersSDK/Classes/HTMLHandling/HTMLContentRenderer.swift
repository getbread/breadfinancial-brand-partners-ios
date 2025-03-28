//------------------------------------------------------------------------------
//  File:          HTMLContentRenderer.swift
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
import UIKit

/// Renders parsed HTML content into native UI elements.
@MainActor
internal class HTMLContentRenderer {

    var integrationKey: String = ""
    var merchantConfiguration: MerchantConfiguration?
    var placementsConfiguration: PlacementConfiguration?
    let apiClient: APIClient
    let alertHandler: AlertHandler
    let commonUtils: CommonUtils
    let analyticsManager: AnalyticsManager
    let logger: Logger
    let htmlContentParser: HTMLContentParser
    let dispatchQueue: DispatchQueue
    let brandConfiguration: BrandConfigResponse?
    let recaptchaManager: RecaptchaManager
    var splitTextAndAction: Bool = false
    var forSwiftUI: Bool = false

    let callback: ((BreadPartnerEvents) -> Void)

    init(
        integrationKey: String,
        apiClient: APIClient,
        alertHandler: AlertHandler,
        commonUtils: CommonUtils,
        analyticsManager: AnalyticsManager,
        logger: Logger,
        htmlContentParser: HTMLContentParser,
        dispatchQueue: DispatchQueue,
        merchantConfiguration: MerchantConfiguration?,
        placementsConfiguration: PlacementConfiguration?,
        brandConfiguration: BrandConfigResponse?,
        recaptchaManager: RecaptchaManager,
        splitTextAndAction: Bool = false,
        forSwiftUI: Bool = false,
        callback: @escaping ((BreadPartnerEvents) -> Void)
    ) {
        self.integrationKey = integrationKey
        self.apiClient = apiClient
        self.alertHandler = alertHandler
        self.commonUtils = commonUtils
        self.analyticsManager = analyticsManager
        self.logger = logger
        self.htmlContentParser = htmlContentParser
        self.dispatchQueue = dispatchQueue
        self.merchantConfiguration = merchantConfiguration
        self.placementsConfiguration = placementsConfiguration
        self.brandConfiguration = brandConfiguration
        self.recaptchaManager = recaptchaManager
        self.splitTextAndAction = splitTextAndAction
        self.forSwiftUI = forSwiftUI
        self.callback = callback
    }

    var textPlacementModel: TextPlacementModel? = nil
    var responseModel: PlacementsResponse? = nil

    func handleTextPlacement(responseModel: PlacementsResponse) async {
        self.responseModel = responseModel

        do {
            guard
                let placementContent = responseModel.placementContent?.first?
                    .contentData?.htmlContent
            else {
                return alertHandler.showAlert(
                    title: Constants.nativeSDKAlertTitle(),
                    message: Constants.noTextPlacementError,
                    showOkButton: true
                )
            }

            guard
                let parseTextPlacementModel =
                    try await htmlContentParser.extractTextPlacementModel(
                        htmlContent: placementContent)
            else {
                return alertHandler.showAlert(
                    title: Constants.nativeSDKAlertTitle(),
                    message: Constants.textPlacementParsingError,
                    showOkButton: true
                )
            }

            textPlacementModel = parseTextPlacementModel
            guard let textPlacementModel = textPlacementModel else { return }

            logger.logTextPlacementModelDetails(textPlacementModel)
            Task {
                await analyticsManager.sendViewPlacement(
                    placementResponse: responseModel)
            }

            if self.splitTextAndAction {
                renderTextAndButton()
            } else {
                renderTextViewWithLink()
            }
        } catch {
            alertHandler.showAlert(
                title: Constants.nativeSDKAlertTitle(),
                message: Constants.catchError(
                    message: error.localizedDescription),
                showOkButton: true
            )
        }
    }

    func handlePopupPlacement(
        responseModel: PlacementsResponse,
        textPlacementModel: TextPlacementModel
    ) async {
        guard
            let popupPlacementHTMLContent = responseModel.placementContent?
                .first(where: {
                    $0.id == textPlacementModel.actionContentId
                }),
            let popupPlacementModel =
                try? await htmlContentParser.extractPopupPlacementModel(
                    from: popupPlacementHTMLContent.contentData?.htmlContent
                        ?? "")
        else {
            return alertHandler.showAlert(
                title: Constants.nativeSDKAlertTitle(),
                message: Constants.popupPlacementParsingError,
                showOkButton: true
            )
        }

        logger.logPopupPlacementModelDetails(popupPlacementModel)

        guard
            let overlayType = htmlContentParser.handleOverlayType(
                from: popupPlacementModel.overlayType)
        else {
            return alertHandler.showAlert(
                title: Constants.nativeSDKAlertTitle(),
                message: Constants.missingPopupPlacementError,
                showOkButton: true
            )
        }

        Task {
            await analyticsManager.sendClickPlacement(
                placementResponse: responseModel)
        }
        await createPopupOverlay(
            popupPlacementModel: popupPlacementModel, overlayType: overlayType)
    }

    func createPopupOverlay(
        popupPlacementModel: PopupPlacementModel,
        overlayType: PlacementOverlayType
    ) async {
        let popupViewController = PopupController(
            integrationKey: integrationKey,
            merchantConfiguration: merchantConfiguration!,
            placementConfiguration: placementsConfiguration!,
            popupModel: popupPlacementModel,
            overlayType: overlayType,
            apiClient: apiClient,
            alertHandler: alertHandler,
            commonUtils: commonUtils,
            brandConfiguration: brandConfiguration,
            recaptchaManager: recaptchaManager,
            logger: logger,
            callback: callback
        )
        configurePopupPresentation(popupViewController)
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
