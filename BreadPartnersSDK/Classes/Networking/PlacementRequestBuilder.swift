import Foundation

class PlacementRequestBuilder {
    private var integrationKey: String = ""
    private var placements: [PlacementRequestBody] = []
    private var brandId: String = ""
    
    init(
        integrationKey: String,
        setupConfig: BreadPartnersSetupConfig?,
        placementConfig: BreadPartnersPlacementConfig?
    ) {
        self.brandId = integrationKey
        self.createPlacementRequestBody(
            setupConfig: setupConfig, placementConfig: placementConfig)
    }

    private func createPlacementRequestBody(
        setupConfig: BreadPartnersSetupConfig?,
        placementConfig: BreadPartnersPlacementConfig?
    ) {
        let context = ContextRequestBody(
            ENV: setupConfig?.env,
            PRICE: placementConfig?.order?.totalPrice?.value,
            channel: setupConfig?.channel,
            subchannel: setupConfig?.subchannel,
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
