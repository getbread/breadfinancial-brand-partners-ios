import Foundation
import UIKit

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
    var breadPartnerDefaults: BreadPartnerDefaults
    var callback: (BreadPartnerEvents) -> Void = { _ in }
    var rtpsFlow: Bool = false
    var prescreenId: String? = nil
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
            merchantConfiguration: self.merchantConfiguration,
            placementsConfiguration: self.placementsConfiguration,
            brandConfiguration: brandConfiguration,
            recaptchaManager: recaptchaManager,
            callback: callback
        )
        self.breadPartnerDefaults = BreadPartnerDefaults.shared
        super.init()
    }

    var merchantConfiguration: MerchantConfiguration?
    var placementsConfiguration: PlacementConfiguration?
    var brandConfiguration: BrandConfigResponse?
    var onResult: ((BreadPartnerEvents) -> Void)?

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

        if self.placementsConfiguration?.popUpStyling?.actionButtonStyle == nil
        {
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
        environment: BreadSDKEnvironment = .prod,
        integrationKey: String,
        enableLog: Bool
    ) async {
        APIUrl.setEnvironment(environment)
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

        setUpInjectables()

        if brandConfiguration == nil {
            return callback(
                .sdkError(
                    error: NSError(
                        domain:
                            "Brand configurations are missing or unavailable.",
                        code: 404)))
        }

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

        setUpInjectables()
        if brandConfiguration == nil {
            return callback(
                .sdkError(
                    error: NSError(
                        domain:
                            "Brand configurations are missing or unavailable.",
                        code: 404)))
        }

        //await executeSecurityCheck()
        await fetchPlacementData()
    }

}
