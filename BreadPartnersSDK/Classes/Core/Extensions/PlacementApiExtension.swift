//------------------------------------------------------------------------------
//  File:          PlacementApiExtension.swift
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

    /// This method is called to fetch placement data,
    /// which will be displayed as a text view with a clickable button in the brand partner's UI.
    func fetchPlacementData() async {
        do {
            let apiUrl = APIUrl(urlType: .generatePlacements).url
            var request: Any? = nil

            let builder = PlacementRequestBuilder(
                integrationKey: integrationKey,
                merchantConfiguration: merchantConfiguration,
                placementConfig: placementsConfiguration?.placementData,
                environment: APIUrl.currentEnvironment
            )
            request = builder.build()

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

    func handlePlacementResponse(_ response: Any) async {
        do {
            let responseModel: PlacementsResponse =
                try await commonUtils.decodeJSON(
                    from: response,
                    to: PlacementsResponse.self
                )

            /// Opens the overlay automatically to simulate user behavior of manually tapping the placement.
            if openPlacementExperience {
                let responseModel: PlacementsResponse =
                    try await commonUtils.decodeJSON(
                        from: response, to: PlacementsResponse.self)
                guard
                    let popupPlacementHTMLContent = responseModel
                        .placementContent?
                        .first,
                    let popupPlacementModel = try await HTMLContentParser()
                        .extractPopupPlacementModel(
                            from: popupPlacementHTMLContent.contentData?
                                .htmlContent
                                ?? ""
                        )
                else {
                    alertHandler.showAlert(
                        title: Constants.nativeSDKAlertTitle(),
                        message: Constants.popupPlacementParsingError,
                        showOkButton: true
                    )
                    return
                }

                await htmlContentRenderer.createPopupOverlay(
                    popupPlacementModel: popupPlacementModel,
                    overlayType: .embeddedOverlay
                )

            } else {
                /// Handles the text placement UI that will be rendered on the brand partner's app screen
                /// for manual tap behavior.
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
