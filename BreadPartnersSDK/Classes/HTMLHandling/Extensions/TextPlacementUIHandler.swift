//------------------------------------------------------------------------------
//  File:          TextPlacementUIHandler.swift
//  Author(s):     Bread Financial
//  Date:          27 March 2025
//
//  Descriptions:  This file is part of the BreadPartnersSDK for iOS,
//  providing UI components and functionalities to integrate Bread Financial
//  services into partner applications.
//
//  © 2025 Bread Financial
//------------------------------------------------------------------------------

extension HTMLContentRenderer {

    /// Renders a text view and action button for either SwiftUI or UIKit.
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

    /// Renders a text view with a clickable link, either for SwiftUI or UIKit.
    func renderTextViewWithLink() {

        var contentText = textPlacementModel?.contentText ?? ""
        var actionLink = textPlacementModel?.actionLink ?? ""
        let actionType = textPlacementModel?.actionType

        if actionLink.isEmpty {
            actionLink = contentText
            contentText = ""
        }
        
        if forSwiftUI {
            let combinedText = contentText + actionLink
            let swiftUIView = BreadPartnerLinkTextSwitUI(
                combinedText,
                links: [actionLink],
                onTap: {
                    Task {
                        await self.handleLinkInteraction(
                            link: (actionLink)
                        )
                    }
                }
            )
            self.callback(.renderSwiftUITextViewWithLink(textView: swiftUIView))
        } else {
            let textView = BreadPartnerLinkText()
            let combinedText = createSpannableText(
                text: contentText,
                linkText: actionLink
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

    /// Handles the tap event of an action button, triggering the link interaction.
    @objc func handleButtonTap(_ sender: UIButton) {
        guard let link = sender.accessibilityIdentifier else { return }

        Task {
            await handleLinkInteraction(link: link)
        }
    }

    /// Handles the link interaction for a given link, performing the appropriate action based on the action type.
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
            case .noAction:
                callback(.textClicked)
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
