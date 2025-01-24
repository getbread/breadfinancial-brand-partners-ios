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
            sdkConfiguration: self.sdkConfiguration,
            brandConfiguration: brandConfiguration,
            recaptchaManager: recaptchaManager,
            callback: callback)
        self.breadPartnerDefaults = BreadPartnerDefaults.shared
        super.init()
    }

    var sdkConfiguration: BreadPartnerSDKConfigurations?
    var brandConfiguration: BrandConfigResponse?
    var onResult: ((BreadPartnerEvents) -> Void)?

    func loadPlacementUI(
        with configuration: BreadPartnerSDKConfigurations,
        callback: @escaping (BreadPartnerEvents) -> Void
    ) {
        self.sdkConfiguration = configuration
        self.brandConfiguration = BrandConfigResponse(config: Config())
        self.callback = callback

        if sdkConfiguration?.textPlacementStyling == nil {
            sdkConfiguration?.textPlacementStyling =
                breadPartnerDefaults.textPlacementStyling
        }
        if sdkConfiguration?.popUpStyling == nil {
            sdkConfiguration?.popUpStyling =
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
            sdkConfiguration: self.sdkConfiguration,
            brandConfiguration: brandConfiguration,
            recaptchaManager: recaptchaManager,
            callback: callback
        )

        logger.isLoggingEnabled = configuration.enableLog

        fetchBrandConfig()        
    }

}
