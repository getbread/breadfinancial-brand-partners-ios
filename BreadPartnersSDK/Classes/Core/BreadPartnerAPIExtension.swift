extension BreadPartnersSDK {

    /// Retrieve brand-specific configurations, such as the Recaptcha key.
    func fetchBrandConfig() {
        let apiUrl = APIUrl(
            urlType: .brandConfig(
                brandId: integrationKey)
        ).url
        apiClient.request(
            urlString: apiUrl, method: .GET, body: nil
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                do {
                    brandConfiguration = try commonUtils.decodeJSON(
                        from: response, to: BrandConfigResponse.self)
                    return
                } catch {
                    alertHandler.showAlert(
                        title: Constants.nativeSDKAlertTitle(),
                        message: Constants.catchError(
                            message: error.localizedDescription),
                        showOkButton: true)

                }
            case .failure(let error):
                alertHandler.showAlert(
                    title: Constants.nativeSDKAlertTitle(),
                    message: Constants.apiError(
                        message: error.localizedDescription), showOkButton: true
                )
            }
        }
        return
    }

    /// This method does bot behavior check using the Recaptcha v3 SDK,
    /// to protect against malicious attacks.
    private func executeSecurityCheck() {
        //        let siteKey = self.brandConfiguration?.config.recaptchaSiteKeyQA
        let siteKey = "6Ld1Aa0qAAAAALp2csZ6qg83ImmBTwqNaNxaHx1Z"
        recaptchaManager.executeReCaptcha(
            siteKey: siteKey,
            action: .init(customAction: "checkout"),
            timeout: 10000,
            debug: logger.isLoggingEnabled
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                preScreenLookupCall(token: token)
            case .failure(let error):
                commonUtils.handleSecurityCheckFailure(error: error)
            }
        }
    }

    /// Once the Recaptcha token is obtained, make the pre-screen lookup API call.
    /// - If  `prescreenId` was previously saved by the brand partner when calling the pre-screen endpoint,
    ///      then trigger `virtualLookup`.
    /// - Else call pre-screen endpoint to fetch `prescreenId`.
    /// - Both endpoints require user details to build request payload.
    private func preScreenLookupCall(token: String) {
        let apiUrl = APIUrl(
            urlType: prescreenId == nil
                ? .prescreen
                : .virtualLookup
        ).url

        let requestBuilder = RTPSRequestBuilder(
            setupConfig: setupConfig!,
            rtpsConfig: (placementsConfiguration?.rtpsConfig)!)
        var rtpsRequestBuilt = requestBuilder.build()
        rtpsRequestBuilt.reCaptchaToken = token

        apiClient.request(
            urlString: apiUrl, method: .POST,
            body: rtpsRequestBuilt
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                do {
                    let preScreenLookupResponse = try commonUtils.decodeJSON(
                        from: response, to: RTPSResponse.self)
                    print("PreScreenID::\(preScreenLookupResponse.prescreenId)")
                    fetchPlacementData()
                } catch {
                    alertHandler.showAlert(
                        title: Constants.nativeSDKAlertTitle(),
                        message: Constants.catchError(
                            message: error.localizedDescription),
                        showOkButton: true)
                }
            case .failure(let error):
                alertHandler.showAlert(
                    title: Constants.nativeSDKAlertTitle(),
                    message: Constants.apiError(
                        message: error.localizedDescription), showOkButton: true
                )
            }
        }
    }

    /// This method is called to fetch placement data,
    /// which will be displayed as a text view with a clickable button in the brand partner's UI.
    func fetchPlacementData() {
        
        let apiUrl = APIUrl(urlType: .generatePlacements).url
        var request: Any? = nil
        if placementsConfiguration?.placementConfig != nil {
            let builder = PlacementRequestBuilder(
                integrationKey:integrationKey,
                setupConfig: setupConfig,
                placementConfig: placementsConfiguration?.placementConfig)
            request = builder.build()
        } else {
            let rtpsWebURL = commonUtils.buildRTPSWebURL(
                integrationKey: integrationKey,
                setupConfig: setupConfig!,
                rtpsConfig: (placementsConfiguration?
                    .rtpsConfig)!)?.absoluteString
            let location =
                switch placementsConfiguration?.rtpsConfig?.locationType {
                case .checkout:
                    "RTPS-Approval"
                default:
                    ""
                }
            request = PlacementRequest(
                placements: [
                    PlacementRequestBody(
                        context: ContextRequestBody(
                            ENV: "",
                            LOCATION: location,
                            embeddedUrl: rtpsWebURL
                        )
                    )
                ], brandId: integrationKey)
        }

        apiClient.request(
            urlString: apiUrl, method: .POST,
            body: request
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                handlePlacementResponse(response)
            case .failure(let error):
                alertHandler.showAlert(
                    title: Constants.nativeSDKAlertTitle(),
                    message: Constants.apiError(
                        message: error.localizedDescription),
                    showOkButton: true
                )
            }
        }

    }

    private func handlePlacementResponse(
        _ response: Any
    ) {
        do {
            let responseModel: PlacementsResponse = try self.commonUtils
                .decodeJSON(from: response, to: PlacementsResponse.self)
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
                                tagValuePairs: [
                                    "": ""
                                ]
                            )
                        ]),
                    disclosure: "")
                return htmlContentRenderer.createPopupOverlay(
                    popupPlacementModel: popupPlacementModel,
                    overlayType: .embeddedOverlay)
            } else {
                return htmlContentRenderer.handleTextPlacement(
                    responseModel: responseModel)
            }

        } catch {
            return alertHandler.showAlert(
                title: Constants.nativeSDKAlertTitle(),
                message: Constants.catchError(
                    message: error.localizedDescription), showOkButton: true)
        }
    }

}
