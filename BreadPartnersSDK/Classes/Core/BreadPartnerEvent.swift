import UIKit

public enum BreadPartnerEvents {
    case renderTextViewWithLink(view: UIView)
    case renderSeparateTextAndButton(textView: UITextView, button: UIButton)
    case renderPopupView(view: UIViewController)
    case textClicked
    case actionButtonTapped
    case screenName(name: String)
    case webViewSuccess(result: Any)
    case webViewFailure(error: Error)
    case popupClosed
    case sdkError(error: Error)
}
