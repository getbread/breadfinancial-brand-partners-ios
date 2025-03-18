/// Represents the different environments the SDK can operate in.
///
/// - `stage`: Use this environment for testing and development.
/// - `prod`: **Default** Use this environment for production.
public enum BreadPartnersEnvironment: String, CaseIterable {
    case stage = "STAGE"
    case prod = "PROD"
}
