extension BreadPartnersSDK {
    
    func fetchBrandConfig() {
        let apiUrl = APIUrl(
            urlType: .brandConfig(
                brandId: sdkConfiguration?.configModel.brandId ?? "")
        ).url
        apiClient.request(
            urlString: apiUrl, method: .POST,
            body: sdkConfiguration?.configModel
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                do {
                    brandConfiguration = try commonUtils.decodeJSON(
                        from: response, to: BrandConfigResponse.self)
                    executeSecurityCheck()
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
            body: sdkConfiguration?.configModel
        ) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                handlePlacementResponse(response)
            case .failure(let error):
                self.alertHandler.showAlert(
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
            if responseModel.placements?.first?.renderContext?.LOCATION
                == "RTPS-Approval"
            {
                let popupPlacementModel = PopupPlacementModel(
                    overlayType: "EMBEDDED_OVERLAY",
                    location: responseModel.placements?.first?.renderContext?.LOCATION,
                    brandLogoUrl: "",
                    webViewUrl: responseModel.placements?.first?.renderContext?.embeddedUrl ?? "",
                    overlayTitle: "",
                    overlaySubtitle: "",
                    overlayContainerBarHeading: "",
                    bodyHeader: "",
                    dynamicBodyModel: PopupPlacementModel.DynamicBodyModel(bodyDiv:["":PopupPlacementModel.DynamicBodyContent(
                        tagValuePairs: [
                            "":""
                        ]
                    )]),
                    disclosure: "")
                return htmlContentRenderer.createPopupOverlay(
                    popupPlacementModel: popupPlacementModel,
                    overlayType: .embeddedOverlay)
            } else {
                return htmlContentRenderer.handleTextPlacement(
                    responseModel: responseModel,
                    sdkConfiguration: sdkConfiguration!)
            }
            
        } catch {
            return alertHandler.showAlert(
                title: Constants.nativeSDKAlertTitle(),
                message: Constants.catchError(
                    message: error.localizedDescription), showOkButton: true)
        }
    }
    
    private func executeSecurityCheck() {
        //        let siteKey = self.brandConfiguration?.config.recaptchaSiteKeyQA
        let siteKey = "6Ld1Aa0qAAAAALp2csZ6qg83ImmBTwqNaNxaHx1Z"
        recaptchaManager.executeReCaptcha(
            siteKey: siteKey,
            action: .init(customAction: "checkout"),
            timeout: 10000,
            debug: sdkConfiguration?.enableLog ?? false
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                fetchPlacementData()
            case .failure(let error):
                commonUtils.handleSecurityCheckFailure(error: error)
            }
        }
    }
}
