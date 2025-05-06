//------------------------------------------------------------------------------
//  File:          BreadPartnerDefaults.swift
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

/// `BreadPartnerDefaults` class provides default configurations/styles/properties used across the BreadPartner SDK.
public class BreadPartnerDefaults: NSObject {

    public static let shared = BreadPartnerDefaults()

    private override init() {}

    /// Default Popup Style
    let popupStyle = PopUpStyling(
        loaderColor: UIColor(hex: "#0f2233"),
        crossColor: .black,
        dividerColor: UIColor(hex: "#ececec"),
        borderColor: UIColor(hex: "#ececec").cgColor,
        titlePopupTextStyle: PopupTextStyle(
            font: UIFont(
                name: "Arial-BoldMT",
                size: 16.0
            ),
            textColor: .black
        ),
        subTitlePopupTextStyle: PopupTextStyle(
            font: UIFont(
                name: "Arial-BoldMT",
                size: 12.0
            ),
            textColor: .gray
        ),
        headerPopupTextStyle: PopupTextStyle(
            font: UIFont(
                name: "Arial-BoldMT",
                size: 14.0
            ),
            textColor: .gray
        ),
        headerBgColor: UIColor(hex: "#ececec"),
        headingThreePopupTextStyle: PopupTextStyle(
            font: UIFont(
                name: "Arial-BoldMT",
                size: 14.0
            ),
            textColor: UIColor(hex: "#d50132")
        ),
        paragraphPopupTextStyle: PopupTextStyle(
            font: UIFont(
                name: "Arial-BoldMT",
                size: 10.0
            ),
            textColor: .gray
        ),
        connectorPopupTextStyle: PopupTextStyle(
            font: UIFont(
                name: "Arial-BoldMT",
                size: 14.0
            ),
            textColor: .black
        ),
        disclosurePopupTextStyle: PopupTextStyle(
            font: UIFont(
                name: "Arial-BoldMT",
                size: 10.0
            ),
            textColor: .gray
        ),
        actionButtonStyle: PopupActionButtonStyle(
            font: UIFont.boldSystemFont(ofSize: 18),
            textColor: .white,
            backgroundColor: UIColor(hex: "#d50132"),
            cornerRadius: 8.0,
            padding: UIEdgeInsets(
                top: 8, left: 16, bottom: 8, right: 16)
        )
    )
}
