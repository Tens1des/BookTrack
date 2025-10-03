import SwiftUI

extension View {
    func localized(_ key: String, language: AppLanguage) -> String {
        LocalizedStrings.localized(key, language: language)
    }
}

// MARK: - Environment Key for Language
struct LanguageKey: EnvironmentKey {
    static let defaultValue: AppLanguage = .english
}

extension EnvironmentValues {
    var language: AppLanguage {
        get { self[LanguageKey.self] }
        set { self[LanguageKey.self] = newValue }
    }
}

// MARK: - Localized Text View
struct LocalizedText: View {
    let key: String
    @Environment(\.language) private var language
    
    var body: some View {
        Text(LocalizedStrings.localized(key, language: language))
    }
}

// MARK: - Localized Button
struct LocalizedButton: View {
    let key: String
    let action: () -> Void
    @Environment(\.language) private var language
    
    var body: some View {
        Button(LocalizedStrings.localized(key, language: language), action: action)
    }
}
