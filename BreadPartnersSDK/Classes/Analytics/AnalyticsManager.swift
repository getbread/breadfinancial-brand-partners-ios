import Foundation

// Define the protocol for AnalyticsManager
protocol AnalyticsManagerProtocol {
    func sendViewPlacement(placementResponse: PlacementsResponse)
    func sendClickPlacement(placementResponse: PlacementsResponse)
}

internal class AnalyticsManager: AnalyticsManagerProtocol {
        
    private let apiClient: APIClientProtocol
    private let commonUtils: CommonUtilsProtocol
    private let dispatchQueue: DispatchQueue
    
    init(apiClient: APIClientProtocol,
         commonUtils: CommonUtilsProtocol,
         dispatchQueue: DispatchQueue) {
        self.apiClient = apiClient
        self.commonUtils = commonUtils
        self.dispatchQueue = dispatchQueue
    }
    
    private func sendAnalyticsPayload(apiUrl: String, payload: Analytics.Payload) {
        dispatchQueue.async {
            self.apiClient.request(urlString: apiUrl, method: .POST, body: payload) { result in
                switch result {
                case .success(_): break
                case .failure(_): break
                }
            }
        }
    }
    
    private func createAnalyticsPlacementPayload(name: String, placementResponse: PlacementsResponse) -> Analytics.Payload {
        let timestamp = commonUtils.getCurrentTimestamp()
        
        return Analytics.Payload(
            name: name,
            props: Analytics.Props(
                eventProperties: Analytics.EventProperties(
                    placement: Analytics.Placement(id: "03d69ff1-f90c-41b2-8a27-836af7f1eb98", placementContentId: "0", overlayContentId: "0"),
                    placementContent: Analytics.PlacementContent(
                        id: placementResponse.placementContent?.first?.id,
                        contentType: placementResponse.placementContent?.first?.contentType,
                        metadata: placementResponse.placementContent?.first?.metadata
                    ),
                    metadata: ["location": "Product"],
                    actionTarget: nil
                ),
                userProperties: [:]
            ),
            context: Analytics.Context(
                timestamp: timestamp,
                apiKey: "8a9fcd35-7f4d-4e3c-a9cc-6f6e98064df7",
                browserCtx: Analytics.BrowserCtx(
                    library: Analytics.Library(name: "bread-payments-sdk", version: "1.0.371"),
                    userAgent: "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Mobile Safari/537.36",
                    page: Analytics.Page(
                        path: "/collections/living-room/products/benchwright-square-coffee-table",
                        url: "https://aspire-ep-demo.myshopify.com/collections/living-room/products/benchwright-square-coffee-table"
                    )
                ),
                trackingInfo: Analytics.TrackingInfo(userTrackingId: "6f42d67e-cff4-4575-802a-e90a838981bb", sessionTrackingId: "d5cfaf50-f05f-42a8-adea-22d70da25b73")
            )
        )
    }
    
    private func sendPlacementAnalytics(name: String, placementResponse: PlacementsResponse, apiUrlType: APIUrlType) {
        let payload = createAnalyticsPlacementPayload(name: name, placementResponse: placementResponse)
        let apiUrl = APIUrl(urlType: apiUrlType).url
        sendAnalyticsPayload(apiUrl: apiUrl, payload: payload)
    }
    
    func sendViewPlacement(placementResponse: PlacementsResponse) {
        sendPlacementAnalytics(name: "view-placement", placementResponse: placementResponse, apiUrlType: .viewPlacement)
    }
    
    func sendClickPlacement(placementResponse: PlacementsResponse) {
        sendPlacementAnalytics(name: "click-placement", placementResponse: placementResponse, apiUrlType: .clickPlacement)
    }
}
