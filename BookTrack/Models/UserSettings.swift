import Foundation

enum AppLanguage: String, Codable, CaseIterable, Identifiable {
    case english
    case russian

    var id: String { rawValue }
}

enum AppTheme: String, Codable, CaseIterable, Identifiable {
    case light
    case dark
    case system

    var id: String { rawValue }
}

enum TextSize: String, Codable, CaseIterable, Identifiable {
    case small
    case standard
    case large

    var id: String { rawValue }
}

struct UserProfile: Codable, Hashable {
    var displayName: String
    var avatarSymbol: String // SF Symbol name
    var createdAt: Date
}

struct UserSettings: Codable, Hashable {
    var language: AppLanguage
    var theme: AppTheme
    var textSize: TextSize
    var profile: UserProfile

    static let `default` = UserSettings(
        language: .english,
        theme: .system,
        textSize: .standard,
        profile: UserProfile(displayName: "Book Lover", avatarSymbol: "person.circle", createdAt: Date())
    )
}



