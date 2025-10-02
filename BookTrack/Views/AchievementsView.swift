import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject private var store: DataStore
    
    private let achievementIcons = [
        "📖", "✅", "✨", "📚", "⭐", "📝", "🕰️", "❤️", "🎯", "🌟"
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(store.achievements.enumerated()), id: \.element.id) { index, achievement in
                AchievementRow(
                    icon: achievementIcons[index],
                    title: achievement.title,
                    description: achievement.description,
                    isUnlocked: achievement.isUnlocked
                )
                
                if index < store.achievements.count - 1 {
                    Divider()
                        .padding(.horizontal, 16)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.background.opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.gray.opacity(0.12))
        )
    }
}

struct AchievementRow: View {
    let icon: String
    let title: String
    let description: String
    let isUnlocked: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Text(icon)
                .font(.system(size: 24))
                .opacity(isUnlocked ? 1.0 : 0.3)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(isUnlocked ? Color.accentColor.opacity(0.1) : Color.gray.opacity(0.05))
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(isUnlocked ? .primary : .secondary)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            if isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.title3)
            } else {
                Image(systemName: "lock.circle.fill")
                    .foregroundStyle(.gray)
                    .font(.title3)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#Preview {
    AchievementsView()
        .environmentObject(DataStore())
}
