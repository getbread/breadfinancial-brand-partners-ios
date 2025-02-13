extension BreadPartnersSDK {

    /// Retrieve brand-specific configurations, such as the Recaptcha key.
    func fetchBrandConfig() async {
        let apiUrl = APIUrl(urlType: .brandConfig(brandId: integrationKey)).url

        do {
            let response = try await apiClient.request(
                urlString: apiUrl, method: .GET, body: nil)
            brandConfiguration = try await commonUtils.decodeJSON(
                from: response, to: BrandConfigResponse.self)
            return
        } catch {
            alertHandler.showAlert(
                title: Constants.nativeSDKAlertTitle(),
                message: Constants.apiError(
                    message: error.localizedDescription),
                showOkButton: true
            )
        }
    }
    /// This method does bot behavior check using the Recaptcha v3 SDK,
    /// to protect against malicious attacks.
    private func executeSecurityCheck() async {
        let siteKey = "6Ld1Aa0qAAAAALp2csZ6qg83ImmBTwqNaNxaHx1Z"

        do {
            let token = try await recaptchaManager.executeReCaptcha(
                siteKey: siteKey,
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
    private func preScreenLookupCall(token: String) async {
        let apiUrl = APIUrl(
            urlType: prescreenId == nil ? .prescreen : .virtualLookup
        ).url

        let requestBuilder = RTPSRequestBuilder(
            setupConfig: setupConfig!,
            rtpsConfig: placementsConfiguration!.rtpsConfig!
        )

        var rtpsRequestBuilt = requestBuilder.build()
        rtpsRequestBuilt.reCaptchaToken = token

        do {
            let response = try await apiClient.request(
                urlString: apiUrl,
                method: .POST,
                body: rtpsRequestBuilt
            )

            let preScreenLookupResponse: RTPSResponse =
                try await commonUtils.decodeJSON(
                    from: response, to: RTPSResponse.self
                )
            print("PreScreenID: \(preScreenLookupResponse.prescreenId)")
            await fetchPlacementData()
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
    func fetchPlacementData() async {
        let apiUrl = APIUrl(urlType: .generatePlacements).url
        var request: Any? = nil

        if let placementConfig = placementsConfiguration?.placementConfig {
            let builder = PlacementRequestBuilder(
                integrationKey: integrationKey,
                setupConfig: setupConfig,
                placementConfig: placementConfig
            )
            request = builder.build()
        } else {
            let rtpsWebURL = await commonUtils.buildRTPSWebURL(
                integrationKey: integrationKey,
                setupConfig: setupConfig!,
                rtpsConfig: placementsConfiguration!.rtpsConfig!
            )?.absoluteString

            let location =
                placementsConfiguration?.rtpsConfig?.locationType == .checkout
                ? "RTPS-Approval"
                : ""

            request = PlacementRequest(
                placements: [
                    PlacementRequestBody(
                        context: ContextRequestBody(
                            ENV: "",
                            LOCATION: location,
                            embeddedUrl: rtpsWebURL
                        )
                    )
                ], brandId: integrationKey
            )
        }

        do {
            let response = try await apiClient.request(
                urlString: apiUrl, method: .POST, body: request
            )
            await handlePlacementResponse(response)
        } catch {
             alertHandler.showAlert(
                title: Constants.nativeSDKAlertTitle(),
                message: Constants.apiError(
                    message: error.localizedDescription),
                showOkButton: true
            )
        }
    }

    private func handlePlacementResponse(_ response: Any) async {
        do {
            let responseModel: PlacementsResponse =
                try await commonUtils.decodeJSON(
                    from: response,
                    to: PlacementsResponse.self
                )

            if rtpsFlow {
                let popupPlacementModel = PopupPlacementModel(
                    overlayType: "EMBEDDED_OVERLAY",
                    location: responseModel.placements?.first?.renderContext?
                        .LOCATION,
                    brandLogoUrl: "",
                    webViewUrl: responseModel.placements?.first?.renderContext?
                        .embeddedUrl ?? "",
                    overlayTitle: "",
                    overlaySubtitle: "",
                    overlayContainerBarHeading: "",
                    bodyHeader: "",
                    dynamicBodyModel: PopupPlacementModel.DynamicBodyModel(
                        bodyDiv: [
                            "": PopupPlacementModel.DynamicBodyContent(
                                tagValuePairs: ["": ""]
                            )
                        ]
                    ),
                    disclosure: ""
                )
                await htmlContentRenderer.createPopupOverlay(
                    popupPlacementModel: popupPlacementModel,
                    overlayType: .embeddedOverlay
                )
            } else {
                await htmlContentRenderer.handleTextPlacement(
                    responseModel: responseModel
                )
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
}
