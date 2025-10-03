import Foundation

struct LocalizedStrings {
    static func localized(_ key: String, language: AppLanguage = .english) -> String {
        let strings: [String: [AppLanguage: String]] = [
            // Common
            "library": [.english: "Library", .russian: "Библиотека"],
            "statistics": [.english: "Statistics", .russian: "Статистика"],
            "profile": [.english: "Profile", .russian: "Профиль"],
            "add_book": [.english: "Add Book", .russian: "Добавить книгу"],
            "save": [.english: "Save", .russian: "Сохранить"],
            "cancel": [.english: "Cancel", .russian: "Отмена"],
            "delete": [.english: "Delete", .russian: "Удалить"],
            "edit": [.english: "Edit", .russian: "Редактировать"],
            
            // Book Status
            "reading": [.english: "Reading", .russian: "Читаю"],
            "finished": [.english: "Finished", .russian: "Прочитано"],
            "to_read": [.english: "To Read", .russian: "К прочтению"],
            "planning": [.english: "Planning", .russian: "Планирую"],
            
            // Book Details
            "title": [.english: "Title", .russian: "Название"],
            "author": [.english: "Author", .russian: "Автор"],
            "total_pages": [.english: "Total Pages", .russian: "Всего страниц"],
            "current_page": [.english: "Current Page", .russian: "Текущая страница"],
            "genre": [.english: "Genre", .russian: "Жанр"],
            "rating": [.english: "Rating", .russian: "Оценка"],
            "notes": [.english: "Notes", .russian: "Заметки"],
            "progress": [.english: "Status", .russian: "Статус"],
            "started": [.english: "Started", .russian: "Начал"],
            "pages": [.english: "pages", .russian: "страниц"],
            "unknown": [.english: "Unknown", .russian: "Неизвестно"],
            
            // Statistics
            "books_read": [.english: "Books Read", .russian: "Прочитано книг"],
            "pages_read": [.english: "Pages Read", .russian: "Прочитано страниц"],
            "average_rating": [.english: "Avg Rating", .russian: "Средняя оценка"],
            "reading_goals": [.english: "Reading Goals", .russian: "Цели чтения"],
            "achievements": [.english: "Achievements", .russian: "Достижения"],
            "my_library": [.english: "My Library", .russian: "Моя библиотека"],
            "books_in_collection": [.english: "books in your collection", .russian: "книг в коллекции"],
            "your_reading_overview": [.english: "Your Reading Overview", .russian: "Обзор чтения"],
            
            // Settings
            "settings": [.english: "Settings", .russian: "Настройки"],
            "language": [.english: "Language", .russian: "Язык"],
            "theme": [.english: "Theme", .russian: "Тема"],
            "text_size": [.english: "Text Size", .russian: "Размер текста"],
            "dark_mode": [.english: "Dark Mode", .russian: "Тёмная тема"],
            "light_mode": [.english: "Light Mode", .russian: "Светлая тема"],
            "system_theme": [.english: "System", .russian: "Системная"],
            "choose_app_language": [.english: "Choose app language", .russian: "Выберите язык приложения"],
            "switch_to_dark_theme": [.english: "Switch to dark theme", .russian: "Переключиться на тёмную тему"],
            "adjust_font_size": [.english: "Adjust font size", .russian: "Настроить размер шрифта"],
            "preferences": [.english: "PREFERENCES", .russian: "НАСТРОЙКИ"],
            "reading_stats": [.english: "READING STATS", .russian: "СТАТИСТИКА ЧТЕНИЯ"],
            
            // Actions
            "mark_as_finished": [.english: "Mark as Finished", .russian: "Отметить как прочитанную"],
            "update_progress": [.english: "Update Progress", .russian: "Обновить прогресс"],
            "add_to_favorites": [.english: "Add to Favorites", .russian: "Добавить в избранное"],
            "edit_profile": [.english: "Edit Profile", .russian: "Редактировать профиль"],
            "delete_book": [.english: "Delete Book", .russian: "Удалить книгу"],
            "enter_page": [.english: "Enter page", .russian: "Введите страницу"],
            "add_note": [.english: "Add", .russian: "Добавить"],
            "add_note_placeholder": [.english: "Add a note...", .russian: "Добавить заметку..."],
            
            // Profile
            "display_name": [.english: "Display Name", .russian: "Имя"],
            "enter_name": [.english: "Enter your name", .russian: "Введите ваше имя"],
            "choose_avatar": [.english: "Choose Avatar", .russian: "Выберите аватар"],
            "current_avatar": [.english: "Current Avatar", .russian: "Текущий аватар"],
            "book_lover": [.english: "Book Lover", .russian: "Любитель книг"],
            "member_since": [.english: "Member since", .russian: "Участник с"],
            
            // Reading Stats
            "your_reading_journey": [.english: "Your Reading Journey", .russian: "Ваше путешествие в чтении"],
            "finished_books": [.english: "Finished", .russian: "Прочитано"],
            
            // Progress
            "reading_progress": [.english: "Reading Progress", .russian: "Прогресс чтения"],
            "started_reading": [.english: "Started Reading", .russian: "Начал читать"],
            "days_reading": [.english: "Days Reading", .russian: "Дней чтения"],
            "quick_tip": [.english: "Quick Tip", .russian: "Быстрый совет"],
            "current_pace_tip": [.english: "At your current pace, you'll finish this book soon.", .russian: "При текущем темпе вы скоро закончите эту книгу."],
            
            // Form
            "enter_book_title": [.english: "Enter book title", .russian: "Введите название книги"],
            "author_name": [.english: "Author name", .russian: "Имя автора"],
            "select_genre": [.english: "Select genre", .russian: "Выберите жанр"],
            "start_date": [.english: "Start Date", .russian: "Дата начала"],
            "end_date": [.english: "End Date", .russian: "Дата окончания"],
            "add_thoughts_review": [.english: "Add your thoughts, quotes, or review...", .russian: "Добавьте свои мысли, цитаты или отзыв..."],
            
            // Empty State
            "no_books_yet": [.english: "No books yet", .russian: "Пока нет книг"],
            "start_reading": [.english: "Start your reading journey", .russian: "Начните своё путешествие в чтении"],
            "add_first_book": [.english: "Add your first book", .russian: "Добавьте первую книгу"]
        ]
        
        let result = strings[key]?[language] ?? key
        if result == key {
            print("⚠️ Missing localization for key: '\(key)' in language: \(language.rawValue)")
        }
        return result
    }
}

// MARK: - Common Strings
extension LocalizedStrings {
    static func library(_ language: AppLanguage = .english) -> String {
        localized("library", language: language)
    }
    
    static func statistics(_ language: AppLanguage = .english) -> String {
        localized("statistics", language: language)
    }
    
    static func profile(_ language: AppLanguage = .english) -> String {
        localized("profile", language: language)
    }
    
    static func addBook(_ language: AppLanguage = .english) -> String {
        localized("add_book", language: language)
    }
    
    static func save(_ language: AppLanguage = .english) -> String {
        localized("save", language: language)
    }
    
    static func cancel(_ language: AppLanguage = .english) -> String {
        localized("cancel", language: language)
    }
    
    static func delete(_ language: AppLanguage = .english) -> String {
        localized("delete", language: language)
    }
    
    static func edit(_ language: AppLanguage = .english) -> String {
        localized("edit", language: language)
    }
}

// MARK: - Book Status
extension LocalizedStrings {
    static func reading(_ language: AppLanguage = .english) -> String {
        localized("reading", language: language)
    }
    
    static func finished(_ language: AppLanguage = .english) -> String {
        localized("finished", language: language)
    }
    
    static func toRead(_ language: AppLanguage = .english) -> String {
        localized("to_read", language: language)
    }
    
    static func planning(_ language: AppLanguage = .english) -> String {
        localized("planning", language: language)
    }
}

// MARK: - Book Details
extension LocalizedStrings {
    static func title(_ language: AppLanguage = .english) -> String {
        localized("title", language: language)
    }
    
    static func author(_ language: AppLanguage = .english) -> String {
        localized("author", language: language)
    }
    
    static func totalPages(_ language: AppLanguage = .english) -> String {
        localized("total_pages", language: language)
    }
    
    static func currentPage(_ language: AppLanguage = .english) -> String {
        localized("current_page", language: language)
    }
    
    static func genre(_ language: AppLanguage = .english) -> String {
        localized("genre", language: language)
    }
    
    static func rating(_ language: AppLanguage = .english) -> String {
        localized("rating", language: language)
    }
    
    static func notes(_ language: AppLanguage = .english) -> String {
        localized("notes", language: language)
    }
    
    static func progress(_ language: AppLanguage = .english) -> String {
        localized("progress", language: language)
    }
}

// MARK: - Statistics
extension LocalizedStrings {
    static func booksRead(_ language: AppLanguage = .english) -> String {
        localized("books_read", language: language)
    }
    
    static func pagesRead(_ language: AppLanguage = .english) -> String {
        localized("pages_read", language: language)
    }
    
    static func averageRating(_ language: AppLanguage = .english) -> String {
        localized("average_rating", language: language)
    }
    
    static func readingGoals(_ language: AppLanguage = .english) -> String {
        localized("reading_goals", language: language)
    }
    
    static func achievements(_ language: AppLanguage = .english) -> String {
        localized("achievements", language: language)
    }
}

// MARK: - Settings
extension LocalizedStrings {
    static func settings(_ language: AppLanguage = .english) -> String {
        localized("settings", language: language)
    }
    
    static func language(_ language: AppLanguage = .english) -> String {
        localized("language", language: language)
    }
    
    static func theme(_ language: AppLanguage = .english) -> String {
        localized("theme", language: language)
    }
    
    static func textSize(_ language: AppLanguage = .english) -> String {
        localized("text_size", language: language)
    }
    
    static func darkMode(_ language: AppLanguage = .english) -> String {
        localized("dark_mode", language: language)
    }
    
    static func lightMode(_ language: AppLanguage = .english) -> String {
        localized("light_mode", language: language)
    }
    
    static func systemTheme(_ language: AppLanguage = .english) -> String {
        localized("system_theme", language: language)
    }
}

// MARK: - Actions
extension LocalizedStrings {
    static func markAsFinished(_ language: AppLanguage = .english) -> String {
        localized("mark_as_finished", language: language)
    }
    
    static func updateProgress(_ language: AppLanguage = .english) -> String {
        localized("update_progress", language: language)
    }
    
    static func addToFavorites(_ language: AppLanguage = .english) -> String {
        localized("add_to_favorites", language: language)
    }
    
    static func editProfile(_ language: AppLanguage = .english) -> String {
        localized("edit_profile", language: language)
    }
    
    static func deleteBook(_ language: AppLanguage = .english) -> String {
        localized("delete_book", language: language)
    }
    
    static func enterPage(_ language: AppLanguage = .english) -> String {
        localized("enter_page", language: language)
    }
    
    static func addNote(_ language: AppLanguage = .english) -> String {
        localized("add_note", language: language)
    }
    
    static func addNotePlaceholder(_ language: AppLanguage = .english) -> String {
        localized("add_note_placeholder", language: language)
    }
}

// MARK: - Profile
extension LocalizedStrings {
    static func displayName(_ language: AppLanguage = .english) -> String {
        localized("display_name", language: language)
    }
    
    static func enterName(_ language: AppLanguage = .english) -> String {
        localized("enter_name", language: language)
    }
    
    static func chooseAvatar(_ language: AppLanguage = .english) -> String {
        localized("choose_avatar", language: language)
    }
    
    static func currentAvatar(_ language: AppLanguage = .english) -> String {
        localized("current_avatar", language: language)
    }
    
    static func bookLover(_ language: AppLanguage = .english) -> String {
        localized("book_lover", language: language)
    }
    
    static func memberSince(_ language: AppLanguage = .english) -> String {
        localized("member_since", language: language)
    }
}

// MARK: - Reading Stats
extension LocalizedStrings {
    static func yourReadingJourney(_ language: AppLanguage = .english) -> String {
        localized("your_reading_journey", language: language)
    }
    
    static func finishedBooks(_ language: AppLanguage = .english) -> String {
        localized("finished", language: language)
    }
}

// MARK: - Progress
extension LocalizedStrings {
    static func readingProgress(_ language: AppLanguage = .english) -> String {
        localized("reading_progress", language: language)
    }
    
    static func startedReading(_ language: AppLanguage = .english) -> String {
        localized("started_reading", language: language)
    }
    
    static func daysReading(_ language: AppLanguage = .english) -> String {
        localized("days_reading", language: language)
    }
    
    static func quickTip(_ language: AppLanguage = .english) -> String {
        localized("quick_tip", language: language)
    }
    
    static func currentPaceTip(_ language: AppLanguage = .english) -> String {
        localized("current_pace_tip", language: language)
    }
}

// MARK: - Form
extension LocalizedStrings {
    static func enterBookTitle(_ language: AppLanguage = .english) -> String {
        localized("enter_book_title", language: language)
    }
    
    static func authorName(_ language: AppLanguage = .english) -> String {
        localized("author_name", language: language)
    }
    
    static func selectGenre(_ language: AppLanguage = .english) -> String {
        localized("select_genre", language: language)
    }
    
    static func startDate(_ language: AppLanguage = .english) -> String {
        localized("start_date", language: language)
    }
    
    static func endDate(_ language: AppLanguage = .english) -> String {
        localized("end_date", language: language)
    }
    
    static func addThoughtsReview(_ language: AppLanguage = .english) -> String {
        localized("add_thoughts_review", language: language)
    }
}

// MARK: - Empty State
extension LocalizedStrings {
    static func noBooksYet(_ language: AppLanguage = .english) -> String {
        localized("no_books_yet", language: language)
    }
    
    static func startReading(_ language: AppLanguage = .english) -> String {
        localized("start_reading", language: language)
    }
    
    static func addFirstBook(_ language: AppLanguage = .english) -> String {
        localized("add_first_book", language: language)
    }
}

// MARK: - Additional
extension LocalizedStrings {
    static func myLibrary(_ language: AppLanguage = .english) -> String {
        localized("my_library", language: language)
    }
    
    static func booksInCollection(_ language: AppLanguage = .english) -> String {
        localized("books_in_collection", language: language)
    }
    
    static func yourReadingOverview(_ language: AppLanguage = .english) -> String {
        localized("your_reading_overview", language: language)
    }
    
    static func chooseAppLanguage(_ language: AppLanguage = .english) -> String {
        localized("choose_app_language", language: language)
    }
    
    static func switchToDarkTheme(_ language: AppLanguage = .english) -> String {
        localized("switch_to_dark_theme", language: language)
    }
    
    static func adjustFontSize(_ language: AppLanguage = .english) -> String {
        localized("adjust_font_size", language: language)
    }
    
    static func preferences(_ language: AppLanguage = .english) -> String {
        localized("preferences", language: language)
    }
    
    static func readingStats(_ language: AppLanguage = .english) -> String {
        localized("reading_stats", language: language)
    }
    
    static func started(_ language: AppLanguage = .english) -> String {
        localized("started", language: language)
    }
    
    static func pages(_ language: AppLanguage = .english) -> String {
        localized("pages", language: language)
    }
    
    static func unknown(_ language: AppLanguage = .english) -> String {
        localized("unknown", language: language)
    }
}
