import Foundation

protocol CommonUtilsProtocol {
    func executeAfterDelay(_ delay: TimeInterval, completion: @escaping () -> Void)
    func handleSecurityCheckFailure(error: Error?)
    func handleSecurityCheckPassed()
    func getCurrentTimestamp() -> String
    func decodeJSON<T: Decodable>(from response: Any, to type: T.Type) throws -> T
}

internal class CommonUtils: NSObject, CommonUtilsProtocol {
    
    private let dispatchQueue: DispatchQueue
    private let alertHandler: AlertHandlerProtocol
    
    init(dispatchQueue: DispatchQueue, alertHandler: AlertHandlerProtocol) {
        self.dispatchQueue = dispatchQueue
        self.alertHandler = alertHandler
        super.init()
    }
    
    func executeAfterDelay(_ delay: TimeInterval, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion()
        }
    }
    
    func handleSecurityCheckFailure(error: Error?) {
        executeAfterDelay(2) {
            self.alertHandler.hideAlert() // Use injected alertHandler
        }
        
        executeAfterDelay(2.5) {
            self.alertHandler.showAlert(
                title: Constants.securityCheckFailureAlertTitle,
                message: Constants.securityCheckAlertFailedMessage(error: error?.localizedDescription ?? ""),
                showOkButton: true
            )
        }
    }
    
    func handleSecurityCheckPassed() {
        executeAfterDelay(2) {
            self.alertHandler.hideAlert() // Use injected alertHandler
        }
        
        executeAfterDelay(2.5) {
            self.alertHandler.showAlert(
                title: Constants.securityCheckSuccessAlertTitle,
                message: Constants.securityCheckSuccessAlertSubTitle,
                showOkButton: true
            )
        }
    }
    
    func getCurrentTimestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let currentDate = Date()
        let formattedTimestamp = dateFormatter.string(from: currentDate)
        return formattedTimestamp
    }
    
    func decodeJSON<T: Decodable>(from response: Any, to type: T.Type) throws -> T {
        guard let responseDictionary = response as? [String: Any] else {
            throw NSError(domain: "JSONDecodingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format"])
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: responseDictionary, options: [])
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: jsonData)
    }
}
