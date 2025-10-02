import Foundation

struct Achievement: Identifiable, Codable, Hashable {
    let id: Int
    var title: String
    var description: String
    var isUnlocked: Bool
    var unlockedAt: Date?
}

enum AchievementCatalog {
    static let all: [Achievement] = [
        Achievement(id: 1, title: "First Chapter", description: "Add your first book.", isUnlocked: false, unlockedAt: nil),
        Achievement(id: 2, title: "Bookmark", description: "Finish your first book.", isUnlocked: false, unlockedAt: nil),
        Achievement(id: 3, title: "Small Shelf", description: "Read 5 books.", isUnlocked: false, unlockedAt: nil),
        Achievement(id: 4, title: "Big Library", description: "Read 20 books.", isUnlocked: false, unlockedAt: nil),
        Achievement(id: 5, title: "Book Critic", description: "Rate 10 books.", isUnlocked: false, unlockedAt: nil),
        Achievement(id: 6, title: "My Notes", description: "Add 5 reviews or notes.", isUnlocked: false, unlockedAt: nil),
        Achievement(id: 7, title: "Time Reader", description: "Set start and end dates for 10 books.", isUnlocked: false, unlockedAt: nil),
        Achievement(id: 8, title: "Favorite Story", description: "Add a book to favorites.", isUnlocked: false, unlockedAt: nil),
        Achievement(id: 9, title: "On Track", description: "Complete one personal goal.", isUnlocked: false, unlockedAt: nil),
        Achievement(id: 10, title: "True Bookworm", description: "Read 50 books.", isUnlocked: false, unlockedAt: nil)
    ]
}



