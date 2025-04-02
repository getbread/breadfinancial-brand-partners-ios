import BreadPartnersSDK
import UIKit

class ViewController: UIViewController {

    var style: [String: Any] = ["": ""]

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: For development purposes
        // These configurations are used to test different types of placement requests.
        // Each placement type corresponds to a specific configuration that includes parameters
        // like placement ID, SDK transaction ID, environment, price, and brand ID.
        // This allows testing of various placement setups by fetching specific configurations
        // based on the placement type key.
        let placementRequestType: [String: Any] = [:]
        let placementID = placementRequestType["placementID"] as? String
        let price = (placementRequestType["price"] as? Int)
        let loyaltyId = (placementRequestType["loyaltyId"] as? String)
        let brandId = placementRequestType["brandId"] as? String
        let channel = placementRequestType["channel"] as? String
        let subChannel = placementRequestType["subchannel"] as? String
        let env = placementRequestType["env"] as? BreadPartnersEnvironment
        let location =
            placementRequestType["location"] as? BreadPartnersLocationType
        let financingType =
            placementRequestType["financingType"]
            as? BreadPartnersFinancingType

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

        let placementData = PlacementData(
            financingType: financingType,
            locationType: location,
            placementId: placementID,
            domID: "123",
            order: Order(
                subTotal: CurrencyValue(currency: "USD", value: 0),
                totalDiscounts: CurrencyValue(currency: "USD", value: 0),
                totalPrice: CurrencyValue(
                    currency: "USD", value: Double(price ?? 0)),
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
            placementData: placementData
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
            ), loyaltyID: loyaltyId,
            storeNumber: "1234567",
            channel: channel,
            subchannel: subChannel
        )

        Task {

            await BreadPartnersSDK.shared.setup(
                environment: env ?? BreadPartnersEnvironment.stage,
                integrationKey: brandId ?? "",
                enableLog: true)

            await BreadPartnersSDK.shared.registerPlacements(
                merchantConfiguration: merchantConfiguration,
                placementsConfiguration: placementsConfiguration,
                splitTextAndAction: false,
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
                case .onSDKEventLog(_):
                    print("")
                case .renderPopupView(let view):
                    DispatchQueue.main.async {
                        /// Implement some process prior to loading the Web View popup
                        /// (e.g checking if the customer is authenticated).
                        self.present(view, animated: true)
                    }
                default:
                    // MARK: Other events.
                    break
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
