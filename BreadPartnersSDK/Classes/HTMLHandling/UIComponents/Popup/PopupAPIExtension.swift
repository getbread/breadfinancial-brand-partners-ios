import Foundation

extension PopupController {

    func fetchWebViewPlacement() {
        let builder = PlacementRequestBuilder(
            setupConfig: setupConfig,
            placementConfig: placementsConfiguration?.placementConfig)
        let placementRequest = builder.build()

        let request = PlacementRequest(
            placements: [
                PlacementRequestBody(
                    id: popupModel.primaryActionButtonAttributes?
                        .dataContentFetch,
                    context: placementRequest.placements?.first?.context
                )
            ],
            brandId: setupConfig?.integrationKey
        )

        fetchData(requestBody: request)
    }

    private func fetchData(requestBody: Any) {
        let apiUrl = APIUrl(urlType: .generatePlacements).url
        apiClient.request(urlString: apiUrl, method: .POST, body: requestBody) {
            result in
            switch result {
            case .success(let response):
                self.handleResponse(response)
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

    private func handleResponse(_ response: Any) {
        do {
            let responseModel: PlacementsResponse = try commonUtils.decodeJSON(
                from: response, to: PlacementsResponse.self)
            guard
                let popupPlacementHTMLContent = responseModel.placementContent?
                    .first,
                let popupPlacementModel = try HTMLContentParser()
                    .extractPopupPlacementModel(
                        from: popupPlacementHTMLContent.contentData?.htmlContent
                            ?? "")
            else {
                alertHandler.showAlert(
                    title: Constants.nativeSDKAlertTitle(),
                    message: Constants.popupPlacementParsingError,
                    showOkButton: true
                )
                return
            }
            self.webViewPlacementModel = popupPlacementModel
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
