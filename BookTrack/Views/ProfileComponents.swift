import SwiftUI

struct ProfileHeaderView: View {
    @EnvironmentObject var store: DataStore
    
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
                // Action to open edit profile sheet/view
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
            HStack(spacing: 0) {
                StatColumn(value: String(booksRead), label: "Books Read", color: .blue)
                Divider().frame(height: 50)
                StatColumn(value: formatPages(pagesRead), label: "Pages", color: .purple)
                Divider().frame(height: 50)
                StatColumn(value: String(format: "%.1f", avgRating), label: "Avg Rating", color: .pink)
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
    let color: Color

    var body: some View {
        VStack {
            Text(value)
                .font(.title2).bold()
                .foregroundStyle(color)
            Text(label)
                .font(.caption)
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
        Text(title)
            .font(.caption).bold()
            .foregroundStyle(.secondary)
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
