extension HTMLContentRenderer {

    func renderTextAndButton() {
        let plainTextView = createPlainTextView()

        let actionButton = createActionButton()

        self.callback(
            .renderSeparateTextAndButton(
                textView: plainTextView, button: actionButton))
    }

    func renderSingleTextView() {
        guard let placementModel = textPlacementModel,
              let style = textPlacementStyling
        else {
            return
        }
        let textView = InteractiveText(
            frame: style.textViewFrame)
        let combinedText = createSpannableText(
            text: placementModel.contentText ?? "",
            linkText: placementModel.actionLink ?? "",
            styling: style
        )

        textView.linkTextAttributes = [
            .foregroundColor: style.clickableTextColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
        ]

        textView.configure(with: combinedText) { link in
            self.handleLinkInteraction(link: link)
        }

        self.callback(.renderTextViewWithLink(view: textView))
    }

    func createPlainTextView() -> UITextView {
        guard let placementModel = textPlacementModel,
              let style = textPlacementStyling
        else {
            return UITextView()
        }
        let textView = UITextView(frame: style.textViewFrame)
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.font = style.normalFont
        textView.textColor = style.normalTextColor
        textView.text = placementModel.contentText ?? ""
        return textView
    }
    func createActionButton() -> UIButton {
        guard let placementModel = textPlacementModel,
              let style = textPlacementStyling
        else {
            return UIButton()
        }

        guard let buttonFrame = style.buttonFrame else {
            return UIButton()
        }
        let buttonYPosition = style.textViewFrame.maxY + 8
        let buttonFrames = CGRect(
            x: buttonFrame.origin.x,
            y: buttonYPosition,
            width: buttonFrame.width,
            height: buttonFrame.height
        )
                
        let button = UIButton(type: .system)
        button.setTitle(placementModel.actionLink ?? "", for: .normal)
        button.titleLabel?.font =
        style.buttonFont ?? UIFont.systemFont(ofSize: 16)
        button.setTitleColor(style.buttonTextColor ?? .blue, for: .normal)
        button.frame = buttonFrames
        button.accessibilityIdentifier = placementModel.actionLink ?? ""
        button.backgroundColor = style.buttonBackgroundColor ?? .blue
        button.layer.cornerRadius = style.buttonCornerRadius ?? 10.0
        button.layer.masksToBounds = true
        button.titleEdgeInsets = style.buttonPadding ?? .zero
        button.addTarget(
            self, action: #selector(handleButtonTap(_:)), for: .touchUpInside
        )
        return button
    }

    func createSpannableText(
        text: String,
        linkText: String,
        styling: TextPlacementStyling
    ) -> NSAttributedString {
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: styling.normalFont,
            .foregroundColor: styling.normalTextColor,
        ]

        let clickableAttributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .font: styling.clickableFont!,
            .foregroundColor: styling.clickableTextColor,
            .link: linkText,
        ]

        let normalText = NSAttributedString(
            string: text, attributes: normalAttributes)
        let clickableText = NSAttributedString(
            string: linkText, attributes: clickableAttributes)

        let combinedText = NSMutableAttributedString()
        combinedText.append(normalText)
        combinedText.append(clickableText)

        return combinedText
    }

    @objc func handleButtonTap(_ sender: UIButton) {
        guard let link = sender.accessibilityIdentifier else { return }
        handleLinkInteraction(link: link)
    }

    func handleLinkInteraction(link: String) {
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
                handlePopupPlacement(
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
