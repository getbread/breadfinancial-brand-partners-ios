import UIKit

public class BreadPartnerDefaults: NSObject {

    public static let shared = BreadPartnerDefaults()

    private override init() {}

    public let setupConfig1 = BreadPartnersSetupConfig(
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

    public let placementConfig = BreadPartnersPlacementConfig(
        financingType: .installments,
        locationType: .category,
        placementId: "03d69ff1-f90c-41b2-8a27-836af7f1eb98",
        domID: "123",
        order: Order(
            subTotal: CurrencyValue(currency: "USD", value: 50000),
            totalDiscounts: CurrencyValue(currency: "USD", value: 50000),
            totalPrice: CurrencyValue(currency: "USD", value: 73900),
            totalShipping: CurrencyValue(currency: "USD", value: 50000),
            totalTax: CurrencyValue(currency: "USD", value: 50000),
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

    let rtpsConfig = BreadPartnersRtpsConfig(
        financingType: .card,
        order: nil,
        locationType: .cart,
        cardType: nil,
        country: "US",
        prescreenId: nil,
        correlationData: nil,
        customerAcceptedOffer: true,
        channel: "web",
        subChannel: nil,
        mockResponse: .success)

    public let textPlacementRequestType1 = PlacementRequest(
        placements: [
            PlacementRequestBody(
                id: "03d69ff1-f90c-41b2-8a27-836af7f1eb98",
                context: ContextRequestBody(
                    SDK_TID: "69d7bfdd-a06c-4e16-adfb-58e03a3c7dbe",
                    ENV: "STAGE",
                    PRICE: 73900,
                    channel: "P",
                    subchannel: "X",
                    ALLOW_CHECKOUT: false
                )
            )
        ],
        brandId: "8a9fcd35-7f4d-4e3c-a9cc-6f6e98064df7"
    )

    /// Direct WebView when popup displayed
    public let textPlacementRequestType2 = PlacementRequest(
        placements: [
            PlacementRequestBody(
                id: "8828d6d9-e993-41cc-8744-fa3857c12c4a",
                context: ContextRequestBody(
                    SDK_TID: "6f42d67e-cff4-4575-802a-e90a838981bb",
                    ENV: "STAGE",
                    LOCATION: "Category",
                    PRICE: 119900,
                    channel: "A",
                    subchannel: "X",
                    ALLOW_CHECKOUT: false
                )
            )
        ],
        brandId: "8a9fcd35-7f4d-4e3c-a9cc-6f6e98064df7"
    )

    /// Different text placement and click ApplyButton to show WebView
    public let textPlacementRequestType3 = PlacementRequest(
        placements: [
            PlacementRequestBody(
                id: "03d69ff1-f90c-41b2-8a27-836af7f1eb98",
                context: ContextRequestBody(
                    SDK_TID: "6f42d67e-cff4-4575-802a-e90a838981ss",
                    ENV: "STAGE",
                    LOCATION: "Product",
                    PRICE: 119900,
                    channel: "A",
                    subchannel: "X",
                    ALLOW_CHECKOUT: false
                )
            )
        ],
        brandId: "8a9fcd35-7f4d-4e3c-a9cc-6f6e98064df7"
    )

    public let dashboardWebViewURL =
        "https://acquire1uat.comenity.net/unified/checkout-start?clientName&#x3D;aspire&amp;embedded&#x3D;true&amp;workflow&#x3D;unifiedPrequalCheckout&amp;mockPrequalApp&#x3D;success&amp;mockUD&#x3D;success&amp;mockBraintreeTokenize&#x3D;success&amp;mockVCI&#x3D;successWithIssuedCard&amp;mockBraintreeTokens&#x3D;success&amp;mockBuyer&#x3D;success&amp;mockUPC&#x3D;successWithPrepareCheckout&amp;mockVCIS&#x3D;success&amp;mockUO&#x3D;success&epId=6f42d67e-cff4-4575-802a-e90a838981bb&location=Category&channel=C&subchannel=X"

    public let styleSet1 = StyleStruct(
        parsedRedColor: UIColor(hex: "#d50132"),
        parsedGreyColor: UIColor(hex: "#ececec"),
        loaderColor: UIColor(hex: "#0f2233"),
        crossColor: .black,
        dividerColor: UIColor(hex: "#ececec"),
        borderColor: UIColor(hex: "#ececec"),
        headerBgColor: UIColor(hex: "#ececec"),
        actionButtonColor: UIColor(hex: "#d50132"),

        baseFontFamily: "Arial-BoldMT",
        textSizeBold: 16.0,
        textSizeSemiBold: 14.0,
        textSizeRegular: 12.0,
        textSizeSmall: 10.0,

        normalTextColor: .black,
        clickableTextColor: UIColor(hex: "#d50132"),
        titleTextColor: .black,
        subTitleTextColor: .gray,
        headerTextColor: .gray,
        paragraphTextColor: .gray,
        connectorTextColor: .black,
        disclosureTextColor: .gray,

        popupHeaderFont: UIFont(name: "Arial-BoldMT", size: 16),
        popupTitleFont: UIFont(name: "Arial-BoldMT", size: 16),
        popupSubTitleFont: UIFont(name: "Arial-BoldMT", size: 12),
        popupParagraphFont: UIFont(name: "Arial-BoldMT", size: 11),
        popupConnectorFont: UIFont(name: "Arial-BoldMT", size: 13),
        popupDisclosureFont: UIFont(name: "Arial-BoldMT", size: 11)
    )

    public let styleSet2 = StyleStruct(
        parsedRedColor: UIColor(hex: "#FF935F"),
        parsedGreyColor: UIColor(hex: "#ececec"),
        loaderColor: UIColor(hex: "#FF935F"),
        crossColor: UIColor(hex: "#FF935F"),
        dividerColor: UIColor(hex: "#FFBE9F"),
        borderColor: UIColor(hex: "#ececec"),
        headerBgColor: UIColor(hex: "#FFBE9F"),
        actionButtonColor: UIColor(hex: "#FF935F"),

        baseFontFamily: "Arial-BoldMT",
        textSizeBold: 18.0,
        textSizeSemiBold: 16.0,
        textSizeRegular: 14.0,
        textSizeSmall: 12.0,

        normalTextColor: .black,
        clickableTextColor: UIColor(hex: "#FF935F"),
        titleTextColor: .black,
        subTitleTextColor: .gray,
        headerTextColor: .gray,
        paragraphTextColor: .gray,
        connectorTextColor: .black,
        disclosureTextColor: .gray,

        popupHeaderFont: UIFont(name: "Arial-BoldMT", size: 18),
        popupTitleFont: UIFont(name: "Arial-BoldMT", size: 18),
        popupSubTitleFont: UIFont(name: "Arial-BoldMT", size: 14),
        popupParagraphFont: UIFont(name: "Arial-BoldMT", size: 12),
        popupConnectorFont: UIFont(name: "Arial-BoldMT", size: 15),
        popupDisclosureFont: UIFont(name: "Arial-BoldMT", size: 13)
    )

    public let styleSet3 = StyleStruct(
        parsedRedColor: UIColor(hex: "#000000"),
        parsedGreyColor: UIColor(hex: "#ececec"),
        loaderColor: UIColor(hex: "#0f2233"),
        crossColor: .black,
        dividerColor: UIColor(hex: "#ececec"),
        borderColor: UIColor(hex: "#ececec"),
        headerBgColor: UIColor(hex: "#ececec"),
        actionButtonColor: UIColor(hex: "#000000"),

        baseFontFamily: "Arial-BoldMT",
        textSizeBold: 18.0,
        textSizeSemiBold: 16.0,
        textSizeRegular: 14.0,
        textSizeSmall: 12.0,

        normalTextColor: .black,
        clickableTextColor: UIColor(hex: "#000000"),
        titleTextColor: .black,
        subTitleTextColor: .gray,
        headerTextColor: .gray,
        paragraphTextColor: .gray,
        connectorTextColor: .black,
        disclosureTextColor: .gray,

        popupHeaderFont: UIFont(name: "Arial-BoldMT", size: 16),
        popupTitleFont: UIFont(name: "Arial-BoldMT", size: 16),
        popupSubTitleFont: UIFont(name: "Arial-BoldMT", size: 12),
        popupParagraphFont: UIFont(name: "Arial-BoldMT", size: 11),
        popupConnectorFont: UIFont(name: "Arial-BoldMT", size: 13),
        popupDisclosureFont: UIFont(name: "Arial-BoldMT", size: 11)
    )

    
    public let textPlacementStyling = TextPlacementStyling(
        buttonFont: UIFont(
            name: "Arial-BoldMT",
            size: 12.0
        )!,
        buttonTextColor: .white,
        buttonFrame: .zero,
        buttonPadding: .zero,
        buttonBackgroundColor: UIColor(hex: "#d50132"),
        buttonCornerRadius: 15.0
    )
 
    public let popUpStyling = PopUpStyling(
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
        )
    )

    let actionButtonStyle = PopupActionButtonStyle(
        font: UIFont.boldSystemFont(ofSize: 18),
        textColor: .white,
        frame: CGRect(x: 20, y: 100, width: 200, height: 50),
        backgroundColor: UIColor(hex: "#d50132"),
        cornerRadius: 8.0,
        padding: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    )
    
    /// PreScreen Placement Request
    public let textPlacementRequestType4 = PlacementRequest(
        placements: [
            PlacementRequestBody(
                id: "",
                context: ContextRequestBody(
                    ENV: "STAGE",
                    LOCATION: "RTPS-Approval",
                    embeddedUrl:
                        "https://acquire1uat.comenity.net/prescreen/offer?mockMO=success&mockPA=success&mockVL=success&embedded=true&clientKey=8a9fcd35-7f4d-4e3c-a9cc-6f6e98064df7&prescreenId=79233069&cardType=&urlPath=%2F&firstName=Carol&lastName=Jones&address1=3075%20Loyalty%20Cir&city=Columbus&state=OH&zip=43219&storeNumber=2009&location=checkout&channel=O"
                )
            )
        ],
        brandId: "8a9fcd35-7f4d-4e3c-a9cc-6f6e98064df7"
    )
    
    let jsonResponse: [String: Any] = [
        "urlPath": "/cart",
        "firstName": "Carol",
        "lastName": "Jones",
        "address1": "3075 Loyalty Cir",
        "city": "Columbus",
        "state": "OH",
        "zip": "43219",
        "storeNumber": "2009",
        "location": "checkout",
        "channel": "O",
        "subchannel": "M",
        "reCaptchaToken": NSNull(),
        "mockResponse": "success",
        "overrideConfig": ["enhancedPresentment": true]
    ]
    
    public let setupConfig2 = BreadPartnersSetupConfig(
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

    public let rtpsConfig1 = BreadPartnersRtpsConfig(
        locationType: .checkout,
        mockResponse: .success
    )

}
