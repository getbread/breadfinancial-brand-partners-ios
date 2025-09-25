//------------------------------------------------------------------------------
//  File:          BreadPartnerLinkTextSwitUI.swift
//  Author(s):     Bread Financial
//  Date:          27 March 2025
//
//  Descriptions:  This file is part of the BreadPartnersSDK for iOS,
//  providing UI components and functionalities to integrate Bread Financial
//  services into partner applications.
//
//  © 2025 Bread Financial
//------------------------------------------------------------------------------

import SwiftUI

/// A SwiftUI view for displaying tappable link-styled text in Bread Partner UI.
public struct BreadPartnerLinkTextSwitUI: View {
    private var text: String
    private var links: [String]
    private var onTap: (() -> Void)?
    private var linkColor: Color
    private var linkFontName: String
    private var linkFontSize: CGFloat

    public init(
        _ text: String, links: [String] = [], onTap: (() -> Void)? = nil,
        fontName: String = "System", fontSize: CGFloat = 17
    ) {
        self.text = text
        self.links = links
        self.onTap = onTap
        self.linkColor = .blue
        self.linkFontName = fontName
        self.linkFontSize = fontSize
    }

    public var body: some View {
        var modifiedAttributedText = self.attributedText

        for word in links {
            if let range = modifiedAttributedText.range(of: word) {
                modifiedAttributedText[range].foregroundColor = UIColor(
                    linkColor)
                modifiedAttributedText[range].underlineStyle = .single
                modifiedAttributedText[range].font = fontToUIFont(
                    fontName: linkFontName, size: linkFontSize)  // Use custom font name and size
            }
        }

        return Text(modifiedAttributedText)
            .onTapGesture {
                onTap?()
            }
            .padding()
    }

    public func linkColor(_ color: Color) -> BreadPartnerLinkTextSwitUI {
        var copy = self
        copy.linkColor = color
        return copy
    }

    public func linkFont(_ fontName: String, fontSize: CGFloat)
        -> BreadPartnerLinkTextSwitUI
    {
        var copy = self
        copy.linkFontName = fontName
        copy.linkFontSize = fontSize
        return copy
    }
}

// Helper function to convert Font Name and Size to UIFont
private func fontToUIFont(fontName: String, size: CGFloat) -> UIFont {
    if let customFont = UIFont(name: fontName, size: size) {
        return customFont
    } else {
        // Fallback to system font if the custom font is not found
        return UIFont.systemFont(ofSize: size)
    }
}
