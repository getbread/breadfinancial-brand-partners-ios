import Foundation

/// Enum to define different types of API URLs.
internal enum APIUrlType {
    case brandStyle(brandId: String)
    case brandConfig(brandId: String)
    case generatePlacements
    case viewPlacement
    case clickPlacement
    case prescreen
    case virtualLookup
}

/// A centralized class for constructing and managing API URLs.
internal class APIUrl {
    // Base URL
    private let baseURL: String = "https://brands.kmsmep.com"
    private let rtpsBaseURL: String = "https://acquire1uat.comenity.net/api"

    /// The URL type that defines what kind of URL to generate.
    private let urlType: APIUrlType

    /// Initializer for APIUrl with a configurable URL type.
    public init(urlType: APIUrlType) {
        self.urlType = urlType
    }

    /// Generates the correct URL based on the URL type.
    public var url: String {
        switch urlType {
        case .brandStyle(let brandId):
            return "\(baseURL)/brands/\(brandId)/style"
        case .brandConfig(let brandId):
            return "\(baseURL)/brands/\(brandId)/config"
        case .generatePlacements:
            return "\(baseURL)/generatePlacements"
        case .viewPlacement:
            return "\(baseURL)/ep/v1/view-placement"
        case .clickPlacement:
            return "\(baseURL)/ep/v1/click-placement"
        case .prescreen:
            return "\(rtpsBaseURL)/prescreen"
        case .virtualLookup:
            return "\(rtpsBaseURL)/virtual_lookup"
        }
    }
}
