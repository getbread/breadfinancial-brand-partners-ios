import RecaptchaEnterprise

protocol RecaptchaManagerProtocol {
    func executeReCaptcha(
        siteKey: String,
        action: RecaptchaAction,
        timeout: Double,
        debug: Bool,
        completion: @escaping (Result<String, Error>) -> Void
    )
}

/// `RecaptchaManager` handles the process of executing a reCAPTCHA for verifying user actions.
internal class RecaptchaManager: RecaptchaManagerProtocol {
    
    private let logger: LoggerProtocol
    
    init(logger: LoggerProtocol = Logger()) {
        self.logger = logger
    }
    
    func executeReCaptcha(
        siteKey: String,
        action: RecaptchaAction,
        timeout: Double = 10000,
        debug: Bool = false,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        Task {
            do {
                let client = try await Recaptcha.fetchClient(withSiteKey: siteKey)
                let token = try await client.execute(withAction: action, withTimeout: timeout)
                
                if(debug){
                    logger.logReCaptchaToken(token:token)
                }
                completion(.success(token))
            } catch let error as RecaptchaError {
                completion(.failure(error))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
