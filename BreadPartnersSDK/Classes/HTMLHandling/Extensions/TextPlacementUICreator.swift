import SwiftUI

extension HTMLContentRenderer {

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
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)
        button.addTarget(
            self, action: #selector(handleButtonTap(_:)), for: .touchUpInside
        )
        return button
    }

    func createSwiftUIPlainTextView() -> BreadPartnerTextView {
        return BreadPartnerTextView(textPlacementModel?.contentText ?? "N/A")
    }

    func createSwiftUIActionButton() -> BreadPartnerButtonView {
        return BreadPartnerButtonView(
            textPlacementModel?.actionLink ?? "N/A",
            action: {
                Task {
                    await self.handleLinkInteraction(link: "")
                }
            }
        )
    }
}
