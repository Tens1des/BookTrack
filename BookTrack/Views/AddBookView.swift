import SwiftUI

struct AddBookView: View {
    @EnvironmentObject private var store: DataStore
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var author: String = ""
    @State private var totalPages: String = ""
    @State private var genre: String = ""
    @State private var status: ReadingStatus = .planning
    @State private var startDate: Date? = nil
    @State private var endDate: Date? = nil
    @State private var currentPage: String = ""
    @State private var rating: Int = 0
    @State private var isFavorite: Bool = false
    @State private var note: String = ""

    @State private var error: String? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    // Title
                    FieldLabel(text: LocalizedStrings.title(store.settings.language), required: true)
                    InputContainer { TextField(LocalizedStrings.enterBookTitle(store.settings.language), text: $title) }

                    // Author
                    FieldLabel(text: LocalizedStrings.author(store.settings.language))
                    InputContainer { TextField(LocalizedStrings.authorName(store.settings.language), text: $author) }

                    // Status
                    FieldLabel(text: LocalizedStrings.progress(store.settings.language), required: true)
                    HStack(spacing: 12) {
                        Button { status = .planning } label: {
                            StatusPill(title: LocalizedStrings.toRead(store.settings.language), icon: "bookmark.fill", isSelected: status == .planning)
                        }
                        Button { status = .reading } label: {
                            StatusPill(title: LocalizedStrings.reading(store.settings.language), icon: "book.fill", isSelected: status == .reading)
                        }
                        Button { status = .finished } label: {
                            StatusPill(title: LocalizedStrings.finished(store.settings.language), icon: "checkmark.circle.fill", isSelected: status == .finished)
                        }
                    }

                    // Total pages
                    FieldLabel(text: LocalizedStrings.totalPages(store.settings.language))
                    InputContainer {
                        TextField("350", text: $totalPages).keyboardType(.numberPad)
                    }

                    // Genre
                    FieldLabel(text: LocalizedStrings.genre(store.settings.language))
                    InputContainer { TextField(LocalizedStrings.selectGenre(store.settings.language), text: $genre) }

                    // Dates & Progress
                    if status == .reading || status == .finished {
                        FieldLabel(text: LocalizedStrings.startDate(store.settings.language))
                        InputContainer {
                            DatePicker(
                                "",
                                selection: Binding<Date>(
                                    get: { startDate ?? Date() },
                                    set: { startDate = $0 }
                                ), displayedComponents: .date
                            ).labelsHidden()
                        }
                        if status == .finished {
                            FieldLabel(text: LocalizedStrings.endDate(store.settings.language))
                            InputContainer {
                                DatePicker(
                                    "",
                                    selection: Binding<Date>(
                                        get: { endDate ?? Date() },
                                        set: { endDate = $0 }
                                    ), displayedComponents: .date
                                ).labelsHidden()
                            }
                        }
                        FieldLabel(text: LocalizedStrings.currentPage(store.settings.language))
                        InputContainer {
                            TextField("120", text: $currentPage).keyboardType(.numberPad)
                        }
                    }

                    // Rating
                    if status == .finished {
                        FieldLabel(text: LocalizedStrings.rating(store.settings.language))
                        InputContainer {
                            Stepper(value: $rating, in: 0...10) { Text("Rating: \(rating)") }
                        }
                    }

                    // Notes
                    FieldLabel(text: LocalizedStrings.notes(store.settings.language))
                    VStack(alignment: .leading, spacing: 8) {
                        TextField(LocalizedStrings.addThoughtsReview(store.settings.language), text: $note, axis: .vertical)
                            .lineLimit(5, reservesSpace: true)
                            .padding(12)
                            .background(RoundedRectangle(cornerRadius: 12).fill(.background))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2)))
                        InputContainer { Toggle(LocalizedStrings.addToFavorites(store.settings.language), isOn: $isFavorite) }
                    }

                    if let error { Text(error).font(.footnote).foregroundStyle(.red) }
                }
                .padding(16)
            }
            .navigationTitle(LocalizedStrings.addBook(store.settings.language))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { 
                    Button(action: { dismiss() }) { 
                        Image(systemName: "xmark")
                            .foregroundStyle(.secondary)
                    } 
                }
                ToolbarItem(placement: .topBarTrailing) { 
                    GradientButton(title: LocalizedStrings.save(store.settings.language), action: save)
                }
            }
        }
    }

    private func save() {
        error = nil
        let total = Int(totalPages)
        let current = Int(currentPage)
        if let t = total, let c = current, c > t { error = "Current page cannot exceed total"; return }
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { error = "Title is required"; return }

        var book = Book(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            author: author.isEmpty ? nil : author,
            totalPages: total,
            genre: genre.isEmpty ? nil : genre,
            status: status,
            startDate: startDate,
            endDate: endDate,
            currentPage: current,
            rating: status == .finished && rating > 0 ? rating : nil,
            isFavorite: isFavorite,
            notes: []
        )
        if !note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            book.notes = [Note(text: note)]
        }
        store.addBook(book)
        dismiss()
    }
}


