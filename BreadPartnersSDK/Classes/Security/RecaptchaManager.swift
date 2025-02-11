import RecaptchaEnterprise

/// `RecaptchaManager` handles the process of executing a reCAPTCHA for verifying user actions.
internal class RecaptchaManager {

    private let logger: Logger

    init(logger: Logger = Logger()) {
        self.logger = logger
    }

    func executeReCaptcha(
        siteKey: String,
        action: RecaptchaAction,
        timeout: Double = 10000,
        debug: Bool = false
    ) async throws -> String {
        let client = try await Recaptcha.fetchClient(withSiteKey: siteKey)
        let token = try await client.execute(
            withAction: action, withTimeout: timeout)

        if debug {
            logger.logReCaptchaToken(token: token)
        }
        return token
    }

}
