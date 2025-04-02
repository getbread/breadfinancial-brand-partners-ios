//------------------------------------------------------------------------------
//  File:          BreadPartnerLinkText.swift
//  Author(s):     Bread Financial
//  Date:          27 March 2025
//
//  Descriptions:  This file is part of the BreadPartnersSDK for iOS,
//  providing UI components and functionalities to integrate Bread Financial
//  services into partner applications.
//
//  © 2025 Bread Financial
//------------------------------------------------------------------------------

import UIKit

/// A custom UITextView for displaying tappable link-styled text in Bread Partner UI.
public class BreadPartnerLinkText: UITextView {
    private var tapHandler: ((String) -> Void)?

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        isEditable = false
        isScrollEnabled = false
        isSelectable = true
        backgroundColor = .clear
        dataDetectorTypes = .link
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGestureRecognizer)
    }

    func configure(
        with attributedText: NSAttributedString,
        tapHandler: ((String) -> Void)? = nil
    ) {
        self.attributedText = attributedText
        self.tapHandler = tapHandler
    }

    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        handleTapAsync(gesture)
    }

    private func handleTapAsync(_ gesture: UITapGestureRecognizer) {
        guard let layoutManager = layoutManager as NSLayoutManager?,
            let textContainer = textContainer as NSTextContainer?,
            let text = attributedText
        else { return }

        let location = gesture.location(in: self)
        let textContainerOffset = CGPoint(
            x: (bounds.size.width - textContainer.size.width) * 0.5
                - textContainerInset.left,
            y: (bounds.size.height - textContainer.size.height) * 0.5
                - textContainerInset.top
        )
        let textContainerLocation = CGPoint(
            x: location.x - textContainerOffset.x,
            y: location.y - textContainerOffset.y
        )

        let characterIndex = layoutManager.characterIndex(
            for: textContainerLocation,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )

        if characterIndex < text.length {
            let attributes = text.attributes(
                at: characterIndex, effectiveRange: nil)
            if let link = attributes[.link] as? String {
                Task {
                    await handleLinkTap(link)
                }

            }
        }
    }

    private func handleLinkTap(_ link: String) async {
        tapHandler?(link)
    }
}
