import BreadPartnersSDK
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var preScreenButton: UIButton!
    var style: [String: Any] = ["": ""]

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: For development purposes
        // These configurations are used to test different types of placement requests.
        // Each placement type corresponds to a specific configuration that includes parameters
        // like placement ID, SDK transaction ID, environment, price, and brand ID.
        // This allows testing of various placement setups by fetching specific configurations
        // based on the placement type key.
        let placementRequestType = BreadPartnerDefaults.shared
            .placementConfigurations["textPlacementRequestType1"]
        let placementID = placementRequestType!["placementID"] as! String
        let price = (placementRequestType!["price"] as! Int)
        let brandId = placementRequestType!["brandId"] as! String

        // MARK: For development purposes
        style = BreadPartnerDefaults.shared.styleStruct["cadet"]!
        let primaryColor = style["primaryColor"] as! String
        let secondaryColor = style["secondaryColor"] as! String
        let tertiaryColor = style["tertiaryColor"] as! String
        let blackColor = "#000000"

        let fontFamily = style["fontFamily"] as! String

        let smallTextSize = style["small"] as! Int
        let mediumTextSize = style["medium"] as! Int
        let largeTextSize = style["large"] as! Int
        let xlargeTextSize = style["xlarge"] as! Int

        // MARK: For development purposes to showcase pre-screen flow.
        preScreenButton.titleLabel?.font = UIFont(
            name: fontFamily, size: CGFloat(xlargeTextSize))
        preScreenButton.tintColor = UIColor(hex: primaryColor)

        /// Prepare popup styling configuration object for each style elemnt
        let popUpStyling = PopUpStyling(
            loaderColor: UIColor(hex: primaryColor),
            crossColor: UIColor(hex: primaryColor),
            dividerColor: UIColor(hex: tertiaryColor),
            borderColor: UIColor(hex: tertiaryColor).cgColor,
            titlePopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: fontFamily, size: Double(xlargeTextSize)),
                textColor: UIColor(hex: blackColor)
            ),
            subTitlePopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: fontFamily, size: Double(mediumTextSize)),
                textColor: UIColor(hex: secondaryColor)
            ),
            headerPopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: fontFamily, size: Double(mediumTextSize)),
                textColor: UIColor(hex: blackColor)
            ),
            headerBgColor: UIColor(hex: tertiaryColor),
            headingThreePopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: fontFamily, size: Double(largeTextSize)),
                textColor: UIColor(hex: primaryColor)
            ),
            paragraphPopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: fontFamily, size: Double(smallTextSize)),
                textColor: UIColor(hex: secondaryColor)
            ),
            connectorPopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: fontFamily, size: Double(smallTextSize)),
                textColor: UIColor(hex: primaryColor)
            ),
            disclosurePopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: fontFamily, size: Double(smallTextSize)),
                textColor: UIColor(hex: secondaryColor)
            ),
            actionButtonStyle: PopupActionButtonStyle(
                font: UIFont(
                    name: fontFamily, size: Double(mediumTextSize)),
                textColor: .white,
                frame: CGRect(x: 20, y: 100, width: 100, height: 50),
                backgroundColor: UIColor(hex: primaryColor),
                cornerRadius: 25.0,
                padding: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            )
        )

        let placementData = PlacementData(
            financingType: .installments,
            locationType: .category,
            placementId: placementID,
            domID: "123",
            order: Order(
                subTotal: CurrencyValue(currency: "USD", value: 0),
                totalDiscounts: CurrencyValue(currency: "USD", value: 0),
                totalPrice: CurrencyValue(
                    currency: "USD", value: Double(price)),
                totalShipping: CurrencyValue(currency: "USD", value: 0),
                totalTax: CurrencyValue(currency: "USD", value: 0),
                discountCode: "string",
                pickupInformation: PickupInformation(
                    name: Name(
                        givenName: "John",
                        familyName: "Doe"),
                    phone: "+14539842345",
                    address: Address(
                        address1: "156 5th Avenue",
                        locality: "New York",
                        postalCode: "10019",
                        region: "US-NY",
                        country: "US"),
                    email: "john.doe@gmail.com"),
                fulfillmentType: "type",
                items: []))

        let placementsConfiguration = PlacementConfiguration(
            placementData: placementData,
            popUpStyling: popUpStyling
        )

        let merchantConfiguration = MerchantConfiguration(
            buyer: BreadPartnersBuyer(
                givenName: "Jack",
                familyName: "Seamus",
                additionalName: "C.",
                birthDate: "1974-08-21",
                email: "johncseamus@gmail.com",
                phone: "+13235323423",
                billingAddress: BreadPartnersAddress(
                    address1: "323 something lane",
                    address2: "apt. B",
                    country: "USA",
                    locality: "NYC",
                    region: "NY",
                    postalCode: "11222"
                ),
                shippingAddress: nil
            ), loyaltyID: "xxxxxx",
            storeNumber: "1234567",
            env: "STAGE",
            channel: "P",
            subchannel: "X"
        )

        Task {

            await BreadPartnersSDK.shared.setup(
                environment: .stage,
                integrationKey: brandId,
                enableLog: false)

            await BreadPartnersSDK.shared.registerPlacements(
                merchantConfiguration: merchantConfiguration,
                placementsConfiguration: placementsConfiguration,
                splitTextAndAction: true,
                forSwiftUI: false
            ) {
                event in
                switch event {
                case .renderTextViewWithLink(let textView):

                    /// Handles rendering of a text view with a clickable link.
                    /// - Modifies the font, text color, and link color for the text view.
                    /// - Adds the text view to the main view and sets up its layout constraints.

                    textView.font = UIFont(
                        name: fontFamily, size: Double(mediumTextSize))
                    textView.textColor = UIColor.black
                    textView.linkTextAttributes = [
                        .foregroundColor: UIColor(hex: primaryColor)
                    ]

                    self.view.addSubview(textView)

                    textView.translatesAutoresizingMaskIntoConstraints = false

                    NSLayoutConstraint.activate([
                        textView.centerXAnchor.constraint(
                            equalTo: self.view.centerXAnchor),
                        textView.topAnchor.constraint(
                            equalTo: self.view.topAnchor, constant: 100),
                        textView.leadingAnchor.constraint(
                            equalTo: self.view.leadingAnchor, constant: 20),
                        textView.trailingAnchor.constraint(
                            equalTo: self.view.trailingAnchor, constant: -20),
                    ])

                case .renderSeparateTextAndButton(let textView, let button):

                    /// Handles rendering of a text view and a button, placed separately.
                    /// - Modifies the font, text color for the text view, and the button's title color, font, and background.
                    /// - Adds the text view and button to the main view and sets up their layout constraints.
                    textView.font = UIFont(
                        name: fontFamily, size: Double(mediumTextSize))
                    textView.textColor = UIColor(hex: blackColor)

                    button.setTitleColor(UIColor.white, for: .normal)
                    button.titleLabel?.font = UIFont(
                        name: fontFamily, size: Double(mediumTextSize))
                    button.backgroundColor =
                        UIColor(hex: primaryColor)
                    button.layer.cornerRadius = 25.0

                    DispatchQueue.main.async {

                        self.view.addSubview(textView)
                        self.view.addSubview(button)
                        textView.translatesAutoresizingMaskIntoConstraints =
                            false
                        button.translatesAutoresizingMaskIntoConstraints = false

                        NSLayoutConstraint.activate([
                            textView.centerXAnchor.constraint(
                                equalTo: self.view.centerXAnchor),
                            textView.topAnchor.constraint(
                                equalTo: self.view.topAnchor, constant: 100),
                            textView.leadingAnchor.constraint(
                                equalTo: self.view.leadingAnchor, constant: 20),
                            textView.trailingAnchor.constraint(
                                equalTo: self.view.trailingAnchor, constant: -20
                            ),

                            button.widthAnchor.constraint(equalToConstant: 150),
                            button.trailingAnchor.constraint(
                                equalTo: self.view.trailingAnchor, constant: -20
                            ),
                            button.heightAnchor.constraint(equalToConstant: 50),
                            button.topAnchor.constraint(
                                equalTo: textView.bottomAnchor, constant: 20),
                        ])
                    }

                case .renderPopupView(let view):
                    DispatchQueue.main.async {
                        /// Implement some process prior to loading the Web View popup
                        /// (e.g checking if the customer is authenticated).

                        self.showYesNoAlert(from: self) { userTappedYes in
                            if userTappedYes {
                                self.present(view, animated: true)
                            } else {
                                print("User canceled")
                            }
                        }
                    }
                default:
                    // MARK: Other events.
                    print("BreadPartnerSDK::Event: \(event)")
                }

            }
        }
    }

    @IBAction func preScreenButton(_ sender: Any) {

        let rtpsData = RTPSData(
            order: Order(
                totalPrice: CurrencyValue(
                    currency: "USD",
                    value: 50000)
            ), locationType: .checkout,
            mockResponse: .success
        )

        let placementsConfiguration = PlacementConfiguration(
            rtpsData: rtpsData
        )

        let merchantConfiguration = MerchantConfiguration(
            buyer: BreadPartnersBuyer(
                givenName: "Carol",
                familyName: "Jones",
                additionalName: "C.",
                birthDate: "1974-08-21",
                billingAddress: BreadPartnersAddress(
                    address1: "3075 Loyalty Cir",
                    locality: "Columbus",
                    region: "OH",
                    postalCode: "43219")
            ),
            storeNumber: "2009"
        )

        Task {
            await BreadPartnersSDK.shared.silentRTPSRequest(
                merchantConfiguration: merchantConfiguration,
                placementsConfiguration: placementsConfiguration
            ) {
                event in
                switch event {
                case .renderPopupView(let view):
                    self.present(view, animated: true)
                    print("BreadPartnerSDK::Successfully rendered PopupView.")
                default:
                    print("BreadPartnerSDK::Event: \(event)")
                }
            }
        }
    }

    func showYesNoAlert(
        from viewController: UIViewController,
        completion: @escaping (Bool) -> Void
    ) {

        // MARK: For development purposes
        let primaryColor = style["primaryColor"] as! String

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
        yesAction.setValue(UIColor(hex: primaryColor), forKey: "titleTextColor")
        noAction.setValue(UIColor(hex: primaryColor), forKey: "titleTextColor")

        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
