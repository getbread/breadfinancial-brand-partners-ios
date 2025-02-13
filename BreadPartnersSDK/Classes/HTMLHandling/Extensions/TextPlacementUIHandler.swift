extension HTMLContentRenderer {

    func renderTextAndButton() {
        if forSwiftUI {
            let plainTextView = createSwiftUIPlainTextView()
            let actionButton = createSwiftUIActionButton()

            self.callback(
                .renderSwiftUISeparateTextAndButton(
                    textView: plainTextView, button: actionButton)
            )
            
        } else {
            let plainTextView = createPlainTextView()

            let actionButton = createActionButton()

            self.callback(
                .renderSeparateTextAndButton(
                    textView: plainTextView, button: actionButton))
        }
    }

    func renderTextViewWithLink() {

        if forSwiftUI {
            let combinedText =
                (textPlacementModel?.contentText ?? "N/A")
                + (textPlacementModel?.actionLink ?? "N/A")
            let swiftUIView = BreadPartnerLinkTextSwitUI(
                combinedText,
                links: [textPlacementModel?.actionLink ?? "N/A"],
                onTap: {
                    Task {
                        await self.handleLinkInteraction(
                            link: (self.textPlacementModel?.actionLink ?? "N/A")
                        )
                    }
                }
            )
            self.callback(.renderSwiftUITextViewWithLink(textView: swiftUIView))
        } else {
            let textView = BreadPartnerLinkText()
            let combinedText = createSpannableText(
                text: textPlacementModel?.contentText ?? "N/A",
                linkText: textPlacementModel?.actionLink ?? "N/A"
            )

            textView.linkTextAttributes = [
                .foregroundColor: UIColor.blue,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
            ]

            textView.configure(with: combinedText) { [self] link in
                Task {
                    await handleLinkInteraction(link: link)
                }
            }

            self.callback(.renderTextViewWithLink(textView: textView))
        }
    }

    @objc func handleButtonTap(_ sender: UIButton) {
        guard let link = sender.accessibilityIdentifier else { return }

        Task {
            await handleLinkInteraction(link: link)
        }
    }

    func handleLinkInteraction(link: String) async {
        guard let placementModel = textPlacementModel,
            let responseModel = responseModel
        else {
            return
        }

        if let actionType = htmlContentParser.handleActionType(
            from: placementModel.actionType ?? "")
        {
            switch actionType {
            case .showOverlay:
                await handlePopupPlacement(
                    responseModel: responseModel,
                    textPlacementModel: placementModel)
            default:
                return alertHandler.showAlert(
                    title: Constants.nativeSDKAlertTitle(),
                    message: Constants.missingTextPlacementError,
                    showOkButton: true)
            }
        } else {
            return alertHandler.showAlert(
                title: Constants.nativeSDKAlertTitle(),
                message: Constants.noTextPlacementError, showOkButton: true)
        }
    }

}
