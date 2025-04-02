//------------------------------------------------------------------------------
//  File:          RecaptchaManager.swift
//  Author(s):     Bread Financial
//  Date:          27 March 2025
//
//  Descriptions:  This file is part of the BreadPartnersSDK for iOS,
//  providing UI components and functionalities to integrate Bread Financial
//  services into partner applications.
//
//  © 2025 Bread Financial
//------------------------------------------------------------------------------

import RecaptchaEnterprise

/// `RecaptchaManager` handles the process of executing a reCAPTCHA for verifying user actions.
internal class RecaptchaManager {

    private let logger: Logger

    init(logger: Logger = Logger()) {
        self.logger = logger
    }

    func executeReCaptcha(
        siteKey: String,
        action: RecaptchaAction,
        timeout: Double = 10000,
        debug: Bool = false
    ) async throws -> String {
        let client = try await Recaptcha.fetchClient(withSiteKey: siteKey)
        let token = try await client.execute(
            withAction: action, withTimeout: timeout)

        if debug {
            logger.logReCaptchaToken(token: token)
        }
        return token
    }

}
