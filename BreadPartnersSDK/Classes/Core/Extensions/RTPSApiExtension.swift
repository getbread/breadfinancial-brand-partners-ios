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
    func executeSecurityCheck() async {
        let siteKey = brandConfiguration?.config.recaptchaSiteKeyQA

        do {
            let token = try await recaptchaManager.executeReCaptcha(
                siteKey: siteKey ?? "",
                action: .init(customAction: "checkout"),
                timeout: 10000,
                debug: logger.isLoggingEnabled
            )
            await preScreenLookupCall(token: token)
        } catch {
            await commonUtils.handleSecurityCheckFailure(error: error)
        }
    }

    /// Once the Recaptcha token is obtained, make the pre-screen lookup API call.
    /// - If  `prescreenId` was previously saved by the brand partner when calling the pre-screen endpoint,
    ///      then trigger `virtualLookup`.
    /// - Else call pre-screen endpoint to fetch `prescreenId`.
    /// - Both endpoints require user details to build request payload.
    func preScreenLookupCall(token: String) async {
        do {

            let apiUrl = APIUrl(
                urlType: placementsConfiguration?.rtpsData?.prescreenId == nil
                    ? .prescreen : .virtualLookup
            ).url

            let requestBuilder = RTPSRequestBuilder(
                merchantConfiguration: merchantConfiguration!,
                rtpsData: placementsConfiguration!.rtpsData!,
                reCaptchaToken: token
            )

            let headers: [String: String] = [
                Constants.headerClientKey: integrationKey,
                Constants.headerRequestedWithKey: Constants
                    .headerRequestedWithValue,
            ]

            let rtpsRequestBuilt = requestBuilder.build()

            let response = try await apiClient.request(
                urlString: apiUrl,
                method: .POST,
                headers: headers,
                body: rtpsRequestBuilt
            )

            let preScreenLookupResponse: RTPSResponse =
                try await commonUtils.decodeJSON(
                    from: response, to: RTPSResponse.self
                )
            let returnResultType = preScreenLookupResponse.returnCode
            let prescreenResult = getPrescreenResult(
                from: returnResultType ?? "10")
            prescreenId = preScreenLookupResponse.prescreenId

            logger.printLog("PreScreenID:Result: \(prescreenResult)")
            logger.printLog("PreScreenID: \(String(describing: prescreenId))")

            /// Since this call runs in the background without user interaction,
            /// if the result is not "approved" or prescreenId is nill,
            /// we simply return without taking any further action.
            if prescreenResult != .approved || prescreenId == nil {
                return
            }

            await fetchRTPSData()

        } catch {
            alertHandler.showAlert(
                title: Constants.nativeSDKAlertTitle(),
                message: Constants.catchError(
                    message: error.localizedDescription
                ),
                showOkButton: true
            )
        }
    }

    /// This method is called to fetch placement data,
    /// which will be displayed as a text view with a clickable button in the brand partner's UI.
    func fetchRTPSData() async {
        do {
            let apiUrl = APIUrl(urlType: .generatePlacements).url

            let rtpsWebURL = await commonUtils.buildRTPSWebURL(
                integrationKey: integrationKey,
                merchantConfiguration: merchantConfiguration!,
                rtpsData: placementsConfiguration!.rtpsData!,
                prescreenId: prescreenId
            )?.absoluteString

            let request = PlacementRequest(
                placements: [
                    PlacementRequestBody(
                        context: ContextRequestBody(
                            ENV: merchantConfiguration?.env?.rawValue,
                            LOCATION: "RTPS-Approval",
                            embeddedUrl: rtpsWebURL
                        )
                    )
                ], brandId: integrationKey
            )

            let response = try await apiClient.request(
                urlString: apiUrl, method: .POST, body: request
            )
            await handleRTPSPlacementResponse(response)
        } catch {
            alertHandler.showAlert(
                title: Constants.nativeSDKAlertTitle(),
                message: Constants.apiError(
                    message: error.localizedDescription),
                showOkButton: true
            )
        }
    }

    func handleRTPSPlacementResponse(_ response: Any) async {
        do {
            let responseModel: PlacementsResponse =
                try await commonUtils.decodeJSON(
                    from: response,
                    to: PlacementsResponse.self
                )
            if responseModel.placements?.isEmpty ?? true {
                alertHandler.showAlert(
                    title: Constants.nativeSDKAlertTitle(),
                    message: Constants.popupPlacementParsingError,
                    showOkButton: true
                )
                return
            }
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
            await htmlContentRenderer.createPopupOverlay(
                popupPlacementModel: popupPlacementModel,
                overlayType: .embeddedOverlay
            )

        } catch {
            alertHandler.showAlert(
                title: Constants.nativeSDKAlertTitle(),
                message: Constants.catchError(
                    message: error.localizedDescription),
                showOkButton: true
            )
        }
    }
}
