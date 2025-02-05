import Foundation

protocol CommonUtilsProtocol {
    func executeAfterDelay(
        _ delay: TimeInterval, completion: @escaping () -> Void)
    func handleSecurityCheckFailure(error: Error?)
    func handleSecurityCheckPassed()
    func getCurrentTimestamp() -> String
    func decodeJSON<T: Decodable>(from response: Any, to type: T.Type) throws
        -> T
    func buildRTPSWebURL(
        integrationKey: String,
        setupConfig: BreadPartnersSetupConfig,
        rtpsConfig: BreadPartnersRtpsConfig
    ) -> URL?
}

/// `CommonUtils` class provides utility methods for common operations across the BreadPartner SDK.
internal class CommonUtils: NSObject, CommonUtilsProtocol {

    private let dispatchQueue: DispatchQueue
    private let alertHandler: AlertHandlerProtocol

    init(dispatchQueue: DispatchQueue, alertHandler: AlertHandlerProtocol) {
        self.dispatchQueue = dispatchQueue
        self.alertHandler = alertHandler
        super.init()
    }

    func executeAfterDelay(
        _ delay: TimeInterval, completion: @escaping () -> Void
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion()
        }
    }

    func handleSecurityCheckFailure(error: Error?) {
        executeAfterDelay(2) {
            self.alertHandler.hideAlert()  // Use injected alertHandler
        }

        executeAfterDelay(2.5) {
            self.alertHandler.showAlert(
                title: Constants.securityCheckFailureAlertTitle,
                message: Constants.securityCheckAlertFailedMessage(
                    error: error?.localizedDescription ?? ""),
                showOkButton: true
            )
        }
    }

    func handleSecurityCheckPassed() {
        executeAfterDelay(2) {
            self.alertHandler.hideAlert()  // Use injected alertHandler
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

    func decodeJSON<T: Decodable>(from response: Any, to type: T.Type) throws
        -> T
    {
        guard let responseDictionary = response as? [String: Any] else {
            throw NSError(
                domain: "JSONDecodingError", code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format"])
        }

        let jsonData = try JSONSerialization.data(
            withJSONObject: responseDictionary, options: [])
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: jsonData)
    }

    /// Builds a URL for RTPS Web based on the provided integration and configuration details.
    /// - Parameters:
    ///   - integrationKey: The unique integration key for the request.
    ///   - setupConfig: Configuration details for the buyer and store.
    ///   - rtpsConfig: Configuration for RTPS settings, including mock responses and prescreen data.
    /// - Returns: A URL constructed with the given parameters, or nil if the URL could not be built.
    func buildRTPSWebURL(
        integrationKey: String,
        setupConfig: BreadPartnersSetupConfig,
        rtpsConfig: BreadPartnersRtpsConfig
    ) -> URL? {
        let queryParams: [String: String?] = [
            "mockMO": rtpsConfig.mockResponse?.rawValue,
            "mockPA": rtpsConfig.mockResponse?.rawValue,
            "mockVL": rtpsConfig.mockResponse?.rawValue,
            "embedded": "true",
            "clientKey": integrationKey,
            "prescreenId": rtpsConfig.prescreenId,
            "cardType": rtpsConfig.cardType,
            "urlPath": "screen name",
            "firstName": setupConfig.buyer?.givenName,
            "lastName": setupConfig.buyer?.familyName,
            "address1": setupConfig.buyer?.billingAddress?.address1,
            "city": setupConfig.buyer?.billingAddress?.locality,
            "state": setupConfig.buyer?.billingAddress?.region,
            "zip": setupConfig.buyer?.billingAddress?.postalCode,
            "storeNumber": setupConfig.storeNumber,
            "location": rtpsConfig.locationType?.rawValue,
            "channel": rtpsConfig.channel,
        ]
        guard
            var urlComponents = URLComponents(
                string: APIUrl(urlType: .rtpsWebUrl(type: "offer")).url)
        else {
            return nil
        }

        urlComponents.queryItems = queryParams.compactMap { key, value in
            guard let value = value, !value.isEmpty else { return nil }
            return URLQueryItem(name: key, value: value)
        }

        return urlComponents.url

    }

}
