import Foundation
import UIKit

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
        let systemName = UIDevice.current.systemName      // e.g., "iOS"
        let systemVersion = UIDevice.current.systemVersion // e.g., "17.2"
        let deviceModel = UIDevice.current.model          // e.g., "iPhone"

        
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
                    metadata: ["location": "Product"], // click placement
                    actionTarget: nil
                ),
                userProperties: [:]
            ),
            context: Analytics.Context(
                timestamp: timestamp,
                apiKey: "config api key",
                browserCtx: Analytics.BrowserCtx(
                    library: Analytics.Library(name: "bread-partners-sdk-ios", version: "0.0.1"),
                    userAgent: "\(deviceModel): \(systemName) \(systemVersion)", // iPhone; iOS 18.2
                    page: Analytics.Page(
                        path: "ScreenName",
                        url: nil
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
