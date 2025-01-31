import UIKit

public struct PlacementsConfiguration {
    public let placementConfig: BreadPartnersPlacementConfig?
    public let rtpsConfig: BreadPartnersRtpsConfig?
    public var textPlacementStyling: TextPlacementStyling?
    public var popUpStyling: PopUpStyling?

    public init(
        placementConfig: BreadPartnersPlacementConfig? = nil,
        rtpsConfig: BreadPartnersRtpsConfig? = nil,
        textPlacementStyling: TextPlacementStyling? = nil,
        popUpStyling: PopUpStyling? = nil
    ) {
        self.placementConfig = placementConfig
        self.rtpsConfig = rtpsConfig
        self.textPlacementStyling = textPlacementStyling
        self.popUpStyling = popUpStyling
    }
}
public struct TextPlacementStyling {
    public let normalFont: UIFont
    public let normalTextColor: UIColor

    public let clickableFont: UIFont?
    public let clickableTextColor: UIColor

    public let textViewFrame: CGRect

    public let buttonFont: UIFont?
    public let buttonTextColor: UIColor?
    public let buttonFrame: CGRect?
    public let buttonPadding: UIEdgeInsets?
    public let buttonBackgroundColor: UIColor?
    public let buttonCornerRadius: CGFloat?

    public init(
        normalFont: UIFont,
        normalTextColor: UIColor = .black,
        clickableFont: UIFont? = nil,
        clickableTextColor: UIColor = .blue,
        textViewFrame: CGRect,
        buttonFont: UIFont? = nil,
        buttonTextColor: UIColor = .blue,
        buttonFrame: CGRect? = CGRect(x: 0, y: 0, width: 200, height: 45),
        buttonPadding: UIEdgeInsets = .zero,
        buttonBackgroundColor: UIColor = .blue,
        buttonCornerRadius: CGFloat = 10.0
    ) {
        self.normalFont = normalFont
        self.normalTextColor = normalTextColor
        self.clickableFont = clickableFont
        self.clickableTextColor = clickableTextColor
        self.textViewFrame = textViewFrame
        self.buttonFont = buttonFont
        self.buttonTextColor = buttonTextColor
        self.buttonFrame = buttonFrame
        self.buttonPadding = buttonPadding
        self.buttonBackgroundColor = buttonBackgroundColor
        self.buttonCornerRadius = buttonCornerRadius
    }
}

public struct PopUpStyling {
    public let loaderColor: UIColor
    public let crossColor: UIColor
    public let dividerColor: UIColor
    public let borderColor: CGColor
    public let titlePopupTextStyle: PopupTextStyle
    public let subTitlePopupTextStyle: PopupTextStyle
    public let headerPopupTextStyle: PopupTextStyle
    public let headerBgColor: UIColor
    public let headingThreePopupTextStyle: PopupTextStyle
    public let paragraphPopupTextStyle: PopupTextStyle
    public let connectorPopupTextStyle: PopupTextStyle
    public let disclosurePopupTextStyle: PopupTextStyle
    public var actionButtonStyle: PopupActionButtonStyle?

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
        actionButtonStyle: PopupActionButtonStyle? = nil
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
        self.actionButtonStyle = actionButtonStyle
    }
}

public struct PopupTextStyle {
    public var font: UIFont? = nil
    public var textColor: UIColor? = nil
    public var textSize: CGFloat? = nil

    public init(
        font: UIFont? = nil, textColor: UIColor? = nil, textSize: CGFloat? = nil
    ) {
        self.font = font
        self.textColor = textColor
        self.textSize = textSize
    }
}

public struct PopupActionButtonStyle {
    public var font: UIFont?
    public var textColor: UIColor?
    public var frame: CGRect?
    public var backgroundColor: UIColor?
    public var cornerRadius: CGFloat?
    public var padding: UIEdgeInsets?

    public init(
        font: UIFont? = nil,
        textColor: UIColor? = nil,
        frame: CGRect? = nil,
        backgroundColor: UIColor? = nil,
        cornerRadius: CGFloat? = nil,
        padding: UIEdgeInsets? = nil
    ) {
        self.font = font
        self.textColor = textColor
        self.frame = frame
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.padding = padding
    }
}

// MARK: Will be used for development/testing purpose
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
