import Foundation

struct RTPSRequest: Codable {
    let urlPath: String?
    let firstName: String?
    let lastName: String?
    let address1: String?
    let city: String?
    let state: String?
    let zip: String?
    let storeNumber: String?
    let location: String?
    let channel: String?
    let subchannel: String?
    var reCaptchaToken: String?
    let mockResponse: String?
    let overrideConfig: OverrideConfig?
    let prescreenId: String?
    
    struct OverrideConfig: Codable {
        let enhancedPresentment: Bool?
    }
    
    init(
        urlPath: String? = nil,
        firstName: String? = nil,
        lastName: String? = nil,
        address1: String? = nil,
        city: String? = nil,
        state: String? = nil,
        zip: String? = nil,
        storeNumber: String? = nil,
        location: String? = nil,
        channel: String? = nil,
        subchannel: String? = nil,
        reCaptchaToken: String? = nil,
        mockResponse: String? = nil,
        overrideConfig: OverrideConfig? = nil,
        prescreenId: String? = nil
    ) {
        self.urlPath = urlPath
        self.firstName = firstName
        self.lastName = lastName
        self.address1 = address1
        self.city = city
        self.state = state
        self.zip = zip
        self.storeNumber = storeNumber
        self.location = location
        self.channel = channel
        self.subchannel = subchannel
        self.reCaptchaToken = reCaptchaToken
        self.mockResponse = mockResponse
        self.overrideConfig = overrideConfig
        self.prescreenId = prescreenId
        
    }
}
