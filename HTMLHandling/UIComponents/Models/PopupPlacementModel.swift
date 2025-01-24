internal struct PopupPlacementModel {
    var overlayType: String
    var location: String?
    var brandLogoUrl: String
    var webViewUrl: String
    var overlayTitle: String
    var overlaySubtitle: String
    var overlayContainerBarHeading: String
    var bodyHeader: String
    var primaryActionButtonAttributes: PrimaryActionButtonModel?
    var dynamicBodyModel: DynamicBodyModel
    var disclosure: String
    
    struct DynamicBodyModel {
        var bodyDiv: [String: DynamicBodyContent]
    }
    
    struct DynamicBodyContent {
        var tagValuePairs: [String: String]
    }
}

internal struct PrimaryActionButtonModel {
    var dataOverlayType: String?
    var dataContentFetch: String?
    var dataActionTarget: String?
    var dataActionType: String?
    var dataActionContentId: String?
    var dataLocation: String?
    var buttonText: String?
    
    init(dataOverlayType: String? = nil,
         dataContentFetch: String? = nil,
         dataActionTarget: String? = nil,
         dataActionType: String? = nil,
         dataActionContentId: String? = nil,
         dataLocation: String? = nil,
         buttonText: String? = nil) {
        self.dataOverlayType = dataOverlayType
        self.dataContentFetch = dataContentFetch
        self.dataActionTarget = dataActionTarget
        self.dataActionType = dataActionType
        self.dataActionContentId = dataActionContentId
        self.dataLocation = dataLocation
        self.buttonText = buttonText
    }
}

internal enum PlacementOverlayType: String {
    case embeddedOverlay = "EMBEDDED_OVERLAY"
    case singleProductOverlay = "SINGLE_PRODUCT_OVERLAY"
}
