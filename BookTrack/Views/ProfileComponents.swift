import SwiftUI

struct ProfileHeaderView: View {
    @EnvironmentObject var store: DataStore
    @Binding var showEditProfile: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: store.settings.profile.avatarSymbol)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .padding(15)
                .background(Color.white.opacity(0.2))
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 2))

            Text(store.settings.profile.displayName)
                .font(.title2).bold()
                .foregroundStyle(.white)

            Text("Member since \(store.settings.profile.createdAt.formatted(date: .abbreviated, time: .omitted))")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))

            Button("Edit Profile") {
                showEditProfile = true
            }
            .font(.subheadline).bold()
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(Color.white.opacity(0.2))
            .foregroundStyle(.white)
            .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

struct ReadingStatsCard: View {
    let booksRead: Int
    let pagesRead: Int
    let avgRating: Double

    var body: some View {
        Card {
            VStack(spacing: 16) {
                HStack {
                    Text("Your Reading Journey")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Spacer()
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .foregroundStyle(.tint)
                }
                
                HStack(spacing: 0) {
                    StatColumn(
                        value: String(booksRead), 
                        label: "Books Read", 
                        gradient: [.blue, .cyan],
                        icon: "book.fill"
                    )
                    Divider()
                        .frame(height: 50)
                        .background(
                            LinearGradient(
                                colors: [.clear, .gray.opacity(0.3), .clear],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    StatColumn(
                        value: formatPages(pagesRead), 
                        label: "Pages", 
                        gradient: [.green, .mint],
                        icon: "doc.text.fill"
                    )
                    Divider()
                        .frame(height: 50)
                        .background(
                            LinearGradient(
                                colors: [.clear, .gray.opacity(0.3), .clear],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    StatColumn(
                        value: String(format: "%.1f", avgRating), 
                        label: "Avg Rating", 
                        gradient: [.orange, .yellow],
                        icon: "star.fill"
                    )
                }
            }
        }
    }

    private func formatPages(_ pages: Int) -> String {
        if pages >= 1000 {
            return String(format: "%.1fK", Double(pages) / 1000.0)
        } else {
            return String(pages)
        }
    }
}

struct StatColumn: View {
    let value: String
    let label: String
    let gradient: [Color]
    let icon: String

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(.white)
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(
                    LinearGradient(
                        colors: gradient,
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct SettingsRow: View {
    let title: String
    let subtitle: String
    let icon: String
    var showChevron: Bool = true
    @Binding var toggleValue: Bool
    var isToggle: Bool

    init(title: String, subtitle: String, icon: String, showChevron: Bool = true) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.showChevron = showChevron
        self._toggleValue = .constant(false)
        self.isToggle = false
    }

    init(title: String, subtitle: String, icon: String, toggleValue: Binding<Bool>) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.showChevron = false
        self._toggleValue = toggleValue
        self.isToggle = true
    }

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .frame(width: 30, height: 30)
                .foregroundStyle(.secondary)
                .background(Color.gray.opacity(0.1))
                .clipShape(Circle())

            VStack(alignment: .leading) {
                Text(title).font(.headline)
                Text(subtitle).font(.caption).foregroundStyle(.secondary)
            }

            Spacer()

            if isToggle {
                Toggle(isOn: $toggleValue) {}.labelsHidden()
            } else if showChevron {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}

struct ProfileSectionHeader: View {
    let title: String
    var body: some View {
        HStack {
            HStack(spacing: 8) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue, .blue.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 6, height: 6)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                    .tracking(1.2)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .padding(.bottom, 8)
    }
}
