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
        checkAchievements()
    }

    // MARK: - Public API

    func addBook(_ book: Book) {
        books.insert(book, at: 0)
        saveBooks()
        checkAchievements()
    }

    func updateBook(_ book: Book) {
        guard let idx = books.firstIndex(where: { $0.id == book.id }) else { return }
        books[idx] = book
        saveBooks()
        checkAchievements()
    }

    func deleteBooks(ids: [UUID]) {
        books.removeAll { ids.contains($0.id) }
        saveBooks()
        checkAchievements()
    }

    func toggleFavorite(_ id: UUID) {
        guard let idx = books.firstIndex(where: { $0.id == id }) else { return }
        books[idx].isFavorite.toggle()
        saveBooks()
        checkAchievements()
    }

    func addNote(_ text: String, to bookId: UUID) {
        guard let idx = books.firstIndex(where: { $0.id == bookId }) else { return }
        books[idx].notes.insert(Note(text: text), at: 0)
        saveBooks()
        checkAchievements()
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
        checkAchievements()
    }
    
    private func updateGoalsProgress() {
        let finishedCount = books.filter { $0.status == .finished }.count
        for i in goals.indices {
            goals[i].completedBooks = finishedCount
        }
        saveGoals()
        checkAchievements() // Проверяем ачивки после обновления целей
    }

    func setSettings(_ new: UserSettings) {
        settings = new
        saveSettings()
        print("🌍 Language changed to: \(new.language.rawValue)")
    }
    
    func checkAchievements() {
        let finishedBooks = books.filter { $0.status == .finished }
        let ratedBooks = finishedBooks.filter { $0.rating != nil }
        let booksWithNotes = books.filter { !$0.notes.isEmpty }
        let booksWithDates = books.filter { $0.startDate != nil && $0.endDate != nil }
        let favoriteBooks = books.filter { $0.isFavorite }
        
        var updatedAchievements = achievements
        var hasNewAchievements = false
        
        // 📖 Первая глава - Добавь свою первую книгу
        if !books.isEmpty && !updatedAchievements[0].isUnlocked {
            updatedAchievements[0].isUnlocked = true
            updatedAchievements[0].unlockedAt = Date()
            hasNewAchievements = true
        }
        
        // ✅ Закладка - Заверши первую книгу
        if !finishedBooks.isEmpty && !updatedAchievements[1].isUnlocked {
            updatedAchievements[1].isUnlocked = true
            updatedAchievements[1].unlockedAt = Date()
            hasNewAchievements = true
        }
        
        // ✨ Маленькая полка - Прочитай 5 книг
        if finishedBooks.count >= 5 && !updatedAchievements[2].isUnlocked {
            updatedAchievements[2].isUnlocked = true
            updatedAchievements[2].unlockedAt = Date()
            hasNewAchievements = true
        }
        
        // 📚 Большая библиотека - Прочитай 20 книг
        if finishedBooks.count >= 20 && !updatedAchievements[3].isUnlocked {
            updatedAchievements[3].isUnlocked = true
            updatedAchievements[3].unlockedAt = Date()
            hasNewAchievements = true
        }
        
        // ⭐ Книжный критик - Оцени 10 книг
        if ratedBooks.count >= 10 && !updatedAchievements[4].isUnlocked {
            updatedAchievements[4].isUnlocked = true
            updatedAchievements[4].unlockedAt = Date()
            hasNewAchievements = true
        }
        
        // 📝 Мои заметки - Добавь 5 рецензий или заметок
        if booksWithNotes.count >= 5 && !updatedAchievements[5].isUnlocked {
            updatedAchievements[5].isUnlocked = true
            updatedAchievements[5].unlockedAt = Date()
            hasNewAchievements = true
        }
        
        // 🕰️ Читатель времени - Отметь дату начала и завершения для 10 книг
        if booksWithDates.count >= 10 && !updatedAchievements[6].isUnlocked {
            updatedAchievements[6].isUnlocked = true
            updatedAchievements[6].unlockedAt = Date()
            hasNewAchievements = true
        }
        
        // ❤️ Любимая история - Добавь книгу в «избранное»
        if !favoriteBooks.isEmpty && !updatedAchievements[7].isUnlocked {
            updatedAchievements[7].isUnlocked = true
            updatedAchievements[7].unlockedAt = Date()
            hasNewAchievements = true
        }
        
        // 🎯 На пути к цели - Выполни одну из личных целей
        let hasCompletedGoal = goals.contains { $0.completedBooks >= $0.targetBooks }
        if hasCompletedGoal && !updatedAchievements[8].isUnlocked {
            updatedAchievements[8].isUnlocked = true
            updatedAchievements[8].unlockedAt = Date()
            hasNewAchievements = true
        }
        
        // 🌟 Настоящий книголюб - Прочитай 50 книг
        if finishedBooks.count >= 50 && !updatedAchievements[9].isUnlocked {
            updatedAchievements[9].isUnlocked = true
            updatedAchievements[9].unlockedAt = Date()
            hasNewAchievements = true
        }
        
        if hasNewAchievements {
            achievements = updatedAchievements
            saveAchievements()
            // Здесь можно добавить уведомление о новых ачивках
            print("🎉 New achievements unlocked!")
        }
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



