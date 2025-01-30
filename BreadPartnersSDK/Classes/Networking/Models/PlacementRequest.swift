import Foundation

public struct PlacementRequest: Codable {
    let placements: [PlacementRequestBody]?
    let brandId: String?

    public init(placements: [PlacementRequestBody]? = nil, brandId: String? = nil) {
        self.placements = placements
        self.brandId = brandId
    }
}

public struct PlacementRequestBody: Codable {
    let id: String?
    let context: ContextRequestBody?

    public init(id: String? = nil, context: ContextRequestBody? = nil) {
        self.id = id
        self.context = context
    }
}

public struct ContextRequestBody: Codable {
    let SDK_TID: String?
    let ENV: String?
    let RTPS_ID: String?
    let BUYER_ID: String?
    let PREQUAL_ID: String?
    let PREQUAL_CREDIT_LIMIT: String?
    let LOCATION: String?
    let PRICE: Double?
    let EXISTING_CH: Bool?
    let OVERRIDE_KEY: String?
    let CLIENT_VAR_4: String?
    let channel: String?
    let subchannel: String?
    let CMP: String?
    let ALLOW_CHECKOUT: Bool?
    let UQP_PARAMS: String?
    let embeddedUrl: String?

    public init(
        SDK_TID: String? = nil,
        ENV: String? = nil,
        RTPS_ID: String? = nil,
        BUYER_ID: String? = nil,
        PREQUAL_ID: String? = nil,
        PREQUAL_CREDIT_LIMIT: String? = nil,
        LOCATION: String? = nil,
        PRICE: Double? = nil,
        EXISTING_CH: Bool? = nil,
        OVERRIDE_KEY: String? = nil,
        CLIENT_VAR_4: String? = nil,
        channel: String? = nil,
        subchannel: String? = nil,
        CMP: String? = nil,
        ALLOW_CHECKOUT: Bool? = nil,
        UQP_PARAMS: String? = nil,
        embeddedUrl: String? = nil
    ) {
        self.SDK_TID = SDK_TID
        self.ENV = ENV
        self.RTPS_ID = RTPS_ID
        self.BUYER_ID = BUYER_ID
        self.PREQUAL_ID = PREQUAL_ID
        self.PREQUAL_CREDIT_LIMIT = PREQUAL_CREDIT_LIMIT
        self.LOCATION = LOCATION
        self.PRICE = PRICE
        self.EXISTING_CH = EXISTING_CH
        self.OVERRIDE_KEY = OVERRIDE_KEY
        self.CLIENT_VAR_4 = CLIENT_VAR_4
        self.channel = channel
        self.subchannel = subchannel
        self.CMP = CMP
        self.ALLOW_CHECKOUT = ALLOW_CHECKOUT
        self.UQP_PARAMS = UQP_PARAMS
        self.embeddedUrl = embeddedUrl
    }
}
