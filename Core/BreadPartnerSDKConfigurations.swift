import UIKit

struct BreadPartnerSDKConfigurations {
    let configModel: PlacementRequest
    var textPlacementStyling: TextPlacementStyling?
    let enableLog: Bool
    var popUpStyling: PopUpStyling?

    init(
        configModel: PlacementRequest,
        enableLog: Bool,
        textPlacementStyling: TextPlacementStyling? = nil,
        popUpStyling: PopUpStyling? = nil
    ) {
        self.configModel = configModel
        self.enableLog = enableLog
        self.textPlacementStyling = textPlacementStyling
        self.popUpStyling = popUpStyling
    }
}
struct TextPlacementStyling {
    let normalFont: UIFont
    let normalTextColor: UIColor
    let clickableFont: UIFont?
    let clickableTextColor: UIColor
    let textViewFrame: CGRect

    init(
        normalFont: UIFont,
        normalTextColor: UIColor = .black,
        clickableFont: UIFont? = nil,
        clickableTextColor: UIColor = .blue,
        textViewFrame: CGRect
    ) {
        self.normalFont = normalFont
        self.normalTextColor = normalTextColor
        self.clickableFont = clickableFont
        self.clickableTextColor = clickableTextColor
        self.textViewFrame = textViewFrame
    }
}

struct PopUpStyling {
    let loaderColor: UIColor
    let crossColor: UIColor
    let dividerColor: UIColor
    let borderColor: CGColor
    let titlePopupTextStyle: PopupTextStyle
    let subTitlePopupTextStyle: PopupTextStyle
    let headerPopupTextStyle: PopupTextStyle
    let headerBgColor: UIColor
    let headingThreePopupTextStyle: PopupTextStyle
    let paragraphPopupTextStyle: PopupTextStyle
    let connectorPopupTextStyle: PopupTextStyle
    let disclosurePopupTextStyle: PopupTextStyle
    let actionButtonColor: UIColor

    init(
        loaderColor: UIColor = .black,
        crossColor: UIColor = .black,
        dividerColor: UIColor = .lightGray,
        borderColor: CGColor = UIColor.black.cgColor,
        titlePopupTextStyle: PopupTextStyle,
        subTitlePopupTextStyle: PopupTextStyle,
        headerPopupTextStyle: PopupTextStyle,
        headerBgColor: UIColor = .lightGray.withAlphaComponent(0.5),
        headingThreePopupTextStyle: PopupTextStyle,
        paragraphPopupTextStyle: PopupTextStyle,
        connectorPopupTextStyle: PopupTextStyle,
        disclosurePopupTextStyle: PopupTextStyle,
        actionButtonColor: UIColor = .systemBlue
    ) {
        self.loaderColor = loaderColor
        self.crossColor = crossColor
        self.dividerColor = dividerColor
        self.borderColor = borderColor
        self.titlePopupTextStyle = titlePopupTextStyle
        self.subTitlePopupTextStyle = subTitlePopupTextStyle
        self.headerPopupTextStyle = headerPopupTextStyle
        self.headerBgColor = headerBgColor
        self.headingThreePopupTextStyle = headingThreePopupTextStyle
        self.paragraphPopupTextStyle = paragraphPopupTextStyle
        self.connectorPopupTextStyle = connectorPopupTextStyle
        self.disclosurePopupTextStyle = disclosurePopupTextStyle
        self.actionButtonColor = actionButtonColor
    }
}

struct PopupTextStyle {
    var font: UIFont? = nil
    var textColor: UIColor? = nil
    var textSize: CGFloat? = nil
}

// MARK: Will be removed just used for development/testing purpose
internal struct StyleStruct {
    // Colors
    let parsedRedColor: UIColor
    let parsedGreyColor: UIColor
    let loaderColor: UIColor
    let crossColor: UIColor
    let dividerColor: UIColor
    let borderColor: UIColor
    let headerBgColor: UIColor
    let actionButtonColor: UIColor

    // Fonts
    let baseFontFamily: String
    let textSizeBold: CGFloat
    let textSizeSemiBold: CGFloat
    let textSizeRegular: CGFloat
    let textSizeSmall: CGFloat

    // Text Colors
    let normalTextColor: UIColor
    let clickableTextColor: UIColor
    let titleTextColor: UIColor
    let subTitleTextColor: UIColor
    let headerTextColor: UIColor
    let paragraphTextColor: UIColor
    let connectorTextColor: UIColor
    let disclosureTextColor: UIColor

    // Popup-specific elements
    let popupHeaderFont: UIFont?
    let popupTitleFont: UIFont?
    let popupSubTitleFont: UIFont?
    let popupParagraphFont: UIFont?
    let popupConnectorFont: UIFont?
    let popupDisclosureFont: UIFont?
}
