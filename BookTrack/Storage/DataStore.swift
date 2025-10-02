import Foundation
import Combine

final class DataStore: ObservableObject {
    @Published private(set) var books: [Book] = []
    @Published private(set) var goals: [Goal] = []
    @Published private(set) var achievements: [Achievement] = AchievementCatalog.all
    @Published var settings: UserSettings = .default
    
    var totalReadPages: Int {
        books.filter { $0.status == .finished || $0.status == .reading }
             .compactMap { $0.currentPage }
             .reduce(0, +)
    }
    
    var averageRating: Double {
        let finishedBooks = books.filter { $0.status == .finished && $0.rating != nil }
        guard !finishedBooks.isEmpty else { return 0.0 }
        let totalRating = finishedBooks.compactMap { $0.rating }.reduce(0, +)
        return Double(totalRating) / Double(finishedBooks.count)
    }

    private let ioQueue = DispatchQueue(label: "DataStore.IO")

    private var booksURL: URL { documentsURL.appendingPathComponent("books.json") }
    private var goalsURL: URL { documentsURL.appendingPathComponent("goals.json") }
    private var achievementsURL: URL { documentsURL.appendingPathComponent("achievements.json") }
    private var settingsURL: URL { documentsURL.appendingPathComponent("settings.json") }

    private var documentsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    init() {
        loadAll()
        updateGoalsProgress()
    }

    // MARK: - Public API

    func addBook(_ book: Book) {
        books.insert(book, at: 0)
        saveBooks()
    }

    func updateBook(_ book: Book) {
        guard let idx = books.firstIndex(where: { $0.id == book.id }) else { return }
        books[idx] = book
        saveBooks()
    }

    func deleteBooks(ids: [UUID]) {
        books.removeAll { ids.contains($0.id) }
        saveBooks()
    }

    func toggleFavorite(_ id: UUID) {
        guard let idx = books.firstIndex(where: { $0.id == id }) else { return }
        books[idx].isFavorite.toggle()
        saveBooks()
    }

    func addNote(_ text: String, to bookId: UUID) {
        guard let idx = books.firstIndex(where: { $0.id == bookId }) else { return }
        books[idx].notes.insert(Note(text: text), at: 0)
        saveBooks()
    }

    func setProgress(bookId: UUID, currentPage: Int) {
        guard let idx = books.firstIndex(where: { $0.id == bookId }) else { return }
        books[idx].currentPage = currentPage
        saveBooks()
    }

    func finishBook(bookId: UUID, rating: Int?) {
        guard let idx = books.firstIndex(where: { $0.id == bookId }) else { return }
        books[idx].status = .finished
        books[idx].endDate = Date()
        books[idx].rating = rating
        saveBooks()
        updateGoalsProgress()
    }
    
    private func updateGoalsProgress() {
        let finishedCount = books.filter { $0.status == .finished }.count
        for i in goals.indices {
            goals[i].completedBooks = finishedCount
        }
        saveGoals()
    }

    func setSettings(_ new: UserSettings) {
        settings = new
        saveSettings()
    }

    // MARK: - Persistence

    private func loadAll() {
        books = load([Book].self, from: booksURL) ?? []
        goals = load([Goal].self, from: goalsURL) ?? defaultGoals()
        achievements = load([Achievement].self, from: achievementsURL) ?? AchievementCatalog.all
        settings = load(UserSettings.self, from: settingsURL) ?? .default
    }

    private func saveBooks() { save(books, to: booksURL) }
    private func saveGoals() { save(goals, to: goalsURL) }
    private func saveAchievements() { save(achievements, to: achievementsURL) }
    private func saveSettings() { save(settings, to: settingsURL) }

    private func load<T: Decodable>(_ type: T.Type, from url: URL) -> T? {
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Load error: \(error)")
            return nil
        }
    }

    private func save<T: Encodable>(_ value: T, to url: URL) {
        ioQueue.async {
            do {
                let data = try JSONEncoder().encode(value)
                try data.write(to: url, options: [.atomic])
            } catch {
                print("Save error: \(error)")
            }
        }
    }

    private func defaultGoals() -> [Goal] {
        [
            Goal(period: .week, targetBooks: 2),
            Goal(period: .month, targetBooks: 5),
            Goal(period: .year, targetBooks: 24)
        ]
    }
}



