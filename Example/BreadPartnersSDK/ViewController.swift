import BreadPartnersSDK
import UIKit

class ViewController: UIViewController {

    var textPlacementStyling: TextPlacementStyling?
    var popUpStyling: PopUpStyling?
    var style: StyleStruct? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        BreadPartnersSDK.shared.setup(
            setupConfig: BreadPartnerDefaults.shared.setupConfig1)

        style = BreadPartnerDefaults.shared.styleSet3

        preScreenButton.tintColor = style?.clickableTextColor

        // MARK: Add styling for any type of text placement
        textPlacementStyling = TextPlacementStyling(
            normalFont: UIFont(
                name: style!.baseFontFamily,
                size: style!.textSizeBold
            )!,
            normalTextColor: style!.normalTextColor,
            clickableFont: UIFont(
                name: style!.baseFontFamily,
                size: style!.textSizeBold
            )!,
            clickableTextColor: style!.clickableTextColor,
            textViewFrame: .zero,
            buttonFont: UIFont(
                name: style!.baseFontFamily,
                size: style!.textSizeSemiBold
            )!,
            buttonTextColor: .white,
            buttonFrame: .zero,
            buttonPadding: .zero,
            buttonBackgroundColor: style!.clickableTextColor,
            buttonCornerRadius: 25.0
        )

        let popUpStyling = PopUpStyling(
            loaderColor: style!.loaderColor,
            crossColor: style!.crossColor,
            dividerColor: style!.dividerColor,
            borderColor: style!.borderColor.cgColor,
            titlePopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: style!.baseFontFamily,
                    size: style!.textSizeBold
                ),
                textColor: style!.titleTextColor,
                textSize: style!.textSizeBold
            ),
            subTitlePopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: style!.baseFontFamily,
                    size: style!.textSizeRegular
                ),
                textColor: style!.subTitleTextColor,
                textSize: style!.textSizeRegular
            ),
            headerPopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: style!.baseFontFamily,
                    size: style!.textSizeSemiBold
                ),
                textColor: style!.headerTextColor,
                textSize: style!.textSizeSemiBold
            ),
            headerBgColor: style!.headerBgColor,
            headingThreePopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: style!.baseFontFamily,
                    size: style!.textSizeSemiBold
                ),
                textColor: style!.parsedRedColor,
                textSize: style!.textSizeSemiBold
            ),
            paragraphPopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: style!.baseFontFamily,
                    size: style!.textSizeSmall
                ),
                textColor: style!.paragraphTextColor,
                textSize: style!.textSizeSmall
            ),
            connectorPopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: style!.baseFontFamily,
                    size: style!.textSizeSemiBold
                ),
                textColor: style!.connectorTextColor,
                textSize: style!.textSizeSemiBold
            ),
            disclosurePopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: style!.baseFontFamily,
                    size: style!.textSizeSmall
                ),
                textColor: style!.disclosureTextColor,
                textSize: style!.textSizeSmall
            ),
            actionButtonStyle: PopupActionButtonStyle(
                font: UIFont.boldSystemFont(ofSize: 18),
                textColor: .white,
                frame: CGRect(x: 20, y: 100, width: 100, height: 50),
                backgroundColor: style!.clickableTextColor,
                cornerRadius: 25.0,
                padding: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            )
        )

        let placement = BreadPartnerDefaults.shared.placementConfig

        let placementsConfiguration = PlacementsConfiguration(
            placementConfig: placement,
            textPlacementStyling: textPlacementStyling,
            popUpStyling: popUpStyling
        )

        BreadPartnersSDK.shared.registerPlacements(
            placementsConfiguration: placementsConfiguration,
            splitTextAndAction: true
        ) {
            event in
            switch event {
            case .renderTextViewWithLink(let view):
                self.view.addSubview(view)
                view.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    // MARK: Text View with Link
                    // view.widthAnchor.constraint(equalToConstant: 100),
                    view.heightAnchor.constraint(equalToConstant: 100),
                    view.centerXAnchor.constraint(
                        equalTo: self.view.centerXAnchor),
                    // view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                    view.topAnchor.constraint(
                        equalTo: self.view.topAnchor, constant: 100),
                    view.leadingAnchor.constraint(
                        equalTo: self.view.leadingAnchor, constant: 20),
                    view.trailingAnchor.constraint(
                        equalTo: self.view.trailingAnchor, constant: -20),
                ])
                print("BreadPartnerSDK::Successfully rendered view.")
            case .renderSeparateTextAndButton(let textView, let button):
                self.view.addSubview(textView)
                self.view.addSubview(button)
                textView.translatesAutoresizingMaskIntoConstraints = false
                button.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    // MARK: Splitted Text View
                    // view.widthAnchor.constraint(equalToConstant: 100),
                    textView.heightAnchor.constraint(equalToConstant: 20),
                    textView.centerXAnchor.constraint(
                        equalTo: self.view.centerXAnchor),
                    // view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                    textView.topAnchor.constraint(
                        equalTo: self.view.topAnchor, constant: 100),
                    textView.leadingAnchor.constraint(
                        equalTo: self.view.leadingAnchor, constant: 20),
                    textView.trailingAnchor.constraint(
                        equalTo: self.view.trailingAnchor, constant: -20),

                    // MARK: Splitted Button View
                    button.widthAnchor.constraint(equalToConstant: 150),
                    button.heightAnchor.constraint(equalToConstant: 50),
                    button.leftAnchor.constraint(
                        equalTo: self.view.leftAnchor, constant: 25),
                    button.topAnchor.constraint(
                        equalTo: textView.bottomAnchor, constant: 20),

                ])
                print("BreadPartnerSDK::Successfully rendered view.")
            case .renderPopupView(let view):
                self.showYesNoAlert(from: self) { userTappedYes in
                    if userTappedYes {
                        self.present(view, animated: true)
                    } else {
                        print("User canceled")
                    }
                }
                print("BreadPartnerSDK::Successfully rendered PopupView.")
            default:
                print("BreadPartnerSDK::Event: \(event)")
            }
        }
    }

    @IBOutlet weak var preScreenButton: UIButton!

    @IBAction func preScreenButton(_ sender: Any) {

        BreadPartnersSDK.shared.setup(
            setupConfig: BreadPartnerDefaults.shared.setupConfig2)

        let rtpsConfig = BreadPartnerDefaults.shared.rtpsConfig1

        let placementsConfiguration = PlacementsConfiguration(
            rtpsConfig: rtpsConfig,
            textPlacementStyling: textPlacementStyling,
            popUpStyling: popUpStyling
        )

        BreadPartnersSDK.shared.submitRTPS(
            placementsConfiguration: placementsConfiguration
        ) {
            event in
            switch event {
            case .renderPopupView(let view):
                self.present(view, animated: true)
                print("BreadPartnerSDK::Successfully rendered PopupView.")
            case .actionButtonTapped:
                print("BreadPartnerSDK::Popup action button was tapped!")
            case .screenName(let name):
                print("BreadPartnerSDK::Screen name: \(name)")
            case .webViewSuccess(let result):
                print("BreadPartnerSDK::WebView success with result: \(result)")
            case .webViewFailure(let error):
                print("BreadPartnerSDK::WebView failed with error: \(error)")
            case .popupClosed:
                print("BreadPartnerSDK::Popup closed!")
            case .sdkError(let error):
                print("BreadPartnerSDK::SDK encountered an error: \(error)")
            default:
                print("BreadPartnerSDK::Default")
            }
        }
    }

    func showYesNoAlert(
        from viewController: UIViewController,
        completion: @escaping (Bool) -> Void
    ) {
        let alertController = UIAlertController(
            title: "Are you authenticated?",
            message: nil,
            preferredStyle: .alert
        )
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            completion(true)
        }
        let noAction = UIAlertAction(title: "No", style: .cancel) { _ in
            completion(false)
        }
        yesAction.setValue(style?.clickableTextColor, forKey: "titleTextColor")
        noAction.setValue(style?.clickableTextColor, forKey: "titleTextColor")

        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
