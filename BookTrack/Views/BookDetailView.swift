import SwiftUI

struct BookDetailView: View {
    @EnvironmentObject private var store: DataStore
    let bookId: UUID
    @State private var progressInput: String = ""
    @State private var noteInput: String = ""

    private var book: Book? { store.books.first { $0.id == bookId } }

    var body: some View {
        VStack(spacing: 0) {
            if let book { header(book) }
            ScrollView {
                VStack(spacing: 16) {
                    if let book { progressCard(book) }
                    if let book { statsCard(book) }
                    notesCard
                    tipCard
                    footerActions
                }
                .padding(16)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func header(_ book: Book) -> some View {
        ZStack(alignment: .topTrailing) {
            LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(height: 170)
                .overlay(alignment: .leading) {
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white.opacity(0.2))
                            .frame(width: 56, height: 74)
                            .overlay(Text(initials(book)).foregroundStyle(.white).bold())
                        VStack(alignment: .leading, spacing: 6) {
                            Text(book.title).font(.title2).bold().foregroundStyle(.white)
                            Text(book.author ?? "Unknown").foregroundStyle(.white.opacity(0.9))
                            HStack(spacing: 8) {
                                PillTag(text: book.genre ?? "Fiction", systemImage: nil, color: .white)
                                PillTag(text: statusText(book.status), systemImage: nil, color: .white)
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                }
            HStack(spacing: 16) {
                Button(action: {}) { Image(systemName: "heart").foregroundStyle(.white) }
                Button(action: {}) { Image(systemName: "pencil").foregroundStyle(.white) }
            }
            .padding(16)
        }
    }

    private func progressCard(_ book: Book) -> some View {
        Card {
            HStack {
                VStack(alignment: .leading) { 
                    Text("Current Page").font(.caption).foregroundStyle(.secondary)
                    Text("\(book.currentPage ?? 0)").font(.title3).bold() 
                }
                Spacer()
                VStack(alignment: .trailing) { 
                    Text("Total Pages").font(.caption).foregroundStyle(.secondary)
                    Text("\(book.totalPages ?? 0)").font(.title3).bold() 
                }
            }
            HStack {
                TextField("Enter page", text: $progressInput).keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                Button("Update Progress") {
                    if let p = Int(progressInput) { store.setProgress(bookId: book.id, currentPage: p); progressInput = "" }
                }
                .buttonStyle(.plain)
                .padding(.vertical, 12)
                .padding(.horizontal, 24)
                .background(
                    LinearGradient(
                        colors: [.purple, .blue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .foregroundStyle(.white)
                .fontWeight(.semibold)
                .clipShape(Capsule())
                .shadow(color: .purple.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
    }

    private func statsCard(_ book: Book) -> some View {
        Card {
            Text("Reading Stats").font(.subheadline).bold()
            HStack { Image(systemName: "calendar"); VStack(alignment: .leading) { Text("Started Reading").font(.caption).foregroundStyle(.secondary); Text(book.startDate?.formatted(date: .abbreviated, time: .omitted) ?? "—") } ; Spacer() }
            HStack { Image(systemName: "clock"); VStack(alignment: .leading) { Text("Days Reading").font(.caption).foregroundStyle(.secondary); Text(daysReading(book)) } ; Spacer() }
        }
    }

    private var notesCard: some View {
        Card {
            HStack { Text("Notes & Thoughts").font(.subheadline).bold(); Spacer(); }
            VStack(alignment: .leading, spacing: 8) {
                ForEach(book?.notes ?? []) { n in Text(n.text).font(.subheadline) }
                HStack {
                    TextField("Add a note...", text: $noteInput).textFieldStyle(.roundedBorder)
                    Button("Add") { addNote() }
                        .buttonStyle(.bordered)
                }
            }
        }
    }

    private var tipCard: some View {
        Card { HStack { Image(systemName: "lightbulb"); Text("Quick Tip").bold(); Spacer() }; Text("At your current pace, you'll finish this book soon.").font(.footnote).foregroundStyle(.secondary) }
    }

    private var footerActions: some View {
        HStack {
            Button("Mark as Finished") { if let id = book?.id { store.finishBook(bookId: id, rating: nil) } }
                .buttonStyle(.bordered)
            Spacer()
            Button("Delete Book", role: .destructive) { if let id = book?.id { store.deleteBooks(ids: [id]) } }
                .buttonStyle(.bordered)
        }
    }

    private func addNote() {
        guard let id = book?.id, !noteInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        store.addNote(noteInput, to: id)
        noteInput = ""
    }

    private func initials(_ book: Book) -> String {
        let base = book.author ?? book.title
        let letters = base.split(separator: " ").compactMap { $0.first }
        return String(letters.prefix(2)).uppercased()
    }

    private func statusText(_ s: ReadingStatus) -> String { switch s { case .reading: return "Reading"; case .finished: return "Finished"; case .planning: return "To Read" } }

    private func daysReading(_ book: Book) -> String {
        guard let start = book.startDate else { return "—" }
        let days = Calendar.current.dateComponents([.day], from: start, to: Date()).day ?? 0
        return "\(days) days"
    }
}


