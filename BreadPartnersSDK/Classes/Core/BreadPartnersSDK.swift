import Foundation
import UIKit

public class BreadPartnersSDK: NSObject, UITextViewDelegate {

    public static var shared: BreadPartnersSDK = {
        let instance = BreadPartnersSDK()
        return instance
    }()

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
    var callback: ((BreadPartnerEvents) -> Void) = { _ in }
    var rtpsFlow: Bool = false
    var prescreenId: String? = nil

    private override init() {
        self.logger = Logger()
        self.alertHandler = AlertHandler(
            windowScene: UIApplication.shared.connectedScenes.first
                as? UIWindowScene)
        self.commonUtils = CommonUtils(
            dispatchQueue: .main, alertHandler: self.alertHandler)
        self.apiClient = APIClient(
            urlSession: URLSession.shared, logger: self.logger)
        self.recaptchaManager = RecaptchaManager(logger: self.logger)
        self.analyticsManager = AnalyticsManager(
            apiClient: self.apiClient,
            commonUtils: self.commonUtils,
            dispatchQueue: DispatchQueue.global(qos: .background))
        self.swiftSoupParser = SwiftSoupParser()
        self.htmlContentParser = HTMLContentParser(
            htmlParser: self.swiftSoupParser)
        self.htmlContentRenderer = HTMLContentRenderer(
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
            callback: callback)
        self.breadPartnerDefaults = BreadPartnerDefaults.shared
        super.init()
    }

    var setupConfig: BreadPartnersSetupConfig?
    var placementsConfiguration: PlacementsConfiguration?
    var brandConfiguration: BrandConfigResponse?
    var onResult: ((BreadPartnerEvents) -> Void)?

    func setUpInjectables() {
        if self.placementsConfiguration?.textPlacementStyling == nil {
            self.placementsConfiguration?.textPlacementStyling =
                breadPartnerDefaults.textPlacementStyling
        }
        if self.placementsConfiguration?.popUpStyling == nil {
            self.placementsConfiguration?.popUpStyling =
                breadPartnerDefaults.popUpStyling
        }

        self.htmlContentRenderer = HTMLContentRenderer(
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
            callback: self.callback
        )
    }

    public func setup(setupConfig: BreadPartnersSetupConfig) {
        self.setupConfig = setupConfig
        self.logger.isLoggingEnabled = setupConfig.enableLog
    }

    public func registerPlacements(
        placementsConfiguration: PlacementsConfiguration,
        callback: @escaping (BreadPartnerEvents) -> Void
    ) {
        self.placementsConfiguration = placementsConfiguration
        self.callback = callback

        setUpInjectables()

        fetchBrandConfig()
    }

    public func submitRTPS(
        placementsConfiguration: PlacementsConfiguration,
        callback: @escaping (BreadPartnerEvents) -> Void
    ) {
        self.placementsConfiguration = placementsConfiguration
        self.callback = callback
        self.rtpsFlow = true

        setUpInjectables()

        fetchBrandConfig()
    }

}
