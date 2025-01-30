class RTPSRequestBuilder {

    private var setupConfig: BreadPartnersSetupConfig
    private var rtpsConfig: BreadPartnersRtpsConfig

    init(setupConfig: BreadPartnersSetupConfig, rtpsConfig: BreadPartnersRtpsConfig) {
        self.setupConfig = setupConfig
        self.rtpsConfig = rtpsConfig
    }

    func build() -> RTPSRequest {
        let buyer = setupConfig.buyer

        return RTPSRequest(
            urlPath: "screenname",
            firstName: buyer?.givenName,
            lastName: buyer?.familyName,
            address1: buyer?.billingAddress?.address1,
            city: buyer?.billingAddress?.region,
            state: buyer?.billingAddress?.locality,
            zip: buyer?.billingAddress?.postalCode,
            storeNumber: setupConfig.storeNumber,
            location: rtpsConfig.locationType?.rawValue,
            channel: setupConfig.channel,
            subchannel: setupConfig.subchannel,
            reCaptchaToken: nil,
            mockResponse: rtpsConfig.mockResponse?.rawValue,
            overrideConfig: RTPSRequest.OverrideConfig(enhancedPresentment: true)
        )
    }
}
