import Foundation

enum ReadingStatus: String, Codable, CaseIterable, Identifiable {
    case planning
    case reading
    case finished

    var id: String { rawValue }
}

struct Note: Identifiable, Codable, Hashable {
    let id: UUID
    var text: String
    var createdAt: Date

    init(id: UUID = UUID(), text: String, createdAt: Date = Date()) {
        self.id = id
        self.text = text
        self.createdAt = createdAt
    }
}

struct Book: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var author: String?
    var totalPages: Int?
    var genre: String?
    var status: ReadingStatus
    var startDate: Date?
    var endDate: Date?
    var currentPage: Int?
    var rating: Int? // 1..10
    var isFavorite: Bool
    var notes: [Note]
    var createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        author: String? = nil,
        totalPages: Int? = nil,
        genre: String? = nil,
        status: ReadingStatus = .planning,
        startDate: Date? = nil,
        endDate: Date? = nil,
        currentPage: Int? = nil,
        rating: Int? = nil,
        isFavorite: Bool = false,
        notes: [Note] = [],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.totalPages = totalPages
        self.genre = genre
        self.status = status
        self.startDate = startDate
        self.endDate = endDate
        self.currentPage = currentPage
        self.rating = rating
        self.isFavorite = isFavorite
        self.notes = notes
        self.createdAt = createdAt
    }

    var progressPercent: Int {
        guard let total = totalPages, total > 0, let page = currentPage else { return 0 }
        return max(0, min(100, Int((Double(page) / Double(total)) * 100.0)))
    }
}



