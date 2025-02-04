import UIKit

/// Enum representing different events supported by BreadPartnerSDK.
public enum BreadPartnerEvents {
    
    /// Renders a text view containing a clickable hyperlink.
    /// - Parameter view: UIView to display the linked text.
    case renderTextViewWithLink(textView: UITextView)

    /// Renders text and a button separately on the screen.
    /// - Parameters:
    ///   - textView: UITextView for displaying text.
    ///   - button: UIButton for user interactions.
    case renderSeparateTextAndButton(textView: UITextView, button: UIButton)

    /// Displays a popup interface on the screen.
    /// - Parameter view: UIViewController that presents the popup.
    case renderPopupView(view: UIViewController)

    /// Detects when a text element is clicked.
    /// This allows brand partners to trigger any specific action.
    case textClicked

    /// Detects when an action button inside a popup is tapped.
    /// This provides a callback for brand partners to handle the button tap.
    case actionButtonTapped

    /// Provides a callback for tracking screen names, typically for analytics.
    /// - Parameter name: name of the current screen.
    case screenName(name: String)

    /// Provides a success result from the web view, such as approval confirmation.
    /// - Parameter result: result object returned on success.
    case webViewSuccess(result: Any)

    /// Provides an error result from the web view, such as a failure response.
    /// - Parameter error: error object detailing the issue.
    case webViewFailure(error: Error)

    /// Detects when the popup is closed at any point and provides a callback.
    case popupClosed

    /// Provides information about any SDK-related errors.
    /// - Parameter error: error object detailing the issue.
    case sdkError(error: Error)
}
