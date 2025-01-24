internal struct TextPlacementModel {
    let actionType: String?
    let actionTarget: String?
    let contentText: String?
    let actionLink: String?
    let actionContentId: String?
}

internal enum PlacementActionType: String {
    case showOverlay = "SHOW_OVERLAY"
    case redirect = "REDIRECT"
    case breadApply = "BREAD_APPLY"
    case redirectInternal = "REDIRECT_INTERNAL"
    case versatileEco = "VERSATILE_ECO"
    case noAction = "NO_ACTION"    
}
