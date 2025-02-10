import Foundation
import UIKit

public class BreadPartnersSDK: NSObject, UITextViewDelegate {

    public static var shared: BreadPartnersSDK = {
        let instance = BreadPartnersSDK()
        return instance
    }()

    var integrationKey: String = ""

    var logger: LoggerProtocol
    var alertHandler: AlertHandlerProtocol
    var commonUtils: CommonUtilsProtocol
    var apiClient: APIClientProtocol
    var recaptchaManager: RecaptchaManagerProtocol
    var analyticsManager: AnalyticsManagerProtocol
    var swiftSoupParser: HTMLParserProtocol
    var htmlContentParser: HTMLContentParserProtocol
    var htmlContentRenderer: HTMLContentRendererProtocol
    var breadPartnerDefaults: BreadPartnerDefaults
    var callback:
    (
        (
            BreadPartnerEvents
        ) -> Void
    ) = {
        _ in
    }
    var rtpsFlow: Bool = false
    var prescreenId: String? = nil
    var splitTextAndAction: Bool = false

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
            logger: self.logger
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
            setupConfig: self.setupConfig,
            placementsConfiguration: self.placementsConfiguration,
            brandConfiguration: brandConfiguration,
            recaptchaManager: recaptchaManager,
            callback: callback
        )
        self.breadPartnerDefaults = BreadPartnerDefaults.shared
        super.init()
    }

    var setupConfig: BreadPartnersSetupConfig?
    var placementsConfiguration: PlacementsConfiguration?
    var brandConfiguration: BrandConfigResponse?
    var onResult:
    (
        (
            BreadPartnerEvents
        ) -> Void
    )?

    func setUpInjectables() {

        /// Default Popup action button style
        let actionButtonStyle = PopupActionButtonStyle(
            font: UIFont.boldSystemFont(ofSize: 18),
            textColor: .white,
            frame: CGRect(x: 20, y: 100, width: 200, height: 50),
            backgroundColor: UIColor(hex: "#d50132"),
            cornerRadius: 8.0,
            padding: UIEdgeInsets(
                top: 8, left: 16, bottom: 8, right: 16)
        )

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
                textColor: .black,
                textSize: 16.0
            ),
            subTitlePopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: "Arial-BoldMT",
                    size: 12.0
                ),
                textColor: .gray,
                textSize: 12.0
            ),
            headerPopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: "Arial-BoldMT",
                    size: 14.0
                ),
                textColor: .gray,
                textSize: 14.0
            ),
            headerBgColor: UIColor(hex: "#ececec"),
            headingThreePopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: "Arial-BoldMT",
                    size: 14.0
                ),
                textColor: UIColor(hex: "#d50132"),
                textSize: 14.0
            ),
            paragraphPopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: "Arial-BoldMT",
                    size: 10.0
                ),
                textColor: .gray,
                textSize: 10.0
            ),
            connectorPopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: "Arial-BoldMT",
                    size: 14.0
                ),
                textColor: .black,
                textSize: 14.0
            ),
            disclosurePopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: "Arial-BoldMT",
                    size: 10.0
                ),
                textColor: .gray,
                textSize: 10.0
            ),
            actionButtonStyle: actionButtonStyle
        )

        if self.placementsConfiguration?.popUpStyling == nil {
            self.placementsConfiguration?.popUpStyling = popupStyle
        }

        if self.placementsConfiguration?.popUpStyling?.actionButtonStyle == nil {
            self.placementsConfiguration?.popUpStyling?.actionButtonStyle =
            actionButtonStyle
        }

        self.htmlContentRenderer = HTMLContentRenderer(
            integrationKey: integrationKey,
            apiClient: self.apiClient,
            alertHandler: self.alertHandler,
            commonUtils: self.commonUtils,
            analyticsManager: self.analyticsManager,
            logger: self.logger,
            htmlContentParser: self.htmlContentParser,
            dispatchQueue: DispatchQueue.main,
            setupConfig: self.setupConfig,
            placementsConfiguration: self.placementsConfiguration,
            brandConfiguration: self.brandConfiguration,
            recaptchaManager: self.recaptchaManager,
            splitTextAndAction: self.splitTextAndAction,
            callback: self.callback
        )
    }

    /// Call this function when the app launches.
    /// - Parameters:
    ///   - integrationKey: A unique key specific to the brand.
    ///   - enableLog: Set this to `true` if you want to see debug logs.
    public func setup(
        environment: BreadSDKEnvironment = .prod,
        integrationKey: String,
        enableLog: Bool
    ) {
        APIUrl.setEnvironment(environment)
        self.integrationKey = integrationKey
        self.logger.isLoggingEnabled = enableLog

        return fetchBrandConfig()
    }

    /// Use this function to display text placements in your app's UI.
    /// - Parameters:
    ///   - setupConfig: Provide user account details in this configuration.
    ///   - placementsConfiguration: Specify the pre-defined placement details required for building the UI.
    ///   - splitTextAndAction: Set this to `true` if you want the placement to return either text with a link or a combination of text and button.
    ///   - callback: A function that handles user interactions and ongoing events related to the placements.
    public func registerPlacements(
        setupConfig: BreadPartnersSetupConfig,
        placementsConfiguration: PlacementsConfiguration,
        splitTextAndAction: Bool = false,
        callback: @escaping (
            BreadPartnerEvents
        ) -> Void
    ) {
        self.setupConfig = setupConfig
        self.placementsConfiguration = placementsConfiguration
        self.splitTextAndAction = splitTextAndAction
        self.callback = callback
        self.rtpsFlow = false

        setUpInjectables()

        if brandConfiguration == nil {
            return callback(
                .sdkError(
                    error: NSError(
                        domain:
                            "Brand configurations are missing or unavailable.",
                        code: 404)))
        }

        fetchPlacementData()

    }

    /// Call this function to check if the user qualifies for a pre-screen card application.
    /// - Parameters:
    ///   - setupConfig: Provide user account details in this configuration.
    ///   - placementsConfiguration: Specify the pre-defined placement details required for building the UI.
    ///   - callback: A function that handles user interactions and ongoing events related to the placements.
    public func submitRTPS(
        setupConfig: BreadPartnersSetupConfig,
        placementsConfiguration: PlacementsConfiguration,
        callback: @escaping (
            BreadPartnerEvents
        ) -> Void
    ) {
        self.setupConfig = setupConfig
        self.placementsConfiguration = placementsConfiguration
        self.callback = callback
        self.rtpsFlow = true

        setUpInjectables()
        if brandConfiguration == nil {
            return callback(
                .sdkError(
                    error: NSError(
                        domain:
                            "Brand configurations are missing or unavailable.",
                        code: 404)))
        }

        //                        executeSecurityCheck()
        //                        preScreenLookupCall(token: "")
        fetchPlacementData()
    }

}
