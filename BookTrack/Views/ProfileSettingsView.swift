import SwiftUI

struct ProfileSettingsView: View {
    @EnvironmentObject private var store: DataStore
    @State private var showEditProfileSheet = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(.systemBackground),
                        Color(.systemGray6).opacity(0.1),
                        Color(.systemBackground).opacity(0.95)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    ProfileHeaderView(showEditProfile: $showEditProfileSheet)

                            ProfileSectionHeader(title: LocalizedStrings.readingStats(store.settings.language))
                    ReadingStatsCard(
                        booksRead: store.books.filter { $0.status == .finished }.count,
                        pagesRead: store.totalReadPages,
                        avgRating: store.averageRating
                    )
                    .padding(.horizontal, 16)

                            ProfileSectionHeader(title: LocalizedStrings.preferences(store.settings.language))
                    
                    // Debug section
              
                    
                    VStack(spacing: 12) {
                        // Dark Mode Card
                        Card {
                            HStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [.purple, .indigo],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 50, height: 50)
                                    
                                    Image(systemName: "moon.fill")
                                        .font(.title2)
                                        .foregroundStyle(.white)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(LocalizedStrings.darkMode(store.settings.language))
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                            Text(LocalizedStrings.switchToDarkTheme(store.settings.language))
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                Toggle("", isOn: Binding(
                                    get: { store.settings.theme == .dark },
                                    set: { newValue in
                                        store.setSettings(UserSettings(
                                            language: store.settings.language,
                                            theme: newValue ? .dark : .light,
                                            textSize: store.settings.textSize,
                                            profile: store.settings.profile
                                        ))
                                    }
                                ))
                                .toggleStyle(SwitchToggleStyle(tint: .purple))
                            }
                        }
                        
                        // Language Card
                        Card {
                            HStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [.blue, .cyan],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 50, height: 50)
                                    
                                    Image(systemName: "globe")
                                        .font(.title2)
                                        .foregroundStyle(.white)
                                }
                                
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(LocalizedStrings.language(store.settings.language))
                                                .font(.headline)
                                                .fontWeight(.semibold)
                                            Text(LocalizedStrings.chooseAppLanguage(store.settings.language))
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
                                        }
                                
                                Spacer()
                                
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
                                                Text(lang == .english ? "English" : "Русский").tag(lang)
                                            }
                                        }
                                .pickerStyle(.menu)
                                .tint(.blue)
                            }
                        }
                        
                        // Text Size Card
                        Card {
                            HStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [.orange, .red],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 50, height: 50)
                                    
                                    Image(systemName: "textformat.size")
                                        .font(.title2)
                                        .foregroundStyle(.white)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(LocalizedStrings.textSize(store.settings.language))
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                            Text(LocalizedStrings.adjustFontSize(store.settings.language))
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
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
                                .pickerStyle(.menu)
                                .tint(.orange)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    
                            ProfileSectionHeader(title: LocalizedStrings.achievements(store.settings.language))
                    AchievementsView()
                        .padding(.horizontal, 16)
                }
            }
                    .navigationTitle(LocalizedStrings.profile(store.settings.language))
            .navigationBarHidden(true)
            .sheet(isPresented: $showEditProfileSheet) {
                EditProfileView()
            }
        }
        .id(store.settings.language)
    }
}



