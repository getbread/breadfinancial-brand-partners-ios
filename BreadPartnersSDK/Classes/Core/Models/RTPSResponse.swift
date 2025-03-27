//------------------------------------------------------------------------------
//  File:          RTPSResponse.swift
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

enum PrescreenResult {
    case accountFound
    // Has been pre-approved
    case approved
    case noHit
    // Not pre-approved but should / could apply
    case makeOffer
    case acknowledge
}

let prescreenResultMap: [String: PrescreenResult] = [
    "0": .accountFound,
    "01": .approved,
    "10": .noHit,
    "11": .makeOffer,
    "12": .acknowledge
]

func getPrescreenResult(from apiResponse: String) -> PrescreenResult {
    return prescreenResultMap[apiResponse] ?? .noHit
}

struct RTPSResponse: Codable {
    let returnCode: String
    let prescreenId: Int
}

