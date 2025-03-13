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
            "financingType": "installments",
            "env": "STAGE",
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
            "financingType": "installments",
            "env": "STAGE",
            "location": "category",
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
            "financingType": "installments",
            "env": "STAGE",
            "location": "product",
            "price": 119900,
            "channel": "A",
            "subchannel": "X",
            "allowCheckout": false,
            "brandId": "8a9fcd35-7f4d-4e3c-a9cc-6f6e98064df7",
        ],
        /// Placement type for RTPS
        "textPlacementRequestType4": [
            "brandId": "8a9fcd35-7f4d-4e3c-a9cc-6f6e98064df7",
            "location": "RTPS-Approval",
            "embeddedUrl":
                "https://acquire1uat.comenity.net/prescreen/offer?mockMO=success&mockPA=success&mockVL=success&embedded=true&clientKey=8a9fcd35-7f4d-4e3c-a9cc-6f6e98064df7&prescreenId=79233069&cardType=&urlPath=%2F&firstName=Carol&lastName=Jones&address1=3075%20Loyalty%20Cir&city=Columbus&state=OH&zip=43219&storeNumber=2009&location=checkout&channel=O",
        ],
        /// Placement type for SingInButton with No_Action
        "textPlacementRequestType5": [
            "placementID": "dadc4588-d67f-45f9-8096-81c1264fc2f3",
            "sdkTid": "6f42d67e-cff4-4575-802a-e90a838981ss",
            "env": "STAGE",
            "location": "footer",
            "price": 11000,
            "channel": "F",
            "subchannel": "X",
            "allowCheckout": false,
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

}
