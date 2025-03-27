import UIKit

/// `BreadPartnerDefaults` class provides default configurations/styles/properties used across the BreadPartner SDK.
public class BreadPartnerDefaults: NSObject {

    public static let shared = BreadPartnerDefaults()

    private override init() {}

    public let placementConfigurations: [String: [String: Any]] = [
        /// Different text placement and click ApplyButton to show WebView
        "textPlacementRequestType1": [
            "placementID": "03d69ff1-f90c-41b2-8a27-836af7f1eb98",
            "sdkTid": "69d7bfdd-a06c-4e16-adfb-58e03a3c7dbe",
            "financingType": BreadPartnersFinancingType.installments,
            "env": BreadPartnersEnvironment.stage,
            "price": 73900,
            "channel": "P",
            "subchannel": "X",
            "allowCheckout": false,
            "brandId": "8a9fcd35-7f4d-4e3c-a9cc-6f6e98064df7",
        ],
        /// Direct WebView when popup displayed
        "textPlacementRequestType2": [
            "placementID": "8828d6d9-e993-41cc-8744-fa3857c12c4a",
            "sdkTid": "6f42d67e-cff4-4575-802a-e90a838981bb",
            "financingType": BreadPartnersFinancingType.installments,
            "env": BreadPartnersEnvironment.stage,
            "location": BreadPartnersLocationType.category,
            "price": 119900,
            "channel": "A",
            "subchannel": "X",
            "allowCheckout": false,
            "brandId": "8a9fcd35-7f4d-4e3c-a9cc-6f6e98064df7",
        ],
        /// Different text placement and click ApplyButton to show WebView
        "textPlacementRequestType3": [
            "placementID": "03d69ff1-f90c-41b2-8a27-836af7f1eb98",
            "sdkTid": "6f42d67e-cff4-4575-802a-e90a838981ss",
            "financingType": BreadPartnersFinancingType.installments,
            "env": BreadPartnersEnvironment.stage,
            "location": BreadPartnersLocationType.product,
            "price": 119900,
            "channel": "A",
            "subchannel": "X",
            "allowCheckout": false,
            "brandId": "8a9fcd35-7f4d-4e3c-a9cc-6f6e98064df7",
        ],
        /// Placement type for RTPS
        "textPlacementRequestType4": [
            "env": BreadPartnersEnvironment.stage,
            "brandId": "8a9fcd35-7f4d-4e3c-a9cc-6f6e98064df7",
            "location": BreadPartnersLocationType.checkout,
            "embeddedUrl":
                "https://acquire1uat.comenity.net/prescreen/offer?mockMO=success&mockPA=success&mockVL=success&embedded=true&clientKey=8a9fcd35-7f4d-4e3c-a9cc-6f6e98064df7&prescreenId=79233069&cardType=&urlPath=%2F&firstName=Carol&lastName=Jones&address1=3075%20Loyalty%20Cir&city=Columbus&state=OH&zip=43219&storeNumber=2009&location=checkout&channel=O",
        ],
        /// Placement type for SingInButton with No_Action
        "textPlacementRequestType5": [
            "placementID": "dadc4588-d67f-45f9-8096-81c1264fc2f3",
            "sdkTid": "6f42d67e-cff4-4575-802a-e90a838981ss",
            "env": BreadPartnersEnvironment.stage,
            "location": BreadPartnersLocationType.footer,
            "price": 11000,
            "channel": "F",
            "subchannel": "X",
            "allowCheckout": false,
            "brandId": "b9464be2-3ea3-4018-80ed-e903f75acb18",
        ],
        /// Placement type for openExperienceForPlacement
        "textPlacementRequestType6": [
            "placementID": "a0348301-dc9a-4c34-b68d-dacb40fe3696",
            "sdkTid": "6f42d67e-cff4-4575-802a-e90a838981ss",
            "env": BreadPartnersEnvironment.stage,
            "price": 0,
            "channel": "X",
            "subchannel": "X",
            "brandId": "217a0943-8031-457d-b9e3-7375c8af3a22",
        ],
        /// Tina provided data
        "textPlacementRequestType7": [
            "placementID": "25a8a961-d226-4ee7-b80e-8f41b2d8ee94",
            "sdkTid": "",
            "env": BreadPartnersEnvironment.stage,
            "price": 150000,
            "channel": "X",
            "subchannel": "X",
            "brandId": "217a0943-8031-457d-b9e3-7375c8af3a22",
        ],
        /// Tina provided data
        "textPlacementRequestType8": [
            "placementID": "d5da0e8b-b119-46dd-9040-5bc63a516cda",
            "sdkTid": "",
            "env": BreadPartnersEnvironment.stage,
            "price": 0,
            "channel": "X",
            "subchannel": "X",
            "brandId": "217a0943-8031-457d-b9e3-7375c8af3a22",
        ],
        /// Antaylore post SignIn use case
        "textPlacementRequestType9": [
            "placementID": "dadc4588-d67f-45f9-8096-81c1264fc2f3",
            "sdkTid": "",
            "env": BreadPartnersEnvironment.stage,
            "location": BreadPartnersLocationType.footer,
            "loyaltyId": "true",
            "price": 11000,
            "channel": "F",
            "subchannel": "X",
            "brandId": "b9464be2-3ea3-4018-80ed-e903f75acb18",
        ],
    ]

    public let styleStruct: [String: [String: Any]] = [
        "red": [
            "primaryColor": "#d50132",
            "secondaryColor": "#69727b",
            "tertiaryColor": "#ececec",

            "fontFamily": "JosefinSans-Bold",

            "small": 12,
            "medium": 15,
            "large": 18,
            "xlarge": 20,
        ],
        "orange": [
            "primaryColor": "#FF935F",
            "secondaryColor": "#69727b",
            "tertiaryColor": "#ececec",

            "fontFamily": "Lato-Bold",

            "small": 12,
            "medium": 15,
            "large": 18,
            "xlarge": 20,
        ],
        "cadet": [
            "primaryColor": "#13294b",
            "secondaryColor": "#69727b",
            "tertiaryColor": "#ececec",

            "fontFamily": "Poppins-Bold",

            "small": 12,
            "medium": 15,
            "large": 18,
            "xlarge": 20,
        ],
    ]

    /// Default Popup Style
    let popupStyle = PopUpStyling(
        loaderColor: UIColor(hex: "#0f2233"),
        crossColor: .black,
        dividerColor: UIColor(hex: "#ececec"),
        borderColor: UIColor(hex: "#ececec").cgColor,
        titlePopupTextStyle: PopupTextStyle(
            font: UIFont(
                name: "Arial-BoldMT",
                size: 16.0
            ),
            textColor: .black,
            textSize: 16.0
        ),
        subTitlePopupTextStyle: PopupTextStyle(
            font: UIFont(
                name: "Arial-BoldMT",
                size: 12.0
            ),
            textColor: .gray,
            textSize: 12.0
        ),
        headerPopupTextStyle: PopupTextStyle(
            font: UIFont(
                name: "Arial-BoldMT",
                size: 14.0
            ),
            textColor: .gray,
            textSize: 14.0
        ),
        headerBgColor: UIColor(hex: "#ececec"),
        headingThreePopupTextStyle: PopupTextStyle(
            font: UIFont(
                name: "Arial-BoldMT",
                size: 14.0
            ),
            textColor: UIColor(hex: "#d50132"),
            textSize: 14.0
        ),
        paragraphPopupTextStyle: PopupTextStyle(
            font: UIFont(
                name: "Arial-BoldMT",
                size: 10.0
            ),
            textColor: .gray,
            textSize: 10.0
        ),
        connectorPopupTextStyle: PopupTextStyle(
            font: UIFont(
                name: "Arial-BoldMT",
                size: 14.0
            ),
            textColor: .black,
            textSize: 14.0
        ),
        disclosurePopupTextStyle: PopupTextStyle(
            font: UIFont(
                name: "Arial-BoldMT",
                size: 10.0
            ),
            textColor: .gray,
            textSize: 10.0
        ),
        actionButtonStyle: PopupActionButtonStyle(
            font: UIFont.boldSystemFont(ofSize: 18),
            textColor: .white,
            backgroundColor: UIColor(hex: "#d50132"),
            cornerRadius: 8.0,
            padding: UIEdgeInsets(
                top: 8, left: 16, bottom: 8, right: 16)
        )
    )
}
