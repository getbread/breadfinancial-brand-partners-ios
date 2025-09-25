//------------------------------------------------------------------------------
//  File:          RTPSApiExtension.swift
//  Author(s):     Bread Financial
//  Date:          27 March 2025
//
//  Descriptions:  This file is part of the BreadPartnersSDK for iOS,
//  providing UI components and functionalities to integrate Bread Financial
//  services into partner applications.
//
//  © 2025 Bread Financial
//------------------------------------------------------------------------------

extension BreadPartnersSDK {
    /// This method does bot behavior check using the Recaptcha v3 SDK,
    /// to protect against malicious attacks.
//    func executeSecurityCheck() async {
//        let siteKey = brandConfiguration?.config.recaptchaSiteKeyQA
//
//        do {
//            let token = try await recaptchaManager.executeReCaptcha(
//                siteKey: siteKey ?? "",
//                action: .init(customAction: "checkout"),
//                timeout: 10000,
//                debug: logger.isLoggingEnabled
//            )
//            await preScreenLookupCall(token: token)
//        } catch {
//            await CommonUtils().handleSecurityCheckFailure(error: error)
//        }
//    }

    /// Once the Recaptcha token is obtained, make the pre-screen lookup API call.
    /// - If  `prescreenId` was previously saved by the brand partner when calling the pre-screen endpoint,
    ///      then trigger `virtualLookup`.
    /// - Else call pre-screen endpoint to fetch `prescreenId`.
    /// - Both endpoints require user details to build request payload.
    func preScreenLookupCall(
        merchantConfiguration: MerchantConfiguration,
        placementsConfiguration: PlacementConfiguration,
        splitTextAndAction: Bool = false,
        openPlacementExperience: Bool = false,
        forSwiftUI: Bool = false,
        logger: Logger,
        callback: @Sendable @escaping (
            BreadPartnerEvents
        ) -> Void,
        token: String
    ) async {
        do {

            let apiUrl = APIUrl(
                urlType: placementsConfiguration.rtpsData?.prescreenId == nil
                    ? .prescreen : .virtualLookup
            ).url

            let requestBuilder = RTPSRequestBuilder(
                merchantConfiguration: merchantConfiguration,
                rtpsData: placementsConfiguration.rtpsData!,
                reCaptchaToken: token
            )

            let headers: [String: String] = [
                Constants.headerClientKey: integrationKey,
                Constants.headerRequestedWithKey: Constants
                    .headerRequestedWithValue,
            ]

            let rtpsRequestBuilt = requestBuilder.build()

            let response = try await APIClient(logger: logger).request(
                urlString: apiUrl,
                method: .POST,
                headers: headers,
                body: rtpsRequestBuilt
            )

            let preScreenLookupResponse: RTPSResponse =
                try await CommonUtils().decodeJSON(
                    from: response, to: RTPSResponse.self
                )
            let returnResultType = preScreenLookupResponse.returnCode
            let prescreenResult = getPrescreenResult(
                from: returnResultType ?? "10")
            placementsConfiguration.rtpsData!.prescreenId =
                preScreenLookupResponse.prescreenId
            logger.printLog("PreScreenID:Result: \(prescreenResult )")

            /// Since this call runs in the background without user interaction,
            /// if the result is not "approved" or prescreenId is nill,
            /// we simply return without taking any further action.
            if prescreenResult != .approved
                || placementsConfiguration.rtpsData?.prescreenId == nil
            {
                return
            }

            await fetchRTPSData(
                merchantConfiguration: merchantConfiguration,
                placementsConfiguration: placementsConfiguration,
                splitTextAndAction: splitTextAndAction,
                openPlacementExperience: openPlacementExperience,
                forSwiftUI: forSwiftUI,
                logger: logger,
                callback: callback)

        } catch {
            return callback(
                .sdkError(
                    error: NSError(
                        domain: "", code: 500,
                        userInfo: [
                            NSLocalizedDescriptionKey: Constants.apiError(
                                message: error.localizedDescription)
                        ])))
        }
    }

    /// This method is called to fetch placement data,
    /// which will be displayed as a text view with a clickable button in the brand partner's UI.
    func fetchRTPSData(
        merchantConfiguration: MerchantConfiguration,
        placementsConfiguration: PlacementConfiguration,
        splitTextAndAction: Bool = false,
        openPlacementExperience: Bool = false,
        forSwiftUI: Bool = false,
        logger: Logger,
        callback: @Sendable @escaping (
            BreadPartnerEvents
        ) -> Void
    ) async {
        do {
            let apiUrl = APIUrl(urlType: .generatePlacements).url

            let rtpsWebURL = await CommonUtils().buildRTPSWebURL(
                integrationKey: integrationKey,
                merchantConfiguration: merchantConfiguration,
                rtpsData: placementsConfiguration.rtpsData!,
                prescreenId: placementsConfiguration.rtpsData!.prescreenId
            )?.absoluteString

            let request = PlacementRequest(
                placements: [
                    PlacementRequestBody(
                        context: ContextRequestBody(
                            ENV: merchantConfiguration.env?.rawValue,
                            LOCATION: "RTPS-Approval",
                            embeddedUrl: rtpsWebURL
                        )
                    )
                ], brandId: integrationKey
            )

            let response = try await APIClient(logger: logger).request(
                urlString: apiUrl, method: .POST, body: request
            )
            await handleRTPSPlacementResponse(
                merchantConfiguration: merchantConfiguration,
                placementsConfiguration: placementsConfiguration,
                splitTextAndAction: false, openPlacementExperience: true,
                forSwiftUI: false,
                logger: logger,
                callback: callback,
                response)
        } catch {
            return callback(
                .sdkError(
                    error: NSError(
                        domain: "", code: 500,
                        userInfo: [
                            NSLocalizedDescriptionKey: Constants.apiError(
                                message: error.localizedDescription)
                        ])))
        }
    }

    func handleRTPSPlacementResponse(
        merchantConfiguration: MerchantConfiguration,
        placementsConfiguration: PlacementConfiguration,
        splitTextAndAction: Bool = false,
        openPlacementExperience: Bool = false,
        forSwiftUI: Bool = false,
        logger: Logger,
        callback: @Sendable @escaping (
            BreadPartnerEvents
        ) -> Void,
        _ response: Any
    ) async {
        do {
            let responseModel: PlacementsResponse =
                try await CommonUtils().decodeJSON(
                    from: response,
                    to: PlacementsResponse.self
                )
            if responseModel.placements?.isEmpty ?? true {
                return callback(
                    .sdkError(
                        error: NSError(
                            domain: "", code: 500,
                            userInfo: [
                                NSLocalizedDescriptionKey: Constants
                                    .popupPlacementParsingError
                            ])))
            }
            var emptyString
            
            let popupPlacementModel = PopupPlacementModel(
                overlayType: "EMBEDDED_OVERLAY",
                location: responseModel.placements?.first?.renderContext?
                    .LOCATION,
                brandLogoUrl: "",
                webViewUrl: responseModel.placements?.first?.renderContext?
                    .embeddedUrl ?? "",
                overlayTitle: NSAttributedString(""),
                overlaySubtitle: NSAttributedString(""),
                overlayContainerBarHeading: NSAttributedString(""),
                bodyHeader: NSAttributedString(""),
                dynamicBodyModel: PopupPlacementModel.DynamicBodyModel(
                    bodyDiv: [
                        "": PopupPlacementModel.DynamicBodyContent(
                            tagValuePairs: ["": ""]
                        )
                    ]
                ),
                disclosure: NSAttributedString("")
            )
            await HTMLContentRenderer(
                integrationKey: integrationKey,
                merchantConfiguration: merchantConfiguration,
                placementsConfiguration: placementsConfiguration,
                brandConfiguration: brandConfiguration,
                splitTextAndAction: splitTextAndAction,
                forSwiftUI: forSwiftUI,
                logger: logger,
                callback: callback
            ).createPopupOverlay(
                popupPlacementModel: popupPlacementModel,
                overlayType: .embeddedOverlay
            )
        } catch {
            return callback(
                .sdkError(
                    error: NSError(
                        domain: "", code: 500,
                        userInfo: [
                            NSLocalizedDescriptionKey: Constants.catchError(
                                message: error.localizedDescription)
                        ])))
        }
    }
}
