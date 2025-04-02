//------------------------------------------------------------------------------
//  File:          PopupButtonActionExtension.swift
//  Author(s):     Bread Financial
//  Date:          27 March 2025
//
//  Descriptions:  This file is part of the BreadPartnersSDK for iOS,
//  providing UI components and functionalities to integrate Bread Financial
//  services into partner applications.
//
//  © 2025 Bread Financial
//------------------------------------------------------------------------------

import Foundation

extension PopupController {
    
    /// Handles the close button tap event..
    @objc func closeButtonTapped() {
        callback(.popupClosed)
        dismiss(animated: true, completion: nil)
    }

    /// Handles the action button tap event. 
    @objc func actionButtonTapped() {
        callback(.actionButtonTapped)
        if let placementModel = webViewPlacementModel {
            displayEmbeddedOverlay(popupModel: placementModel)
        } else {
            callback(
                .sdkError(
                    error: NSError(
                        domain: "", code: 500,
                        userInfo: [
                            NSLocalizedDescriptionKey:
                                Constants.somethingWentWrong
                        ])))
        }
    }
}
