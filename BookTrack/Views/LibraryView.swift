import SwiftUI

struct LibraryView: View {
    @EnvironmentObject private var store: DataStore
    @State private var showAdd = false

    private var reading: [Book] { store.books.filter { $0.status == .reading } }
    private var finished: [Book] { store.books.filter { $0.status == .finished } }
    private var planning: [Book] { store.books.filter { $0.status == .planning } }
    @State private var collapseReading = false
    @State private var collapseFinished = false
    @State private var collapsePlanning = false

    var body: some View {
        NavigationStack {
            Group {
                if store.books.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            headerChips
                            section(title: "Currently Reading", count: reading.count, collapsed: $collapseReading) {
                                ForEach(reading) { b in NavigationLink(value: b.id) { BookCard(book: b) } }
                            }
                            section(title: "Finished", count: finished.count, collapsed: $collapseFinished) {
                                ForEach(finished) { b in NavigationLink(value: b.id) { BookCard(book: b) } }
                            }
                            section(title: "Want to Read", count: planning.count, collapsed: $collapsePlanning) {
                                ForEach(planning) { b in NavigationLink(value: b.id) { BookCard(book: b) } }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 80)
                    }
                    .overlay(alignment: .bottomTrailing) {
                        Button { showAdd = true } label: {
                            Image(systemName: "plus")
                                .font(.title2).bold()
                                .foregroundStyle(.white)
                                .padding(20)
                                .background(Circle().fill(Color.accentColor))
                                .shadow(radius: 6, y: 3)
                        }
                        .padding(20)
                    }
                }
            }
            .navigationTitle("Library")
            .navigationDestination(for: UUID.self) { id in BookDetailView(bookId: id) }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showAdd = true } label: { Image(systemName: "plus.circle.fill") }
                }
            }
        }
        .sheet(isPresented: $showAdd) { AddBookView() }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "book")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("It’s empty — add your first book")
                .font(.headline)
                .foregroundStyle(.secondary)
            Button("Add Book") { showAdd = true }
                .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private extension LibraryView {
    var headerChips: some View {
        HStack(spacing: 12) {
            Label("\(reading.count) reading", systemImage: "circle.fill").foregroundStyle(.blue)
                .font(.caption)
            Label("\(finished.count) finished", systemImage: "circle.fill").foregroundStyle(.green)
                .font(.caption)
            Label("\(planning.count) planning", systemImage: "circle.fill").foregroundStyle(.purple)
                .font(.caption)
            Spacer()
            Image(systemName: "magnifyingglass")
        }
        .foregroundStyle(.secondary)
    }

    func section<Content: View>(title: String, count: Int, collapsed: Binding<Bool>, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Button { collapsed.wrappedValue.toggle() } label: {
                    Image(systemName: collapsed.wrappedValue ? "chevron.right" : "chevron.down")
                }
                Text(title).font(.headline)
                Text("\(count)").foregroundStyle(.secondary)
                Spacer()
                Image(systemName: "books.vertical")
            }
            if !collapsed.wrappedValue {
                VStack(spacing: 12, content: content)
            }
        }
    }
}

private struct BookCard: View {
    let book: Book
    var body: some View {
        Card {
            HStack(alignment: .top) {
                cover
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(book.title).font(.headline)
                        Spacer()
                        if book.isFavorite { Image(systemName: "heart.fill").foregroundStyle(.pink) }
                    }
                    Text(book.author ?? "Unknown").font(.subheadline).foregroundStyle(.secondary)
                    if let current = book.currentPage, let total = book.totalPages, book.status != .finished {
                        HStack {
                            Text("\(current) / \(total) pages").font(.caption).foregroundStyle(.secondary)
                            Spacer()
                            Text("\(book.progressPercent)%").font(.caption).foregroundStyle(.secondary)
                        }
                        LinearProgressBar(progress: Double(book.progressPercent) / 100.0)
                            .frame(maxWidth: .infinity)
                    }
                    HStack(spacing: 8) {
                        switch book.status {
                        case .reading:
                            PillTag(text: "Reading", systemImage: "book", color: .blue)
                        case .finished:
                            PillTag(text: "Finished", systemImage: "checkmark", color: .green)
                        case .planning:
                            PillTag(text: "To Read", systemImage: "bookmark", color: .purple)
                        }
                        if let genre = book.genre { Text(genre).font(.caption).foregroundStyle(.secondary) }
                    }
                }
            }
        }
    }

    private var cover: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12).fill(LinearGradient(colors: [.purple.opacity(0.9), .blue.opacity(0.8)], startPoint: .top, endPoint: .bottom))
            Text(initials)
                .font(.caption).bold().foregroundStyle(.white.opacity(0.9))
        }
        .frame(width: 48, height: 64)
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }

    private var initials: String {
        let base = book.author ?? book.title
        let letters = base.split(separator: " ").compactMap { $0.first }
        return String(letters.prefix(2)).uppercased()
    }
}


