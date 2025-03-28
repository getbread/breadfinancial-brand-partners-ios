//------------------------------------------------------------------------------
//  File:          BrandConfigResponse.swift
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

/// Represents the response from the brand config API.
internal struct BrandConfigResponse: Codable {
    let config: Config
}

/// Contains the brand's configuration details.
internal struct Config: Codable {
    let AEMContent: String
    let OVERRIDE_KEY: String
    let clientName: String
    let prodAdServerUrl: String
    let qaAdServerUrl: String
    let recaptchaEnabledQA: String
    let recaptchaSiteKeyQA: String
    let test: String

    enum CodingKeys: String, CodingKey {
        case AEMContent
        case OVERRIDE_KEY
        case clientName
        case prodAdServerUrl
        case qaAdServerUrl
        case recaptchaEnabledQA
        case recaptchaSiteKeyQA
        case test
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.AEMContent =
            try container.decodeIfPresent(String.self, forKey: .AEMContent)
            ?? ""
        self.OVERRIDE_KEY =
            try container.decodeIfPresent(String.self, forKey: .OVERRIDE_KEY)
            ?? ""
        self.clientName =
            try container.decodeIfPresent(String.self, forKey: .clientName)
            ?? ""
        self.prodAdServerUrl =
            try container.decodeIfPresent(String.self, forKey: .prodAdServerUrl)
            ?? ""
        self.qaAdServerUrl =
            try container.decodeIfPresent(String.self, forKey: .qaAdServerUrl)
            ?? ""
        self.recaptchaEnabledQA =
            try container.decodeIfPresent(
                String.self, forKey: .recaptchaEnabledQA) ?? ""
        self.recaptchaSiteKeyQA =
            try container.decodeIfPresent(
                String.self, forKey: .recaptchaSiteKeyQA) ?? ""
        self.test =
            try container.decodeIfPresent(String.self, forKey: .test) ?? ""
    }
}
