extension HTMLContentRenderer {
    
    func renderTextAndButton() {
        let plainTextView = createPlainTextView()
        
        let actionButton = createActionButton()
        
        self.callback(
            .renderSeparateTextAndButton(
                textView: plainTextView, button: actionButton))
    }
    
    func renderTextViewWithLink() {
        let textView = InteractiveText()
        let combinedText = createSpannableText(
            text: textPlacementModel?.contentText ?? "N/A",
            linkText: textPlacementModel?.actionLink ?? "N/A"
        )
        
        textView.linkTextAttributes = [
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
        ]
        
        textView.configure(with: combinedText) { link in
            self.handleLinkInteraction(link: link)
        }
        
        self.callback(.renderTextViewWithLink(textView: textView))
    }
    
    func createPlainTextView() -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.text = textPlacementModel?.contentText ?? "N/A"
        return textView
    }
    
    func createActionButton() -> UIButton {
        
        let button = UIButton(type: .system)
        button.setTitle(textPlacementModel?.actionLink ?? "N/A", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.accessibilityIdentifier = textPlacementModel?.actionLink ?? "N/A"
        button.backgroundColor = UIColor.blue
        
        button.layer.masksToBounds = true
        button.titleEdgeInsets = UIEdgeInsets(top: 0,left: 5,bottom: 0,right: 5)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        button.addTarget(
            self, action: #selector(handleButtonTap(_:)), for: .touchUpInside
        )
        return button
    }
    
    func createSpannableText(
        text: String,
        linkText: String
    ) -> NSAttributedString {
        
        let clickableAttributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .link: linkText,
        ]
        
        let normalText = NSAttributedString(
            string: text)
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
