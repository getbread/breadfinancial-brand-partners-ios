//------------------------------------------------------------------------------
//  File:          PopupController.swift
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
import WebKit

internal class PopupController: UIViewController {

    var integrationKey: String
    var popupModel: PopupPlacementModel
    var overlayType: PlacementOverlayType

    var popupView: UIView!
    var closeButton: UIButton!
    var dividerTop: UIView!
    var brandLogo: UIImageView!
    var topRowView: UIView!
    var bottomRowView: UIView!
    var dividerBottom: UIView!
    var scrollView: UIScrollView!
    var overlayProductView: UIView!
    var overlayEmbeddedView: UIView!
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    var disclosureLabel: UILabel!
    var dynamicParentProductView: UIView!
    var headerLabel: UILabel!
    var headerView: UIView!
    var dynamicChildProductView: UIStackView!
    var actionButton: UIButton!
    var popupHeight: Double = 0.1
    var popupWidth: Double = 0.9
    var paddingHorizontalTen: Double = 10
    var paddingHorizontalTwenty: Double = 20
    var paddingVerticalFive: Double = 5
    var paddingVerticalTen: Double = 10
    var paddingVerticalTwenty: Double = 20
    var brandLogoHeight: Double = 50
    var webView: WKWebView!
    var webViewManager: BreadFinancialWebViewInterstitial!
    var webViewPlacementModel: PopupPlacementModel!

    var loader: LoaderIndicator!

    var merchantConfiguration: MerchantConfiguration?
    var placementsConfiguration: PlacementConfiguration?
    var brandConfiguration: BrandConfigResponse?
    var recaptchaManager: RecaptchaManager
    var apiClient: APIClient
    var alertHandler: AlertHandler
    var commonUtils: CommonUtils
    let logger: Logger

    let callback: ((BreadPartnerEvents) -> Void)

    init(
        integrationKey: String,
        merchantConfiguration: MerchantConfiguration,
        placementConfiguration: PlacementConfiguration,
        popupModel: PopupPlacementModel,
        overlayType: PlacementOverlayType,
        apiClient: APIClient,
        alertHandler: AlertHandler,
        commonUtils: CommonUtils,
        brandConfiguration: BrandConfigResponse?,
        recaptchaManager: RecaptchaManager,
        logger: Logger,
        callback: @escaping (BreadPartnerEvents) -> Void
    ) {
        self.integrationKey = integrationKey
        self.merchantConfiguration = merchantConfiguration
        self.placementsConfiguration = placementConfiguration
        self.brandConfiguration = brandConfiguration
        self.popupModel = popupModel
        self.overlayType = overlayType
        self.apiClient = apiClient
        self.alertHandler = alertHandler
        self.commonUtils = commonUtils
        self.recaptchaManager = recaptchaManager
        self.logger = logger
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await setupUI()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let popupView = popupView, popupView.bounds != .zero else {
            return
        }

        if overlayType == .embeddedOverlay, loader?.isHidden == nil {
            setupLoader()
        }

        closeButton.isHidden = (popupModel.location == "RTPS-Approval")
    }

    func displayEmbeddedOverlay(popupModel: PopupPlacementModel) {

        setupLoader()

        overlayProductView.isHidden = false
        overlayEmbeddedView.isHidden = false

        popupView.addSubview(overlayEmbeddedView)
        webViewManager = BreadFinancialWebViewInterstitial(
            logger: logger,
            callback: { event in
                self.handleWebViewEvent(event: event)
            })

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

    func handleWebViewEvent(event: BreadPartnerEvents) {
        switch event {
        case .popupClosed:
            closeButtonTapped()
        default:
            callback(event)
        }
    }
}
