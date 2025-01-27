import Foundation

public struct BreadPartnersSDKSetup: Codable {
    var integrationKey: String
    var buyer: Buyer
    var enableLog: Bool

    public init(integrationKey: String, buyer: Buyer, enableLog: Bool = false) {
        self.integrationKey = integrationKey
        self.buyer = buyer
        self.enableLog = enableLog
    }
}

public struct Buyer: Codable {
    var givenName: String?
    var familyName: String?
    var additionalName: String?
    var birthDate: String?
    var email: String?
    var phone: String?
    var billingAddress: Address?
    var shippingAddress: Address?

    public init(
        givenName: String? = nil,
        familyName: String? = nil,
        additionalName: String? = nil,
        birthDate: String? = nil,
        email: String? = nil,
        phone: String? = nil,
        billingAddress: Address? = nil,
        shippingAddress: Address? = nil
    ) {
        self.givenName = givenName
        self.familyName = familyName
        self.additionalName = additionalName
        self.birthDate = birthDate
        self.email = email
        self.phone = phone
        self.billingAddress = billingAddress
        self.shippingAddress = shippingAddress
    }
}

public struct Address: Codable {
    var address1: String?
    var address2: String?
    var country: String?
    var locality: String?
    var region: String?
    var postalCode: String?

    public init(
        address1: String? = nil,
        address2: String? = nil,
        country: String? = nil,
        locality: String? = nil,
        region: String? = nil,
        postalCode: String? = nil
    ) {
        self.address1 = address1
        self.address2 = address2
        self.country = country
        self.locality = locality
        self.region = region
        self.postalCode = postalCode
    }
}
