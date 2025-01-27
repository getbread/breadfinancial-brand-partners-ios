extension BreadPartnersSDK {

    func fetchBrandConfig() {
        let apiUrl = APIUrl(
            urlType: .brandConfig(
                brandId: placementsConfiguration?.configModel.brandId ?? "")
        ).url
        apiClient.request(
            urlString: apiUrl, method: .POST,
            body: placementsConfiguration?.configModel
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                do {
                    brandConfiguration = try commonUtils.decodeJSON(
                        from: response, to: BrandConfigResponse.self)
                    if rtpsFlow {
//                        executeSecurityCheck()
//                        preScreenLookupCall(token: "")
                        fetchPlacementData()
                    } else {
                        fetchPlacementData()
                    }
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

    private func executeSecurityCheck() {
        //        let siteKey = self.brandConfiguration?.config.recaptchaSiteKeyQA
        let siteKey = "6Ld1Aa0qAAAAALp2csZ6qg83ImmBTwqNaNxaHx1Z"
        recaptchaManager.executeReCaptcha(
            siteKey: siteKey,
            action: .init(customAction: "checkout"),
            timeout: 10000,
            debug: breadPartnersSDKSetup?.enableLog ?? false
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

    private func preScreenLookupCall(token: String) {
        let apiUrl = APIUrl(
            urlType: prescreenId == nil
                ? .prescreen
                : .virtualLookup
        ).url

        var rtpsRequest = RTPSRequest(
            urlPath: "/cart",
            firstName: "Carol",
            lastName: "Jones",
            address1: "3075 Loyalty Cir",
            city: "Columbus",
            state: "OH",
            zip: "43219",
            storeNumber: "2009",
            location: "checkout",
            channel: "O",
            subchannel: "M",
            reCaptchaToken: token,
            mockResponse: "success",
            overrideConfig: RTPSRequest.OverrideConfig(
                enhancedPresentment: true),
            prescreenId: nil
        )
        rtpsRequest.reCaptchaToken = token

        apiClient.request(
            urlString: apiUrl, method: .POST,
            body: rtpsRequest
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

    func fetchPlacementData() {

        let apiUrl = APIUrl(urlType: .generatePlacements).url

        apiClient.request(
            urlString: apiUrl, method: .POST,
            body: placementsConfiguration?.configModel
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
