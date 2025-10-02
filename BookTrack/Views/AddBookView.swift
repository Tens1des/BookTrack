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
                    FieldLabel(text: "Title", required: true)
                    InputContainer { TextField("Enter book title", text: $title) }

                    // Author
                    FieldLabel(text: "Author")
                    InputContainer { TextField("Author name", text: $author) }

                    // Status
                    FieldLabel(text: "Status", required: true)
                    HStack(spacing: 12) {
                        Button { status = .planning } label: {
                            StatusPill(title: "To Read", icon: "bookmark.fill", isSelected: status == .planning)
                        }
                        Button { status = .reading } label: {
                            StatusPill(title: "Reading", icon: "book", isSelected: status == .reading)
                        }
                        Button { status = .finished } label: {
                            StatusPill(title: "Done", icon: "checkmark", isSelected: status == .finished)
                        }
                    }

                    // Total pages
                    FieldLabel(text: "Total Pages")
                    InputContainer {
                        TextField("350", text: $totalPages).keyboardType(.numberPad)
                    }

                    // Genre
                    FieldLabel(text: "Genre")
                    InputContainer { TextField("Select genre", text: $genre) }

                    // Dates & Progress
                    if status == .reading || status == .finished {
                        FieldLabel(text: "Start Date")
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
                            FieldLabel(text: "End Date")
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
                        FieldLabel(text: "Current Page")
                        InputContainer {
                            TextField("120", text: $currentPage).keyboardType(.numberPad)
                        }
                    }

                    // Rating
                    if status == .finished {
                        FieldLabel(text: "Rating")
                        InputContainer {
                            Stepper(value: $rating, in: 0...10) { Text("Rating: \(rating)") }
                        }
                    }

                    // Notes
                    FieldLabel(text: "Notes / Review")
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Add your thoughts, quotes, or review...", text: $note, axis: .vertical)
                            .lineLimit(5, reservesSpace: true)
                            .padding(12)
                            .background(RoundedRectangle(cornerRadius: 12).fill(.background))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2)))
                        InputContainer { Toggle("Add to Favorites", isOn: $isFavorite) }
                    }

                    if let error { Text(error).font(.footnote).foregroundStyle(.red) }
                }
                .padding(16)
            }
            .navigationTitle("Add Book")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { 
                    Button(action: { dismiss() }) { 
                        Image(systemName: "xmark")
                            .foregroundStyle(.secondary)
                    } 
                }
                ToolbarItem(placement: .topBarTrailing) { 
                    GradientButton(title: "Save", action: save)
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


