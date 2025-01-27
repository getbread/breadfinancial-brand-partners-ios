import UIKit

public struct PlacementsConfiguration {
    let configModel: PlacementRequest
    var textPlacementStyling: TextPlacementStyling?
    var popUpStyling: PopUpStyling?

    public init(
        configModel: PlacementRequest,
        textPlacementStyling: TextPlacementStyling? = nil,
        popUpStyling: PopUpStyling? = nil
    ) {
        self.configModel = configModel
        self.textPlacementStyling = textPlacementStyling
        self.popUpStyling = popUpStyling
    }
}
public struct TextPlacementStyling {
    let normalFont: UIFont
    let normalTextColor: UIColor
    let clickableFont: UIFont?
    let clickableTextColor: UIColor
    let textViewFrame: CGRect

    public init(
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

public struct PopUpStyling {
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

    public init(
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

public struct PopupTextStyle {
    var font: UIFont? = nil
    var textColor: UIColor? = nil
    var textSize: CGFloat? = nil
    
    public init(font: UIFont? = nil, textColor: UIColor? = nil, textSize: CGFloat? = nil) {
        self.font = font
        self.textColor = textColor
        self.textSize = textSize
    }
}

// MARK: Will be removed just used for development/testing purpose
public struct StyleStruct {
    // Colors
    public let parsedRedColor: UIColor
    public let parsedGreyColor: UIColor
    public let loaderColor: UIColor
    public let crossColor: UIColor
    public let dividerColor: UIColor
    public let borderColor: UIColor
    public let headerBgColor: UIColor
    public let actionButtonColor: UIColor

    // Fonts
    public let baseFontFamily: String
    public let textSizeBold: CGFloat
    public let textSizeSemiBold: CGFloat
    public let textSizeRegular: CGFloat
    public let textSizeSmall: CGFloat

    // Text Colors
    public let normalTextColor: UIColor
    public let clickableTextColor: UIColor
    public let titleTextColor: UIColor
    public let subTitleTextColor: UIColor
    public let headerTextColor: UIColor
    public let paragraphTextColor: UIColor
    public let connectorTextColor: UIColor
    public let disclosureTextColor: UIColor

    // Popup-specific elements
    public let popupHeaderFont: UIFont?
    public let popupTitleFont: UIFont?
    public let popupSubTitleFont: UIFont?
    public let popupParagraphFont: UIFont?
    public let popupConnectorFont: UIFont?
    public let popupDisclosureFont: UIFont?
    
    public init(
           parsedRedColor: UIColor,
           parsedGreyColor: UIColor,
           loaderColor: UIColor,
           crossColor: UIColor,
           dividerColor: UIColor,
           borderColor: UIColor,
           headerBgColor: UIColor,
           actionButtonColor: UIColor,
           baseFontFamily: String,
           textSizeBold: CGFloat,
           textSizeSemiBold: CGFloat,
           textSizeRegular: CGFloat,
           textSizeSmall: CGFloat,
           normalTextColor: UIColor,
           clickableTextColor: UIColor,
           titleTextColor: UIColor,
           subTitleTextColor: UIColor,
           headerTextColor: UIColor,
           paragraphTextColor: UIColor,
           connectorTextColor: UIColor,
           disclosureTextColor: UIColor,
           popupHeaderFont: UIFont? = nil,
           popupTitleFont: UIFont? = nil,
           popupSubTitleFont: UIFont? = nil,
           popupParagraphFont: UIFont? = nil,
           popupConnectorFont: UIFont? = nil,
           popupDisclosureFont: UIFont? = nil
       ) {
           self.parsedRedColor = parsedRedColor
           self.parsedGreyColor = parsedGreyColor
           self.loaderColor = loaderColor
           self.crossColor = crossColor
           self.dividerColor = dividerColor
           self.borderColor = borderColor
           self.headerBgColor = headerBgColor
           self.actionButtonColor = actionButtonColor
           self.baseFontFamily = baseFontFamily
           self.textSizeBold = textSizeBold
           self.textSizeSemiBold = textSizeSemiBold
           self.textSizeRegular = textSizeRegular
           self.textSizeSmall = textSizeSmall
           self.normalTextColor = normalTextColor
           self.clickableTextColor = clickableTextColor
           self.titleTextColor = titleTextColor
           self.subTitleTextColor = subTitleTextColor
           self.headerTextColor = headerTextColor
           self.paragraphTextColor = paragraphTextColor
           self.connectorTextColor = connectorTextColor
           self.disclosureTextColor = disclosureTextColor
           self.popupHeaderFont = popupHeaderFont
           self.popupTitleFont = popupTitleFont
           self.popupSubTitleFont = popupSubTitleFont
           self.popupParagraphFont = popupParagraphFont
           self.popupConnectorFont = popupConnectorFont
           self.popupDisclosureFont = popupDisclosureFont
       }
}
