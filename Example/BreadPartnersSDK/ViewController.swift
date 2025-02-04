import BreadPartnersSDK
import UIKit

class ViewController: UIViewController {

    var textPlacementStyling: TextPlacementStyling?
    var popUpStyling: PopUpStyling?
    var style: StyleStruct? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        BreadPartnersSDK.shared.setup(integrationKey: "8a9fcd35-7f4d-4e3c-a9cc-6f6e98064df7",enableLog: true)

        do {
            sleep(1)
        }
        
        style = BreadPartnerDefaults.shared.styleSet3

        preScreenButton.tintColor = style?.clickableTextColor

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
            popUpStyling: popUpStyling
        )

        BreadPartnersSDK.shared.registerPlacements(
            setupConfig: BreadPartnerDefaults.shared.setupConfig1,
            placementsConfiguration: placementsConfiguration,
            splitTextAndAction: true
        ) {
            event in
            switch event {
            case .renderTextViewWithLink(let textView):
               
                textView.font = UIFont(name: "JosefinSans-Bold", size: 20)
                textView.textColor = UIColor.black
                textView.linkTextAttributes = [.foregroundColor: self.style?.clickableTextColor ?? UIColor.red]
                
                self.view.addSubview(textView)
                
                textView.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                  
                    // MARK: Text View with Link
                    textView.centerXAnchor.constraint(
                        equalTo: self.view.centerXAnchor),
                    textView.topAnchor.constraint(
                        equalTo: self.view.topAnchor, constant: 100),
                    textView.leadingAnchor.constraint(
                        equalTo: self.view.leadingAnchor, constant: 20),
                    textView.trailingAnchor.constraint(
                        equalTo: self.view.trailingAnchor, constant: -20),
                ])
                print("BreadPartnerSDK::Successfully rendered view.")
                
            case .renderSeparateTextAndButton(let textView, let button):
                
                textView.font = UIFont(name: "JosefinSans-Bold", size: 20)
                textView.textColor = UIColor.black
                
                button.setTitleColor(UIColor.white, for: .normal)
//                button.titleLabel?.font =  .systemFont(ofSize: 19.0, weight: .bold)
                button.titleLabel?.font = UIFont(name: "JosefinSans-Bold", size: 24)
                button.titleEdgeInsets = UIEdgeInsets(top: 0,left: 5,bottom: 0,right: 5)
                button.backgroundColor = self.style?.clickableTextColor ?? UIColor.red
                button.layer.cornerRadius = 10.0
                
                self.view.addSubview(textView)
                self.view.addSubview(button)
                
                textView.translatesAutoresizingMaskIntoConstraints = false
                button.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    
                    // MARK: Splitted Text View
                    textView.centerXAnchor.constraint(
                        equalTo: self.view.centerXAnchor),
                    textView.topAnchor.constraint(
                        equalTo: self.view.topAnchor, constant: 100),
                    textView.leadingAnchor.constraint(
                        equalTo: self.view.leadingAnchor, constant: 20),
                    textView.trailingAnchor.constraint(
                        equalTo: self.view.trailingAnchor, constant: -20),

                    // MARK: Splitted Button View
                    button.widthAnchor.constraint(equalToConstant: 200),
                    button.leadingAnchor.constraint(
                        equalTo: self.view.leadingAnchor, constant: 20),
                    button.heightAnchor.constraint(equalToConstant: 50),
//                    button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 25),
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

        let rtpsConfig = BreadPartnerDefaults.shared.rtpsConfig1

        let placementsConfiguration = PlacementsConfiguration(
            rtpsConfig: rtpsConfig,
            popUpStyling: popUpStyling
        )

        BreadPartnersSDK.shared.submitRTPS(
            setupConfig: BreadPartnerDefaults.shared.setupConfig1,
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
