import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject private var store: DataStore
    @Environment(\.dismiss) private var dismiss

    @State private var displayName: String = ""
    @State private var avatarSymbol: String = ""
    
    private let availableAvatars = [
        "person.circle.fill", "book.closed.fill", "leaf.fill", "sparkles",
        "heart.fill", "star.fill", "moon.fill", "sun.max.fill", "cloud.fill"
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Current Avatar Preview
                    VStack(spacing: 16) {
                        Image(systemName: avatarSymbol)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .padding(20)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 2))
                        
                                Text(LocalizedStrings.currentAvatar(store.settings.language))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Name Input
                    VStack(alignment: .leading, spacing: 8) {
                                Text(LocalizedStrings.displayName(store.settings.language))
                                    .font(.headline)
                                TextField(LocalizedStrings.enterName(store.settings.language), text: $displayName)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding(.horizontal, 16)
                    
                    // Avatar Selection
                    VStack(alignment: .leading, spacing: 12) {
                                Text(LocalizedStrings.chooseAvatar(store.settings.language))
                            .font(.headline)
                            .padding(.horizontal, 16)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                            ForEach(availableAvatars, id: \.self) { symbol in
                                Button(action: { avatarSymbol = symbol }) {
                                    Image(systemName: symbol)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .padding(16)
                                        .background(
                                            Circle()
                                                .fill(avatarSymbol == symbol ? Color.accentColor.opacity(0.2) : Color.gray.opacity(0.1))
                                        )
                                        .overlay(
                                            Circle()
                                                .stroke(avatarSymbol == symbol ? Color.accentColor : Color.clear, lineWidth: 2)
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.bottom, 20)
            }
                    .navigationTitle(LocalizedStrings.editProfile(store.settings.language))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(LocalizedStrings.cancel(store.settings.language)) { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizedStrings.save(store.settings.language)) {
                        var updatedProfile = store.settings.profile
                                updatedProfile.displayName = displayName.isEmpty ? LocalizedStrings.bookLover(store.settings.language) : displayName
                        updatedProfile.avatarSymbol = avatarSymbol
                        store.setSettings(UserSettings(
                            language: store.settings.language,
                            theme: store.settings.theme,
                            textSize: store.settings.textSize,
                            profile: updatedProfile
                        ))
                        dismiss()
                    }
                    .disabled(displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .onAppear {
            displayName = store.settings.profile.displayName
            avatarSymbol = store.settings.profile.avatarSymbol
        }
    }
}

#Preview {
    EditProfileView()
        .environmentObject(DataStore())
}
