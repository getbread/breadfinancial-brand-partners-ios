class RTPSRequestBuilder {

    private var merchantConfiguration: MerchantConfiguration
    private var rtpsData: RTPSData

    init(merchantConfiguration: MerchantConfiguration, rtpsData: RTPSData) {
        self.merchantConfiguration = merchantConfiguration
        self.rtpsData = rtpsData
    }

    func build() -> RTPSRequest {
        let buyer = merchantConfiguration.buyer

        return RTPSRequest(
            urlPath: "screenname",
            firstName: buyer?.givenName,
            lastName: buyer?.familyName,
            address1: buyer?.billingAddress?.address1,
            city: buyer?.billingAddress?.region,
            state: buyer?.billingAddress?.locality,
            zip: buyer?.billingAddress?.postalCode,
            storeNumber: merchantConfiguration.storeNumber,
            location: rtpsData.locationType,
            channel: merchantConfiguration.channel,
            subchannel: merchantConfiguration.subchannel,
            reCaptchaToken: nil,
            mockResponse: rtpsData.mockResponse?.rawValue,
            overrideConfig: RTPSRequest.OverrideConfig(enhancedPresentment: true)
        )
    }
}
