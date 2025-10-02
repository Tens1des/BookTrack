import SwiftUI

struct ProfileSettingsView: View {
    @EnvironmentObject private var store: DataStore
    @State private var showEditProfileSheet = false

    var body: some View {
        NavigationStack {
            ScrollView {
                ProfileHeaderView()
                    .onTapGesture { showEditProfileSheet = true }

                ProfileSectionHeader(title: "READING STATS")
                ReadingStatsCard(
                    booksRead: store.books.filter { $0.status == .finished }.count,
                    pagesRead: store.totalReadPages,
                    avgRating: store.averageRating
                )
                .padding(.horizontal, 16)

                ProfileSectionHeader(title: "PREFERENCES")
                VStack(spacing: 0) {
                    SettingsRow(
                        title: "Dark Mode",
                        subtitle: "Enable dark theme",
                        icon: "moon.fill",
                        toggleValue: Binding(
                            get: { store.settings.theme == .dark },
                            set: { newValue in
                                store.setSettings(UserSettings(
                                    language: store.settings.language,
                                    theme: newValue ? .dark : .light,
                                    textSize: store.settings.textSize,
                                    profile: store.settings.profile
                                ))
                            }
                        )
                    )
                    NavigationLink(destination: LanguageSettingsView()) {
                        SettingsRow(title: "Language", subtitle: "Choose app language", icon: "globe")
                    }
                    NavigationLink(destination: TextSizeSettingsView()) {
                        SettingsRow(title: "Text Size", subtitle: "Adjust font size", icon: "textformat.size")
                    }
                }
                .padding(.horizontal, 16)
            }
            .navigationTitle("Profile")
            .navigationBarHidden(true)
            .sheet(isPresented: $showEditProfileSheet) {
                EditProfileView()
            }
        }
    }
}



