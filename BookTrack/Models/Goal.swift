import Foundation

enum GoalPeriod: String, Codable, CaseIterable, Identifiable {
    case week
    case month
    case year

    var id: String { rawValue }
}

struct Goal: Identifiable, Codable, Hashable {
    let id: UUID
    var period: GoalPeriod
    var targetBooks: Int
    var completedBooks: Int
    var updatedAt: Date

    init(id: UUID = UUID(), period: GoalPeriod, targetBooks: Int, completedBooks: Int = 0, updatedAt: Date = Date()) {
        self.id = id
        self.period = period
        self.targetBooks = targetBooks
        self.completedBooks = completedBooks
        self.updatedAt = updatedAt
    }

    var progress: Double {
        guard targetBooks > 0 else { return 0 }
        return min(1.0, Double(completedBooks) / Double(targetBooks))
    }
}



