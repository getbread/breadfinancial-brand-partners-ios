import UIKit

extension PopupController {

    func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let popupStyle = placementsConfiguration?.popUpStyling

        popupView = PopupElements.shared.createContainerView(
            backgroundColor: .white)
        closeButton = PopupElements.shared.addCloseButton(
            target: self, color: popupStyle!.crossColor,
            action: #selector(closeButtonTapped))
        dividerTop = PopupElements.shared.createHorizontalDivider(
            color: popupStyle!.dividerColor)
        dividerBottom = PopupElements.shared.createHorizontalDivider(
            color: popupStyle!.dividerColor)
        titleLabel = PopupElements.shared.createLabel(
            withText: popupModel.overlayTitle,
            style: popupStyle!.titlePopupTextStyle)
        subtitleLabel = PopupElements.shared.createLabel(
            withText: popupModel.overlaySubtitle,
            style: popupStyle!.subTitlePopupTextStyle)
        disclosureLabel = PopupElements.shared.createLabel(
            withText: popupModel.disclosure,
            style: popupStyle!.disclosurePopupTextStyle, align: .left)
        contentContainerView = PopupElements.shared.createContainerView(
            backgroundColor: .white, borderColor: popupStyle!.borderColor,
            borderWidth: 1.0, cornerRadius: 8.0)
        headerView = PopupElements.shared.createHeaderView(
            label: popupModel.overlayContainerBarHeading,
            bgColor: popupStyle!.headerBgColor,
            headerTextStyle: popupStyle!.headerPopupTextStyle)
        contentStackView = PopupElements.shared.createStackView(
            axis: .vertical, spacing: 10)

        if let actionButtonStyle = popupStyle?.actionButtonStyle {
            actionButton = PopupElements.shared.createButton(
                target: self,
                title: popupModel.primaryActionButtonAttributes?.buttonText
                    ?? "Action",
                buttonStyle: actionButtonStyle,
                action: #selector(actionButtonTapped))
        }

        view.addSubview(popupView)

        brandLogo = UIImageView()
        brandLogo.translatesAutoresizingMaskIntoConstraints = false

        overlayProductView = UIView()
        overlayProductView.translatesAutoresizingMaskIntoConstraints = false

        overlayEmbeddedView = UIView()
        overlayEmbeddedView.translatesAutoresizingMaskIntoConstraints = false

        popupView.addSubview(closeButton)
        popupView.addSubview(brandLogo)
        popupView.addSubview(dividerTop)

        if let imageURL = URL(string: popupModel.brandLogoUrl) {
            brandLogo.loadImage(from: imageURL) { success in
                if success {} else {}
            }
        }

        addSectionsToStackView(popupStyle: popupStyle!)

        applyConstraints()

        switch overlayType {
        case .embeddedOverlay:

            popupView.addSubview(overlayEmbeddedView)
            webViewManager = BreadFinancialWebViewInterstitial()

            if let url = URL(string: popupModel.webViewUrl) {
                webView = webViewManager.createWebView(with: url)
                webViewManager.onPageLoadCompleted = { result in
                    self.loader?.stopAnimating()
                    switch result {
                    case .success(_): break
                    case .failure(let error):
                        self.alertHandler.showAlert(
                            title: Constants.nativeSDKAlertTitle(),
                            message: Constants.unableToLoadWebURL(
                                message: error.localizedDescription),
                            showOkButton: true)
                    }
                }
                webView.translatesAutoresizingMaskIntoConstraints = false
                self.overlayEmbeddedView.addSubview(webView)
            }

            overlayEmbeddedConstraints()

        case .singleProductOverlay:

            popupView.addSubview(overlayProductView)
            popupView.addSubview(dividerBottom)
            popupView.addSubview(actionButton)
            overlayProductView.addSubview(titleLabel)
            overlayProductView.addSubview(subtitleLabel)
            overlayProductView.addSubview(contentContainerView)
            contentContainerView.addSubview(headerView)
            contentContainerView.addSubview(contentStackView)
            overlayProductView.addSubview(disclosureLabel)

            overlayProductConstraints()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let loader = self.loader {
                    loader.stopAnimating()
                }
            }
        }

        if overlayType == PlacementOverlayType.singleProductOverlay {
            fetchWebViewPlacement()
        }
    }

    func setupLoader() {
        DispatchQueue.main.async {
            self.loader = LoaderIndicator(
                frame: CGRect(
                    x: self.popupView.bounds.maxX * 0.45,
                    y: self.popupView.bounds.maxY * 0.45,
                    width: 50,
                    height: 50),
                sdkConfiguration: self.placementsConfiguration!
            )
            self.popupView.addSubview(self.loader)
        }
    }
    func applyConstraints() {
        NSLayoutConstraint.activate([

            popupView.centerXAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            popupView.centerYAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            popupView.widthAnchor.constraint(
                equalTo: view.widthAnchor, multiplier: popupWidth),
            popupView.heightAnchor.constraint(
                equalTo: view.heightAnchor,
                constant: -UIScreen.main.bounds.size.height * popupHeight),

            closeButton.topAnchor.constraint(
                equalTo: popupView.topAnchor, constant: 25),
            closeButton.trailingAnchor.constraint(
                equalTo: popupView.trailingAnchor,
                constant: -paddingHorizontalTen),
            closeButton.widthAnchor.constraint(equalToConstant: 25),
            closeButton.heightAnchor.constraint(equalToConstant: 25),

            brandLogo.topAnchor.constraint(
                equalTo: popupView.topAnchor, constant: paddingVerticalTen),
            brandLogo.leadingAnchor.constraint(
                equalTo: popupView.leadingAnchor, constant: paddingHorizontalTen
            ),
            brandLogo.heightAnchor.constraint(equalToConstant: brandLogoHeight),
            brandLogo.widthAnchor.constraint(equalToConstant: brandLogoHWidth),

            dividerTop.topAnchor.constraint(
                equalTo: brandLogo.bottomAnchor, constant: paddingVerticalTen),
            dividerTop.leadingAnchor.constraint(
                equalTo: popupView.leadingAnchor),
            dividerTop.trailingAnchor.constraint(
                equalTo: popupView.trailingAnchor),
            dividerTop.heightAnchor.constraint(equalToConstant: 1),

        ])
    }

    func overlayProductConstraints() {
        NSLayoutConstraint.activate([

            overlayProductView.topAnchor.constraint(
                equalTo: dividerTop.bottomAnchor),
            overlayProductView.leadingAnchor.constraint(
                equalTo: popupView.leadingAnchor),
            overlayProductView.trailingAnchor.constraint(
                equalTo: popupView.trailingAnchor),
            overlayProductView.bottomAnchor.constraint(
                equalTo: dividerBottom.topAnchor),

            titleLabel.topAnchor.constraint(
                equalTo: overlayProductView.topAnchor,
                constant: paddingVerticalTen),
            titleLabel.leadingAnchor.constraint(
                equalTo: overlayProductView.leadingAnchor,
                constant: paddingHorizontalTwenty),
            titleLabel.trailingAnchor.constraint(
                equalTo: overlayProductView.trailingAnchor,
                constant: -paddingHorizontalTwenty),

            subtitleLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor, constant: paddingVerticalTen),
            subtitleLabel.leadingAnchor.constraint(
                equalTo: overlayProductView.leadingAnchor,
                constant: paddingHorizontalTwenty),
            subtitleLabel.trailingAnchor.constraint(
                equalTo: overlayProductView.trailingAnchor,
                constant: -paddingHorizontalTwenty),

            contentContainerView.topAnchor.constraint(
                equalTo: subtitleLabel.bottomAnchor,
                constant: paddingHorizontalTwenty),
            contentContainerView.leadingAnchor.constraint(
                equalTo: overlayProductView.leadingAnchor,
                constant: paddingHorizontalTwenty),
            contentContainerView.trailingAnchor.constraint(
                equalTo: overlayProductView.trailingAnchor,
                constant: -paddingHorizontalTwenty),
            contentContainerView.bottomAnchor.constraint(
                equalTo: contentStackView.bottomAnchor,
                constant: paddingHorizontalTwenty),

            headerView.topAnchor.constraint(
                equalTo: contentContainerView.topAnchor),
            headerView.leadingAnchor.constraint(
                equalTo: contentContainerView.leadingAnchor),
            headerView.trailingAnchor.constraint(
                equalTo: contentContainerView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),

            contentStackView.topAnchor.constraint(
                equalTo: headerView.bottomAnchor, constant: paddingHorizontalTen
            ),
            contentStackView.leadingAnchor.constraint(
                equalTo: contentContainerView.leadingAnchor,
                constant: paddingHorizontalTen),
            contentStackView.trailingAnchor.constraint(
                equalTo: contentContainerView.trailingAnchor,
                constant: -paddingHorizontalTen),

            disclosureLabel.topAnchor.constraint(
                equalTo: contentContainerView.bottomAnchor,
                constant: paddingVerticalFive),
            disclosureLabel.trailingAnchor.constraint(
                equalTo: popupView.trailingAnchor,
                constant: -paddingHorizontalTwenty),
            disclosureLabel.leadingAnchor.constraint(
                equalTo: overlayProductView.leadingAnchor,
                constant: paddingHorizontalTwenty),

            dividerBottom.bottomAnchor.constraint(
                equalTo: actionButton.topAnchor, constant: -paddingVerticalTen),
            dividerBottom.leadingAnchor.constraint(
                equalTo: popupView.leadingAnchor),
            dividerBottom.trailingAnchor.constraint(
                equalTo: popupView.trailingAnchor),
            dividerBottom.heightAnchor.constraint(equalToConstant: 1),

            actionButton.bottomAnchor.constraint(
                equalTo: popupView.bottomAnchor,
                constant: -paddingVerticalTwenty),
            actionButton.widthAnchor.constraint(
                equalToConstant: placementsConfiguration?.popUpStyling?
                    .actionButtonStyle?.frame?.width ?? 120),
            actionButton.heightAnchor.constraint(
                equalToConstant: placementsConfiguration?.popUpStyling?
                    .actionButtonStyle?.frame?.height ?? 55),
            actionButton.trailingAnchor.constraint(
                equalTo: popupView.trailingAnchor,
                constant: -paddingHorizontalTen),

        ])
    }

    func overlayEmbeddedConstraints() {
        NSLayoutConstraint.activate([

            overlayEmbeddedView.topAnchor.constraint(
                equalTo: dividerTop.bottomAnchor),
            overlayEmbeddedView.leadingAnchor.constraint(
                equalTo: popupView.leadingAnchor),
            overlayEmbeddedView.trailingAnchor.constraint(
                equalTo: popupView.trailingAnchor),
            overlayEmbeddedView.bottomAnchor.constraint(
                equalTo: popupView.bottomAnchor),

            webView.topAnchor.constraint(equalTo: dividerTop.bottomAnchor),
            webView.leadingAnchor.constraint(
                equalTo: overlayEmbeddedView.leadingAnchor,
                constant: paddingHorizontalTen),
            webView.trailingAnchor.constraint(
                equalTo: overlayEmbeddedView.trailingAnchor,
                constant: -paddingHorizontalTen),
            webView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor),
        ])
    }

    func addSectionsToStackView(popupStyle: PopUpStyling) {
        let bodyDivModel = popupModel.dynamicBodyModel.bodyDiv
        for index in 0..<bodyDivModel.count {

            if let result = bodyDivModel.first(where: {
                Int($0.key.replacingOccurrences(of: "div", with: "")) == index
            }) {
                let tagValuePairs = result.value.tagValuePairs
                let tagPriorityList = ["h3", "h2", "p"]

                for tag in tagPriorityList {
                    if let content = tagValuePairs[tag],
                        let label = PopupElements.shared.createLabelForTag(
                            tag: tag, value: content, popupStyle: popupStyle)
                    {
                        contentStackView.addArrangedSubview(label)
                    }
                }
            }

            if index % 2 != 0,
                let connectorPair = popupModel.dynamicBodyModel.bodyDiv.first(
                    where: { $0.value.tagValuePairs["connector"] != nil }),
                let connectorValue = connectorPair.value.tagValuePairs[
                    "connector"],
                let label = PopupElements.shared.createLabelForTag(
                    tag: "connector", value: connectorValue,
                    popupStyle: popupStyle)
            {
                contentStackView.addArrangedSubview(label)
            }
        }
    }

}
