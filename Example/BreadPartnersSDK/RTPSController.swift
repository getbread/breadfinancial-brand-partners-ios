import BreadPartnersSDK
import UIKit

class RTPSController: UIViewController {

    let headerLabel = UILabel()
    let productPriceLabel = UILabel()
    let productDateLabel = UILabel()
    let totalLabel = UILabel()

    var productPrice: Double = 49.99
    var productDate: String = "March 20, 2025"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        rtpsCall()
    }

    func setupUI() {
        view.backgroundColor = .white

        headerLabel.text = "Checkout"
        headerLabel.font = UIFont.boldSystemFont(ofSize: 24)
        headerLabel.textAlignment = .center
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        let priceTitleLabel = createTitleLabel(text: "Product Price")
        productPriceLabel.text = "$\(productPrice)"

        let dateTitleLabel = createTitleLabel(text: "Product Date")
        productDateLabel.text = productDate

        totalLabel.text = "Total: $\(productPrice)"
        totalLabel.font = UIFont.boldSystemFont(ofSize: 18)
        totalLabel.textAlignment = .center
        totalLabel.translatesAutoresizingMaskIntoConstraints = false

        let priceStack = createHorizontalStack(
            titleLabel: priceTitleLabel, valueLabel: productPriceLabel)
        let dateStack = createHorizontalStack(
            titleLabel: dateTitleLabel, valueLabel: productDateLabel)

        let mainStack = UIStackView(arrangedSubviews: [
            headerLabel, priceStack, dateStack, totalLabel,
        ])
        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStack.topAnchor.constraint(
                equalTo: view.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -20),
        ])
    }

    func createTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }

    func createHorizontalStack(titleLabel: UILabel, valueLabel: UILabel)
        -> UIStackView
    {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel, UIView(), valueLabel,
        ])
        stack.axis = .horizontal
        return stack
    }

    func rtpsCall() {

        let rtpsData = RTPSData(
            order: Order(
                totalPrice: CurrencyValue(
                    currency: "USD",
                    value: 50000)
            ), locationType: BreadPartnersLocationType.checkout,
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
            await BreadPartnersSDK.shared.setup(
                environment: .stage,
                integrationKey: "8a9fcd35-7f4d-4e3c-a9cc-6f6e98064df7",
                enableLog: true)

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
                    break
                }
            }
        }
    }
}
