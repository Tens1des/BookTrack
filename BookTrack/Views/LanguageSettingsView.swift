import SwiftUI

struct LanguageSettingsView: View {
    @EnvironmentObject private var store: DataStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Picker("Language", selection: Binding(
                    get: { store.settings.language },
                    set: { store.setSettings(UserSettings(
                        language: $0,
                        theme: store.settings.theme,
                        textSize: store.settings.textSize,
                        profile: store.settings.profile
                    ))}
                )) {
                    ForEach(AppLanguage.allCases) { lang in
                        Text(lang.rawValue.capitalized).tag(lang)
                    }
                }
            }
            .navigationTitle("Language")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    LanguageSettingsView()
        .environmentObject(DataStore())
}
