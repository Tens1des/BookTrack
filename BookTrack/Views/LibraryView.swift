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
            ZStack {
                LinearGradient(
                    colors: [
                        Color(.systemBackground),
                        Color(.systemGray6).opacity(0.2),
                        Color(.systemBackground).opacity(0.8)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                Group {
                    if store.books.isEmpty {
                        emptyState
                    } else {
                        ScrollView {
                            VStack(spacing: 16) {
                                headerChips
                                libraryStats
                                section(title: LocalizedStrings.reading(store.settings.language), count: reading.count, collapsed: $collapseReading) {
                                    ForEach(reading) { b in NavigationLink(value: b.id) { BookCard(book: b) } }
                                }
                                section(title: LocalizedStrings.finished(store.settings.language), count: finished.count, collapsed: $collapseFinished) {
                                    ForEach(finished) { b in NavigationLink(value: b.id) { BookCard(book: b) } }
                                }
                                section(title: LocalizedStrings.toRead(store.settings.language), count: planning.count, collapsed: $collapsePlanning) {
                                    ForEach(planning) { b in NavigationLink(value: b.id) { BookCard(book: b) } }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 80)
                        }
                        .overlay(alignment: .bottomTrailing) {
                            FloatingActionButton { showAdd = true }
                                .padding(20)
                        }
                    }
                }
            }
                    .navigationTitle(LocalizedStrings.library(store.settings.language))
            .navigationDestination(for: UUID.self) { id in BookDetailView(bookId: id) }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showAdd = true } label: { Image(systemName: "plus.circle.fill") }
                }
            }
        }
        .id(store.settings.language)
        .sheet(isPresented: $showAdd) { AddBookView() }
    }

    private var emptyState: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.accentColor.opacity(0.1), Color.accentColor.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: "book")
                    .font(.system(size: 48))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.accentColor, Color.accentColor.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(spacing: 8) {
                Text(LocalizedStrings.noBooksYet(store.settings.language))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Text(LocalizedStrings.startReading(store.settings.language))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            GradientButton(title: LocalizedStrings.addFirstBook(store.settings.language)) { showAdd = true }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 32)
    }
}

private extension LibraryView {
    var headerChips: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(LocalizedStrings.myLibrary(store.settings.language))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    Text("\(store.books.count) \(LocalizedStrings.booksInCollection(store.settings.language))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "books.vertical.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
            }
            
            HStack(spacing: 12) {
                statusChip(
                    count: reading.count,
                    label: LocalizedStrings.reading(store.settings.language),
                    gradient: [.blue, .cyan],
                    icon: "book.fill"
                )
                
                statusChip(
                    count: finished.count,
                    label: LocalizedStrings.finished(store.settings.language),
                    gradient: [.green, .mint],
                    icon: "checkmark.circle.fill"
                )
                
                statusChip(
                    count: planning.count,
                    label: LocalizedStrings.planning(store.settings.language),
                    gradient: [.purple, .indigo],
                    icon: "bookmark.fill"
                )
                
                Spacer()
                
                Button(action: {}) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.orange, .yellow],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "magnifyingglass")
                            .font(.title3)
                            .foregroundStyle(.white)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(.systemBackground),
                            Color(.systemGray6).opacity(0.3)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }

    var libraryStats: some View {
        Card {
            HStack(spacing: 20) {
                stat(number: String(store.books.filter { $0.status == .finished }.count), label: LocalizedStrings.finishedBooks(store.settings.language), gradient: [.green, .mint], icon: "checkmark.circle.fill")
                Divider().frame(height: 40)
                stat(number: String(store.totalReadPages), label: LocalizedStrings.pagesRead(store.settings.language), gradient: [.blue, .cyan], icon: "book.fill")
                Divider().frame(height: 40)
                stat(number: String(format: "%.1f", store.averageRating), label: LocalizedStrings.averageRating(store.settings.language), gradient: [.orange, .yellow], icon: "star.fill")
            }
        }
    }

    func stat(number: String, label: String, gradient: [Color], icon: String) -> some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundStyle(.white)
            }
            Text(number)
                .font(.headline).bold()
                .foregroundStyle(LinearGradient(colors: gradient, startPoint: .leading, endPoint: .trailing))
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    func statusChip(count: Int, label: String, gradient: [Color], icon: String) -> some View {
        HStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 24, height: 24)
                
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(.white)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("\(count)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            colors: gradient,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                Text(label)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.background.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            LinearGradient(
                                colors: gradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
    }

    func section<Content: View>(title: String, count: Int, collapsed: Binding<Bool>, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: getSectionGradient(for: title),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 30, height: 30)
                        
                        Image(systemName: getSectionIcon(for: title))
                            .font(.title3)
                            .foregroundStyle(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                        Text("\(count) books")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                Button { collapsed.wrappedValue.toggle() } label: {
                    ZStack {
                        Circle()
                            .fill(.gray.opacity(0.1))
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: collapsed.wrappedValue ? "chevron.down" : "chevron.up")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                    }
                }
            }
            
            if !collapsed.wrappedValue {
                VStack(spacing: 12, content: content)
            }
        }
    }
    
    private func getSectionGradient(for title: String) -> [Color] {
        switch title {
        case "Currently Reading":
            return [.blue, .cyan]
        case "Finished":
            return [.green, .mint]
        case "Want to Read":
            return [.purple, .indigo]
        default:
            return [.gray, .gray.opacity(0.7)]
        }
    }
    
    private func getSectionIcon(for title: String) -> String {
        switch title {
        case "Currently Reading":
            return "book.fill"
        case "Finished":
            return "checkmark.circle.fill"
        case "Want to Read":
            return "bookmark.fill"
        default:
            return "book"
        }
    }
}

            private struct BookCard: View {
                let book: Book
                @EnvironmentObject private var store: DataStore
                var body: some View {
        Card {
            HStack(alignment: .top, spacing: 16) {
                cover
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(book.title)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .lineLimit(2)
                        Spacer()
                        if book.isFavorite {
                            Image(systemName: "heart.fill")
                                .foregroundStyle(.pink)
                                .font(.title3)
                        }
                    }
                    
                                Text(book.author ?? LocalizedStrings.unknown(store.settings.language))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    
                    if let current = book.currentPage, let total = book.totalPages {
                        VStack(spacing: 6) {
                            HStack {
                                Text("\(current) / \(total) \(LocalizedStrings.pages(store.settings.language))")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("\(book.progressPercent)%")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.purple, .blue],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            }
                            LinearProgressBar(progress: Double(book.progressPercent) / 100.0)
                        }
                    }
                    
                    if let startDate = book.startDate {
                        Text("\(LocalizedStrings.started(store.settings.language)) \(startDate.formatted(date: .abbreviated, time: .omitted))")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    
                                HStack(spacing: 8) {
                                    switch book.status {
                                    case .reading:
                                        PillTag(text: LocalizedStrings.reading(store.settings.language), systemImage: "book.fill", color: .blue)
                                    case .finished:
                                        PillTag(text: LocalizedStrings.finished(store.settings.language), systemImage: "checkmark.circle.fill", color: .green)
                                    case .planning:
                                        PillTag(text: LocalizedStrings.toRead(store.settings.language), systemImage: "bookmark.fill", color: .purple)
                                    }
                        
                        if let genre = book.genre {
                            PillTag(text: genre, systemImage: nil, color: .gray)
                        }
                        
                        Spacer()
                        
                        if let rating = book.rating {
                            HStack(spacing: 2) {
                                ForEach(0..<rating, id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                        .font(.caption)
                                        .foregroundStyle(.yellow)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private var cover: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [.purple.opacity(0.9), .blue.opacity(0.8), .indigo.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.2), .clear],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1
                        )
                )
            
            Text(initials)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
        }
        .frame(width: 48, height: 64)
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
    }

    private var initials: String {
        let base = book.author ?? book.title
        let letters = base.split(separator: " ").compactMap { $0.first }
        return String(letters.prefix(2)).uppercased()
    }
}


