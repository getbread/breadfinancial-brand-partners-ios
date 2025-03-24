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
        placementConfig: PlacementData?,
        environment: BreadPartnersEnvironment?
    ) {
        self.brandId = integrationKey
        self.createPlacementRequestBody(
            merchantConfiguration: merchantConfiguration,
            placementData: placementConfig)
    }

    private func createPlacementRequestBody(
        merchantConfiguration: MerchantConfiguration?,
        placementData: PlacementData?
    ) {
        let context = ContextRequestBody(
            ENV: APIUrl.currentEnvironment.rawValue,
            LOCATION: placementData?.locationType?.rawValue,
            PRICE: placementData?.order?.totalPrice?.value,
            CARDHOLDER_TIER: merchantConfiguration?.cardholderTier,
            STORE_NUMBER: merchantConfiguration?.storeNumber,
            LOYALTY_ID: merchantConfiguration?.loyaltyID,
            OVERRIDE_KEY: merchantConfiguration?.overrideKey,
            CLIENT_VAR_1: merchantConfiguration?.clientVariable1,
            CLIENT_VAR_2: merchantConfiguration?.clientVariable2,
            CLIENT_VAR_3: merchantConfiguration?.clientVariable3,
            CLIENT_VAR_4: merchantConfiguration?.clientVariable4,
            DEPARTMENT_ID: merchantConfiguration?.departmentId,
            channel: merchantConfiguration?.channel,
            subchannel: merchantConfiguration?.subchannel,
            CMP: merchantConfiguration?.campaignID,
            ALLOW_CHECKOUT: placementData?.allowCheckout ?? false
        )

        let placement = PlacementRequestBody(
            id: placementData?.placementId,
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
