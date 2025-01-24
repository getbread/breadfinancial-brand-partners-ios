import BreadPartnersSDK
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let configModel = BreadPartnerDefaults.shared.textPlacementRequestType1

        let styleStructSet = BreadPartnerDefaults.shared.styleSet1

        let textPlacementStyling = TextPlacementStyling(
            normalFont: UIFont(
                name: styleStructSet.baseFontFamily,
                size: styleStructSet.textSizeRegular
            )!,
            normalTextColor: styleStructSet.normalTextColor,
            clickableFont: UIFont(
                name: styleStructSet.baseFontFamily,
                size: styleStructSet.textSizeRegular
            )!,
            clickableTextColor: styleStructSet.clickableTextColor,
            textViewFrame: CGRect(x: 20, y: 70, width: 350, height: 70)
        )

        let popUpStyling = PopUpStyling(
            loaderColor: styleStructSet.loaderColor,
            crossColor: styleStructSet.crossColor,
            dividerColor: styleStructSet.dividerColor,
            borderColor: styleStructSet.borderColor.cgColor,
            titlePopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: styleStructSet.baseFontFamily,
                    size: styleStructSet.textSizeBold
                ),
                textColor: styleStructSet.titleTextColor,
                textSize: styleStructSet.textSizeBold
            ),
            subTitlePopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: styleStructSet.baseFontFamily,
                    size: styleStructSet.textSizeRegular
                ),
                textColor: styleStructSet.subTitleTextColor,
                textSize: styleStructSet.textSizeRegular
            ),
            headerPopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: styleStructSet.baseFontFamily,
                    size: styleStructSet.textSizeSemiBold
                ),
                textColor: styleStructSet.headerTextColor,
                textSize: styleStructSet.textSizeSemiBold
            ),
            headerBgColor: styleStructSet.headerBgColor,
            headingThreePopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: styleStructSet.baseFontFamily,
                    size: styleStructSet.textSizeSemiBold
                ),
                textColor: styleStructSet.parsedRedColor,
                textSize: styleStructSet.textSizeSemiBold
            ),
            paragraphPopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: styleStructSet.baseFontFamily,
                    size: styleStructSet.textSizeSmall
                ),
                textColor: styleStructSet.paragraphTextColor,
                textSize: styleStructSet.textSizeSmall
            ),
            connectorPopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: styleStructSet.baseFontFamily,
                    size: styleStructSet.textSizeSemiBold
                ),
                textColor: styleStructSet.connectorTextColor,
                textSize: styleStructSet.textSizeSemiBold
            ),
            disclosurePopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: styleStructSet.baseFontFamily,
                    size: styleStructSet.textSizeSmall
                ),
                textColor: styleStructSet.disclosureTextColor,
                textSize: styleStructSet.textSizeSmall
            ),
            actionButtonColor: styleStructSet.actionButtonColor
        )

        let config = BreadPartnerSDKConfigurations(
            configModel: configModel,
            enableLog: true,
            textPlacementStyling: textPlacementStyling,
            popUpStyling: popUpStyling
        )

        BreadPartnersSDK.shared.loadPlacementUI(with: config) {
            event in
            switch event {
            case .renderTextView(let view):
                self.view.addSubview(view)
                view.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    //                    view.widthAnchor.constraint(equalToConstant: 100),
                    view.heightAnchor.constraint(equalToConstant: 100),
                    view.centerXAnchor.constraint(
                        equalTo: self.view.centerXAnchor),
                    view.centerYAnchor.constraint(
                        equalTo: self.view.centerYAnchor),
                    view.topAnchor.constraint(
                        equalTo: self.view.topAnchor, constant: 100),
                    view.leadingAnchor.constraint(
                        equalTo: self.view.leadingAnchor, constant: 20),
                    view.trailingAnchor.constraint(
                        equalTo: self.view.trailingAnchor, constant: -20),
                ])
                print("BreadPartnerSDK::Successfully rendered view.")
            case .renderPopupView(let view):
                self.present(view, animated: true)
                print("BreadPartnerSDK::Successfully rendered PopupView.")
            case .textClicked:
                print("BreadPartnerSDK::Text element was clicked!")
            case .actionButtonTapped:
                print("BreadPartnerSDK::Popup action button was tapped!")
            case .screenName(let name):
                print("BreadPartnerSDK::Screen name: \(name)")
            case .webViewSuccess(let result):
                print("BreadPartnerSDK::WebView success with result: \(result)")
            case .webViewFailure(let error):
                print(
                    "BreadPartnerSDK::WebView interaction failed with error: \(error)"
                )
            case .popupClosed:
                print("BreadPartnerSDK::Popup closed!")
            case .sdkError(let error):
                print("BreadPartnerSDK::SDK encountered an error: \(error)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
