import SwiftUI

struct TextSizeSettingsView: View {
    @EnvironmentObject private var store: DataStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Picker("Text Size", selection: Binding(
                    get: { store.settings.textSize },
                    set: { store.setSettings(UserSettings(
                        language: store.settings.language,
                        theme: store.settings.theme,
                        textSize: $0,
                        profile: store.settings.profile
                    ))}
                )) {
                    ForEach(TextSize.allCases) { size in
                        Text(size.rawValue.capitalized).tag(size)
                    }
                }
            }
            .navigationTitle("Text Size")
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
    TextSizeSettingsView()
        .environmentObject(DataStore())
}
