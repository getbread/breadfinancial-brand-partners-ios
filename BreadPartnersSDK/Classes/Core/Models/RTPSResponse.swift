import Foundation

struct RTPSResponse: Codable {
    let returnCode: Int
    let errorMessage: String
    let errorCode: Int
    let address1: String?
    let address2: String?
    let city: String?
    let state: String?
    let zip: String?
    let firstName: String?
    let middleInitial: String?
    let lastName: String?
    let prescreenId: Int
    let isExpired: Bool
    let cardType: String?
    let hasExistingAccount: Bool?
    let debug: DebugInfo?

    struct DebugInfo: Codable {
        let requests: String?
    }
}
