import Foundation
import UIKit

/// AnalyticsManager logs user interactions with placements in the app.
/// It tracks two events:
/// 1. **Click Placement**: When the user clicks on the placement.
/// 2. **View Placement**: When the user sees or interacts with the placement without clicking.
internal class AnalyticsManager {

    private let apiClient: APIClient
    private let commonUtils: CommonUtils
    private let dispatchQueue: DispatchQueue

    init(
        apiClient: APIClient,
        commonUtils: CommonUtils,
        dispatchQueue: DispatchQueue
    ) {
        self.apiClient = apiClient
        self.commonUtils = commonUtils
        self.dispatchQueue = dispatchQueue
    }

    private func sendAnalyticsPayload(
        apiUrl: String, payload: Analytics.Payload
    ) async {
        do {
            _ = try await apiClient.request(
                urlString: apiUrl, method: .POST, body: payload)
        } catch {
        }
    }

    private func createAnalyticsPlacementPayload(
        name: String, placementResponse: PlacementsResponse
    ) -> Analytics.Payload {
        let timestamp = commonUtils.getCurrentTimestamp()

        return Analytics.Payload(
            name: name,
            props: Analytics.Props(
                eventProperties: Analytics.EventProperties(
                    placement: Analytics.Placement(
                        id: "03d69ff1-f90c-41b2-8a27-836af7f1eb98",
                        placementContentId: "0", overlayContentId: "0"),
                    placementContent: Analytics.PlacementContent(
                        id: placementResponse.placementContent?.first?.id,
                        contentType: placementResponse.placementContent?.first?
                            .contentType,
                        metadata: placementResponse.placementContent?.first?
                            .metadata
                    ),
                    metadata: ["location": "Product"],
                    actionTarget: nil
                ),
                userProperties: [:]
            ),
            context: Analytics.Context(
                timestamp: timestamp,
                apiKey: "config api key",
                browserCtx: Analytics.BrowserCtx(
                    library: Analytics.Library(
                        name: "bread-partners-sdk-ios", version: "0.0.1"),
                    userAgent: commonUtils.getUserAgent(),
                    page: Analytics.Page(
                        path: "ScreenName",
                        url: nil
                    )
                ),
                trackingInfo: Analytics.TrackingInfo(
                    userTrackingId: "6f42d67e-cff4-4575-802a-e90a838981bb",
                    sessionTrackingId: "d5cfaf50-f05f-42a8-adea-22d70da25b73")
            )
        )
    }

    private func sendPlacementAnalytics(
        name: String, placementResponse: PlacementsResponse,
        apiUrlType: APIUrlType
    ) async {
        let payload = createAnalyticsPlacementPayload(
            name: name, placementResponse: placementResponse)
        let apiUrl = APIUrl(urlType: apiUrlType).url
        await sendAnalyticsPayload(apiUrl: apiUrl, payload: payload)
    }

    func sendViewPlacement(placementResponse: PlacementsResponse) async {
        await sendPlacementAnalytics(
            name: "view-placement", placementResponse: placementResponse,
            apiUrlType: .viewPlacement)
    }

    func sendClickPlacement(placementResponse: PlacementsResponse) async {
        await sendPlacementAnalytics(
            name: "click-placement", placementResponse: placementResponse,
            apiUrlType: .clickPlacement)
    }
}
