import Foundation
import UIKit
import WebKit

internal class PopupController: UIViewController {

    var popupModel: PopupPlacementModel
    var overlayType: PlacementOverlayType

    var popupView: UIView!
    var closeButton: UIButton!
    var dividerTop: UIView!
    var brandLogo: UIImageView!
    var dividerBottom: UIView!
    var overlayProductView: UIView!
    var overlayEmbeddedView: UIView!
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    var disclosureLabel: UILabel!
    var contentContainerView: UIView!
    var headerView: UIView!
    var contentStackView: UIStackView!
    var actionButton: UIButton!
    var popupHeight: Double = 0.1
    var popupWidth: Double = 0.9
    var paddingHorizontalTen: Double = 10
    var paddingHorizontalTwenty: Double = 20
    var paddingVerticalFive: Double = 5
    var paddingVerticalTen: Double = 10
    var paddingVerticalTwenty: Double = 20
    var brandLogoHeight: Double = 50
    var brandLogoHWidth: Double = 150

    var webView: WKWebView!
    var webViewManager: BreadFinancialWebViewInterstitial!
    var webViewPlacementModel: PopupPlacementModel!

    var loader: LoaderIndicator!

    var setupConfig: BreadPartnersSetupConfig?
    var placementsConfiguration: PlacementsConfiguration?
    var brandConfiguration: BrandConfigResponse?
    var recaptchaManager: RecaptchaManagerProtocol
    var apiClient: APIClientProtocol
    var alertHandler: AlertHandlerProtocol
    var commonUtils: CommonUtilsProtocol

    let callback: ((BreadPartnerEvents) -> Void)

    init(
        setupConfig: BreadPartnersSetupConfig,
        sdkConfiguration: PlacementsConfiguration,
        popupModel: PopupPlacementModel,
        overlayType: PlacementOverlayType,
        apiClient: APIClientProtocol,
        alertHandler: AlertHandlerProtocol,
        commonUtils: CommonUtilsProtocol,
        brandConfiguration: BrandConfigResponse?,
        recaptchaManager: RecaptchaManagerProtocol,
        callback: @escaping (BreadPartnerEvents) -> Void
    ) {
        self.setupConfig = setupConfig
        self.placementsConfiguration = sdkConfiguration
        self.brandConfiguration = brandConfiguration
        self.popupModel = popupModel
        self.overlayType = overlayType
        self.apiClient = apiClient
        self.alertHandler = alertHandler
        self.commonUtils = commonUtils
        self.recaptchaManager = recaptchaManager
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.popupView.bounds != .zero, overlayType == .embeddedOverlay,
            (self.loader?.isHidden) == nil
        {
            setupLoader()
        }
        if popupModel.location == "RTPS-Approval" {
            closeButton.isHidden = true
        }
    }

    func displayEmbeddedOverlay(popupModel: PopupPlacementModel) {

        setupLoader()

        overlayProductView.isHidden = false
        overlayEmbeddedView.isHidden = false

        popupView.addSubview(overlayEmbeddedView)
        webViewManager = BreadFinancialWebViewInterstitial()

        if let url = URL(string: popupModel.webViewUrl) {
            webView = webViewManager.createWebView(with: url)
            webViewManager.onPageLoadCompleted = { url in
                self.loader.stopAnimating()
            }

            webView.translatesAutoresizingMaskIntoConstraints = false
            self.overlayEmbeddedView.addSubview(webView)
        }

        if let imageURL = URL(string: popupModel.brandLogoUrl) {
            brandLogo.loadImage(from: imageURL) { success in
                if success {} else {}
            }
        }

        overlayEmbeddedConstraints()
    }
}
