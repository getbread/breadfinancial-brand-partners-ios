import Foundation

internal struct BrandConfigResponse: Codable {
    let config: Config
}

internal struct Config: Codable {
    let AEMContent: String
    let OVERRIDE_KEY: String
    let clientName: String
    let prodAdServerUrl: String
    let qaAdServerUrl: String
    let recaptchaEnabledQA: String
    let recaptchaSiteKeyQA: String
    let test: String
    
    init(
        AEMContent: String = "",
        OVERRIDE_KEY: String = "",
        clientName: String = "",
        prodAdServerUrl: String = "",
        qaAdServerUrl: String = "",
        recaptchaEnabledQA: String = "",
        recaptchaSiteKeyQA: String = "",
        test: String = ""
    ) {
        self.AEMContent = AEMContent
        self.OVERRIDE_KEY = OVERRIDE_KEY
        self.clientName = clientName
        self.prodAdServerUrl = prodAdServerUrl
        self.qaAdServerUrl = qaAdServerUrl
        self.recaptchaEnabledQA = recaptchaEnabledQA
        self.recaptchaSiteKeyQA = recaptchaSiteKeyQA
        self.test = test
    }
}
