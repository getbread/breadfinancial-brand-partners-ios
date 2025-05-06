//------------------------------------------------------------------------------
//  File:          PlacementConfiguration.swift
//  Author(s):     Bread Financial
//  Date:          27 March 2025
//
//  Descriptions:  This file is part of the BreadPartnersSDK for iOS,
//  providing UI components and functionalities to integrate Bread Financial
//  services into partner applications.
//
//  © 2025 Bread Financial
//------------------------------------------------------------------------------

import UIKit

/// Structure that used to provide configurations for  `registerPlacement` or `submitRTPS` methods.
/// - Parameters:
///   - placementData: Defines text placements on the brand partner screen for the `registerPlacementFlow`.
///   - rtpsData: Specifies the real-time pre-screen configuration for the prescreen flow.
///   - popUpStyling: Configures the popup styling for each element rendered within the popup.
public struct PlacementConfiguration {
    public let placementData: PlacementData?
    public let rtpsData: RTPSData?
    public var popUpStyling: PopUpStyling?

    public init(
        placementData: PlacementData? = nil,
        rtpsData: RTPSData? = nil,
        popUpStyling: PopUpStyling? = nil
    ) {
        self.placementData = placementData
        self.rtpsData = rtpsData
        self.popUpStyling = popUpStyling
    }
}

/// Structure used to provides styling configurations for the `PopupController`.
///
/// - Colors are defined using `UIColor` or `CGColor` for various popup elements like header background, border..
/// - Text style are configured using `PopupTextStyle`structure  for titles, headers, and other text elements.
/// - Button style can be optionally specified using `PopupActionButtonStyle`.
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

/// Structure that defines text styling config for popup elements.
///
/// - `font`: Specifies the font family and font size for the text.
/// - `textColor`: Specifies the color of the text.
public struct PopupTextStyle {
    public var font: UIFont? = nil
    public var textColor: UIColor? = nil

    public init(
        font: UIFont? = nil, textColor: UIColor? = nil
    ) {
        self.font = font
        self.textColor = textColor
    }
}

/// Structure that defines style configurations for action buttons in popups.
///
/// - `font`: Specifies the font for the button title.
/// - `textColor`: Specifies the color of the button title text.
/// - `backgroundColor`: Specifies the background color of the button.
/// - `cornerRadius`: Specifies the corner radius for rounded button edges.
/// - `padding`: Specifies the padding within the button and title.
public struct PopupActionButtonStyle {
    public var font: UIFont?
    public var textColor: UIColor?
    public var backgroundColor: UIColor?
    public var cornerRadius: CGFloat?
    public var padding: UIEdgeInsets?

    public init(
        font: UIFont? = nil,
        textColor: UIColor? = nil,
        backgroundColor: UIColor? = nil,
        cornerRadius: CGFloat? = nil,
        padding: UIEdgeInsets? = nil
    ) {
        self.font = font
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.padding = padding
    }
}
