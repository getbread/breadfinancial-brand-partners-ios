import UIKit

enum BreadPartnerEvents {
    case renderTextView(view: UIView)
    case renderPopupView(view: UIViewController)
    case textClicked
    case actionButtonTapped
    case screenName(name:String)
    case webViewSuccess(result:Any)
    case webViewFailure(error: Error)
    case popupClosed
    case sdkError(error: Error)
}
