internal class Constants{
    static func nativeSDKAlertTitle() -> String{
        return "Bread Partner"
    }
    
    static func catchError(message:String)->String{
        return "\(error) \(message)"
    }
    
    static let securityCheckAlertTitle = "Re-CAPTCHA Verification"
    static let securityCheckFailureAlertTitle = "Unable to Verify. Please call us at 1-800-xxx-xxxx for assistance."
    static let securityCheckSuccessAlertTitle = "Congratulations!!"
    static let securityCheckSuccessAlertSubTitle = "You have been preapproved* for Credit Card!."
    static let okButton = "Ok"
    
    static let securityCheckAlertAcknolwedgeMessage = "Your web view will load once the captcha verification is successfully completed. This ensures that all transactions are secure."
    
    static func securityCheckAlertFailedMessage(error:String) -> String {        
        return "Error: \(error)"
    }
    
    static let error = "Error:"
    

    static func apiError(message:String)->String{
        return  "\(error) \(message)"
    }
    static let consecutivePlacementRequestDataError = "Consecutive placement request data not found"
    
    static let apiResToJsonMapError = "Unable to convert response to map."
 
    static let textPlacementError = "\(error) Unable to handle text placement type."
    static let missingTextPlacementError = "Unhandled text placement type."
    static let noTextPlacementError = "No text placement type found."
    static let textPlacementParsingError = "Unable to parse text placement."
    
    static let popupPlacementParsingError = "\(error) Unable to parse popup placement."
    static let missingPopupPlacementError = "Unhandled popup placement type."

    static func unableToLoadWebURL(message:String)->String{
        return  "\(error) Web Url Loading Issue: \(message)"
    }
}
