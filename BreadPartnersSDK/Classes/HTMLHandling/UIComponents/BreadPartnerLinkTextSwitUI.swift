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
import UIKit

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
        let attributedString = NSMutableAttributedString(string: text)
        let fullRange = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttribute(.font, value: fontToUIFont(fontName: linkFontName, size: linkFontSize), range: fullRange)

        for word in links {
            let nsText = text as NSString
            let wordRange = nsText.range(of: word)
            if wordRange.location != NSNotFound {
                attributedString.addAttribute(.foregroundColor, value: colorToUIColor(linkColor), range: wordRange)
                attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: wordRange)
                attributedString.addAttribute(.font, value: fontToUIFont(fontName: linkFontName, size: linkFontSize), range: wordRange)
            }
        }

        if #available(iOS 15.0, *) {
            return AnyView(
                Text(AttributedString(attributedString))
                    .onTapGesture { onTap?() }
                    .padding()
            )
        } else {
            return AnyView(
                UILabelRepresentable(attributedText: attributedString, onTap: onTap)
                    .padding()
            )
        }
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

struct UILabelRepresentable: UIViewRepresentable {
    var attributedText: NSAttributedString
    var onTap: (() -> Void)?

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap))
        label.addGestureRecognizer(tap)
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.attributedText = attributedText
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onTap: onTap)
    }

    class Coordinator: NSObject {
        var onTap: (() -> Void)?
        init(onTap: (() -> Void)?) {
            self.onTap = onTap
        }
        @objc func handleTap() {
            onTap?()
        }
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

// Helper function to convert SwiftUI Color to UIColor for iOS 12+
private func colorToUIColor(_ color: Color) -> UIColor {
    // Handle common colors
    switch color {
    case .black: return UIColor.black
    case .white: return UIColor.white
    case .red: return UIColor.red
    case .green: return UIColor.green
    case .blue: return UIColor.blue
    case .gray: return UIColor.gray
    case .yellow: return UIColor.yellow
    case .orange: return UIColor.orange
    case .pink: return UIColor.systemPink
    case .purple: return UIColor.purple
    default:
        // Try to extract RGBA components (works for custom colors in iOS 14+)
        #if canImport(UIKit)
        if #available(iOS 14.0, *) {
            let uiColor = UIColor(color)
            return uiColor
        }
        #endif
        // Fallback to black for unknown colors on iOS 12/13
        return UIColor.black
    }
}
