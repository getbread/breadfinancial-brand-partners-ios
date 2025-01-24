import UIKit

internal class BreadPartnerDefaults:NSObject{
    
    static let shared = BreadPartnerDefaults()
    
    private override init(){}
    
    let textPlacementRequestType1 = PlacementRequest(
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
    let textPlacementRequestType2 = PlacementRequest(
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
    let textPlacementRequestType3 = PlacementRequest(
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
    
    /// PreScreen Placement Request
    let textPlacementRequestType4 = PlacementRequest(
        placements: [
            PlacementRequestBody(
                id: "",
                context: ContextRequestBody(
                    ENV: "STAGE",
                    LOCATION: "RTPS-Approval",
                    embeddedUrl: "https://acquire1uat.comenity.net/prescreen/offer?mockMO=success&mockPA=success&mockVL=success&embedded=true&clientKey=8a9fcd35-7f4d-4e3c-a9cc-6f6e98064df7&prescreenId=79233069&cardType=&urlPath=%2F&firstName=Carol&lastName=Jones&address1=3075%20Loyalty%20Cir&city=Columbus&state=OH&zip=43219&storeNumber=2009&location=checkout&channel=O"
                )
            )
        ],
        brandId: "8a9fcd35-7f4d-4e3c-a9cc-6f6e98064df7"
    )
    
    let dashboardWebViewURL =
    "https://acquire1uat.comenity.net/unified/checkout-start?clientName&#x3D;aspire&amp;embedded&#x3D;true&amp;workflow&#x3D;unifiedPrequalCheckout&amp;mockPrequalApp&#x3D;success&amp;mockUD&#x3D;success&amp;mockBraintreeTokenize&#x3D;success&amp;mockVCI&#x3D;successWithIssuedCard&amp;mockBraintreeTokens&#x3D;success&amp;mockBuyer&#x3D;success&amp;mockUPC&#x3D;successWithPrepareCheckout&amp;mockVCIS&#x3D;success&amp;mockUO&#x3D;success&epId=6f42d67e-cff4-4575-802a-e90a838981bb&location=Category&channel=C&subchannel=X"
    
    let styleSet1 = StyleStruct(
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
    
    let styleSet2 = StyleStruct(
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
    
    let textPlacementStyling = TextPlacementStyling(
        normalFont: UIFont(
            name: "Arial-BoldMT",
            size: 12.0
        )!,
        normalTextColor: .black,
        clickableFont: UIFont(
            name: "Arial-BoldMT",
            size: 12.0
        )!,
        clickableTextColor: UIColor(hex: "#d50132"),
        textViewFrame: CGRect(x: 20, y: 100, width: 350, height: 70)
    )
    
    let popUpStyling = PopUpStyling(
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
        actionButtonColor: UIColor(hex: "#d50132")
    )
    
}
