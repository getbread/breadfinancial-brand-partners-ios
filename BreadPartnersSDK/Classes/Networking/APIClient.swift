import Foundation

/// Enum for HTTP Method Types.
internal enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

/// A utility class for making HTTP API requests.
internal class APIClient {

    private let urlSession: URLSession
    private let logger: Logger

    // Dependency Injection through the initializer
    init(urlSession: URLSession, logger: Logger) {
        self.urlSession = urlSession
        self.logger = logger
    }

    /// Generic API call function
    ///
    /// - Parameters:
    ///   - urlString: The URL endpoint as a string.
    ///   - method: HTTP method (e.g., "GET", "POST").
    ///   - body: Optional request body, can be a dictionary (`[String: Any]`) or a Codable model.
    ///   - completion: Closure to handle the result, returning a success with response or failure with error.
    func request(
        urlString: String,
        method: HTTPMethod = .POST,
        body: Any? = nil
    ) async throws -> Any {
        // Validate the URL
        guard let url = URL(string: urlString) else {
            throw NSError(
                domain: "InvalidURL", code: 400,
                userInfo: [
                    NSLocalizedDescriptionKey: "The URL provided is invalid."
                ])
        }

        // Configure the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let headers = ["content-type": "application/json"]

        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        // Add body if provided
        if let body = body {
            do {
                if let bodyDictionary = body as? [String: Any] {
                    request.httpBody = try JSONSerialization.data(
                        withJSONObject: bodyDictionary, options: [])
                } else if let bodyCodable = body as? Encodable {
                    let encoder = JSONEncoder()
                    encoder.keyEncodingStrategy = .useDefaultKeys
                    request.httpBody = try encoder.encode(bodyCodable)
                } else {
                    throw NSError(
                        domain: "UnsupportedBodyType", code: 400,
                        userInfo: [
                            NSLocalizedDescriptionKey:
                                "The request body is not supported."
                        ])
                }
            } catch {
                throw NSError(
                    domain: "SerializationError", code: 500,
                    userInfo: [
                        NSLocalizedDescriptionKey:
                            "Failed to serialize the request body."
                    ])
            }
        }

        // Log the request details
        logger.logRequestDetails(
            url: url, method: method.rawValue, headers: headers,
            body: request.httpBody)

        let (data, response) = try await urlSession.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(
                domain: "InvalidResponse", code: 500,
                userInfo: [
                    NSLocalizedDescriptionKey: "Invalid response from server."
                ])
        }

        logger.logResponseDetails(
            url: url, statusCode: httpResponse.statusCode,
            headers: httpResponse.allHeaderFields, body: data)

        // Validate HTTP status code
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NSError(
                domain: "HTTPError", code: httpResponse.statusCode,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Server returned an error: \(httpResponse.statusCode)"
                ])
        }

        // Decode the response data
        do {
            return try JSONSerialization.jsonObject(with: data, options: [])
        } catch {
            throw NSError(
                domain: "DecodingError", code: 500,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Failed to decode the server response."
                ])
        }

    }
}
