//------------------------------------------------------------------------------
//  File:          BreadPartnersSDK.swift
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
import UIKit

/// The primary interface class for interacting with the Bread Partners SDK.
/// Provides entry points for initialization, configuration, and SDK-level actions.
public class BreadPartnersSDK: NSObject, UITextViewDelegate {

    public static var shared: BreadPartnersSDK = {
        let instance = BreadPartnersSDK()
        return instance
    }()

    var integrationKey: String = ""

    var logger: Logger
    var alertHandler: AlertHandler
    var commonUtils: CommonUtils
    var apiClient: APIClient
    var recaptchaManager: RecaptchaManager
    var analyticsManager: AnalyticsManager
    var swiftSoupParser: SwiftSoupParser
    var htmlContentParser: HTMLContentParser
    var htmlContentRenderer: HTMLContentRenderer
    var callback: (BreadPartnerEvents) -> Void = { _ in }
    var rtpsFlow: Bool = false
    var openPlacementExperience: Bool = false
    var prescreenId: Int? = nil
    var splitTextAndAction: Bool = false
    var forSwiftUI: Bool = false

    private override init() {
        self.logger = Logger()
        self.alertHandler = AlertHandler(
            windowScene: UIApplication.shared.connectedScenes.first
                as? UIWindowScene
        )
        self.commonUtils = CommonUtils(
            dispatchQueue: .main,
            alertHandler: self.alertHandler
        )
        self.apiClient = APIClient(
            urlSession: URLSession.shared,
            logger: self.logger,
            commonUtils: self.commonUtils
        )
        self.recaptchaManager = RecaptchaManager(
            logger: self.logger
        )
        self.analyticsManager = AnalyticsManager(
            apiClient: self.apiClient,
            commonUtils: self.commonUtils,
            dispatchQueue:
                DispatchQueue
                .global(
                    qos: .background
                )
        )
        self.swiftSoupParser = SwiftSoupParser()
        self.htmlContentParser = HTMLContentParser(
            htmlParser: self.swiftSoupParser
        )
        self.htmlContentRenderer = HTMLContentRenderer(
            integrationKey: "",
            apiClient: self.apiClient,
            alertHandler: self.alertHandler,
            commonUtils: self.commonUtils,
            analyticsManager: self.analyticsManager,
            logger: self.logger,
            htmlContentParser: self.htmlContentParser,
            dispatchQueue: DispatchQueue.main,
            merchantConfiguration: self.merchantConfiguration,
            placementsConfiguration: self.placementsConfiguration,
            brandConfiguration: brandConfiguration,
            recaptchaManager: recaptchaManager,
            callback: callback
        )
        super.init()
    }

    var sdkEnvironment: BreadPartnersEnvironment = .stage
    var merchantConfiguration: MerchantConfiguration?
    var placementsConfiguration: PlacementConfiguration?
    var brandConfiguration: BrandConfigResponse?
    var onResult: ((BreadPartnerEvents) -> Void)?

    func setUpInjectables() {
        
        self.logger.callback = callback
        
        if brandConfiguration == nil {
            return callback(
                .sdkError(
                    error: NSError(
                        domain:
                            "Brand configurations are missing or unavailable.",
                        code: 404)))
        }

        
        if self.placementsConfiguration?.popUpStyling == nil {
            self.placementsConfiguration?.popUpStyling = BreadPartnerDefaults.shared.popupStyle
        }
        
        merchantConfiguration?.env = sdkEnvironment
        
        alertHandler.setUpAlerts(rtpsFlow, logger, callback)

        analyticsManager.setApiKey(integrationKey)
        
        self.htmlContentRenderer = HTMLContentRenderer(
            integrationKey: integrationKey,
            apiClient: self.apiClient,
            alertHandler: self.alertHandler,
            commonUtils: self.commonUtils,
            analyticsManager: self.analyticsManager,
            logger: self.logger,
            htmlContentParser: self.htmlContentParser,
            dispatchQueue: DispatchQueue.main,
            merchantConfiguration: self.merchantConfiguration,
            placementsConfiguration: self.placementsConfiguration,
            brandConfiguration: self.brandConfiguration,
            recaptchaManager: self.recaptchaManager,
            splitTextAndAction: self.splitTextAndAction,
            forSwiftUI: self.forSwiftUI,
            callback: self.callback
        )
    }

    /// Call this function when the app launches.
    /// - Parameters:
    ///   - integrationKey: A unique key specific to the brand.
    ///   - enableLog: Set this to `true` if you want to see debug logs.
    ///   - environment: Specifies the SDK environment, such as production (.prod) or development (stage).
    public func setup(
        environment: BreadPartnersEnvironment = .prod,
        integrationKey: String,
        enableLog: Bool
    ) async {
        APIUrl.setEnvironment(environment)
        sdkEnvironment = environment
        self.integrationKey = integrationKey
        self.logger.isLoggingEnabled = enableLog
        return await fetchBrandConfig()
    }

    /// Use this function to display text placements in your app's UI.
    /// - Parameters:
    ///   - merchantConfiguration: Provide user account details in this configuration.
    ///   - placementsConfiguration: Specify the pre-defined placement details required for building the UI.
    ///   - splitTextAndAction: Set this to `true` if you want the placement to return either text with a link or a combination of text and button.
    ///   - forSwiftUI: A Boolean flag indicating whether the text view should be created as a SwiftUI-compatible view.
    ///   - callback: A function that handles user interactions and ongoing events related to the placements.
    public func registerPlacements(
        merchantConfiguration: MerchantConfiguration,
        placementsConfiguration: PlacementConfiguration,
        splitTextAndAction: Bool = false,
        forSwiftUI: Bool = false,
        callback: @escaping (
            BreadPartnerEvents
        ) -> Void
    ) async {
        self.merchantConfiguration = merchantConfiguration
        self.placementsConfiguration = placementsConfiguration
        self.splitTextAndAction = splitTextAndAction
        self.forSwiftUI = forSwiftUI
        self.callback = callback
        self.rtpsFlow = false
        self.openPlacementExperience = false

        setUpInjectables()

        await fetchPlacementData()

    }

    /// Calls this function to check if the user qualifies for a pre-screen card application.
    /// This call will be completely silent with no impact on user behavior.
    /// Everything will be managed within the SDK, and the brand partner's application only needs to send metadata.
    /// If any step fails within the RTPS flow, the user will not experience any UI behavior changes.
    /// If RTPS succeeds, a popup should be displayed via the callback to show the "Approved" flow.
    ///
    /// - Parameters:
    ///   - merchantConfiguration: Provide user account details in this configuration.
    ///   - placementsConfiguration: Specify the pre-defined placement details required for building the UI.
    ///   - splitTextAndAction: Set this to `true` if you want the placement to return either text with a link or a combination of text and button.
    ///   - forSwiftUI: A Boolean flag indicating whether the text view should be created as a SwiftUI-compatible view.
    ///   - callback: A function that handles user interactions and ongoing events related to the placements.
    public func silentRTPSRequest(
        merchantConfiguration: MerchantConfiguration,
        placementsConfiguration: PlacementConfiguration,
        splitTextAndAction: Bool = false,
        forSwiftUI: Bool = false,
        callback: @escaping (
            BreadPartnerEvents
        ) -> Void
    ) async {
        self.merchantConfiguration = merchantConfiguration
        self.placementsConfiguration = placementsConfiguration
        self.splitTextAndAction = splitTextAndAction
        self.forSwiftUI = forSwiftUI
        self.callback = callback
        self.rtpsFlow = true
        self.openPlacementExperience = false

        setUpInjectables()

//        await executeSecurityCheck()
        await preScreenLookupCall(token: "\(UUID().uuidString)")
    }

    /// Display an overlay to the customer without requiring them to click on a placement to trigger it.
    /// - Parameters:
    ///   - merchantConfiguration: Provide user account details in this configuration.
    ///   - placementsConfiguration: Specify the pre-defined placement details required for building the UI.
    ///   - forSwiftUI: A Boolean flag indicating whether the text view should be created as a SwiftUI-compatible view.
    ///   - callback: A function that handles user interactions and ongoing events related to the placements.
    public func openExperienceForPlacement(
        merchantConfiguration: MerchantConfiguration,
        placementsConfiguration: PlacementConfiguration,
        forSwiftUI: Bool = false,
        callback: @escaping (
            BreadPartnerEvents
        ) -> Void
    ) async {
        self.merchantConfiguration = merchantConfiguration
        self.placementsConfiguration = placementsConfiguration
        self.forSwiftUI = forSwiftUI
        self.callback = callback
        self.rtpsFlow = false
        self.openPlacementExperience = true

        setUpInjectables()

        await fetchPlacementData()

    }

}
