import Foundation

/// `PlacementRequestBuilder` helps create a request for placements by collecting
/// necessary details like pricing and settings. It uses given configurations to
/// build and organize placement data..
class PlacementRequestBuilder {
    private var integrationKey: String = ""
    private var placements: [PlacementRequestBody] = []
    private var brandId: String = ""
    
    init(
        integrationKey: String,
        merchantConfiguration: MerchantConfiguration?,
        placementConfig: PlacementData?
    ) {
        self.brandId = integrationKey
        self.createPlacementRequestBody(
            merchantConfiguration: merchantConfiguration, placementConfig: placementConfig)
    }

    private func createPlacementRequestBody(
        merchantConfiguration: MerchantConfiguration?,
        placementConfig: PlacementData?
    ) {
        let context = ContextRequestBody(
            ENV: merchantConfiguration?.env,
            LOCATION: placementConfig?.locationType ?? "",
            PRICE: placementConfig?.order?.totalPrice?.value,
            channel: merchantConfiguration?.channel,
            subchannel: merchantConfiguration?.subchannel,
            ALLOW_CHECKOUT: placementConfig?.allowCheckout ?? false
        )

        let placement = PlacementRequestBody(
            id: placementConfig?.placementId,
            context: context
        )

        placements.append(placement)
    }

    func build() -> PlacementRequest {
        return PlacementRequest(
            placements: placements,
            brandId: brandId
        )
    }
}
