//------------------------------------------------------------------------------
//  File:          RTPSRequestBuilder.swift
//  Author(s):     Bread Financial
//  Date:          27 March 2025
//
//  Descriptions:  This file is part of the BreadPartnersSDK for iOS,
//  providing UI components and functionalities to integrate Bread Financial
//  services into partner applications.
//
//  © 2025 Bread Financial
//------------------------------------------------------------------------------

/// Builder class for constructing RTPS requests.
class RTPSRequestBuilder {

    private var merchantConfiguration: MerchantConfiguration
    private var rtpsData: RTPSData
    private var token: String

    init(
        merchantConfiguration: MerchantConfiguration,
        rtpsData: RTPSData,
        reCaptchaToken: String
    ) {
        self.merchantConfiguration = merchantConfiguration
        self.rtpsData = rtpsData
        self.token = reCaptchaToken
    }

    func build() -> RTPSRequest {
        let buyer = merchantConfiguration.buyer

        if rtpsData.prescreenId == nil {
            return RTPSRequest(
                urlPath: "screenname",
                firstName: buyer?.givenName,
                lastName: buyer?.familyName,
                address1: buyer?.billingAddress?.address1,
                city: buyer?.billingAddress?.region,
                state: buyer?.billingAddress?.locality,
                zip: buyer?.billingAddress?.postalCode,
                storeNumber: merchantConfiguration.storeNumber,
                location: rtpsData.locationType?.rawValue,
                channel: merchantConfiguration.channel,
                subchannel: merchantConfiguration.subchannel,
                reCaptchaToken: token,
                mockResponse: rtpsData.mockResponse?.rawValue,
                overrideConfig: RTPSRequest.OverrideConfig(
                    enhancedPresentment: true)
            )
        } else {
            return RTPSRequest(
                urlPath: "screenname",
                location: rtpsData.locationType?.rawValue,
                channel: merchantConfiguration.channel,
                subchannel: merchantConfiguration.subchannel,
                mockResponse: rtpsData.mockResponse?.rawValue,
                overrideConfig: RTPSRequest.OverrideConfig(
                    enhancedPresentment: true),
                prescreenId: String(rtpsData.prescreenId!)
            )
        }

    }
}
