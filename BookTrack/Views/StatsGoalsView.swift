import SwiftUI

struct StatsGoalsView: View {
    @EnvironmentObject private var store: DataStore
    @State private var period: GoalPeriod = .year

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    header
                    goalCard
                    metricsGrid
                    genresBreakdown
                    recentlyFinished
                    Button("Set New Goal") { }
                        .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                }
                .padding(16)
            }
            .navigationTitle("Statistics")
        }
    }

    private func label(for p: GoalPeriod) -> String { switch p { case .week: return "Week"; case .month: return "Month"; case .year: return "Year" } }

    private func avgRating() -> String {
        let ratings = store.books.compactMap { $0.rating }
        guard !ratings.isEmpty else { return "–" }
        let avg = Double(ratings.reduce(0,+)) / Double(ratings.count)
        return String(format: "%.1f", avg)
    }

    private var header: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(height: 120)
            VStack(alignment: .leading) {
                Text("Statistics").font(.title).bold().foregroundStyle(.white)
                HStack {
                    segment("Week", .week)
                    segment("Month", .month)
                    segment("Year", .year)
                }
            }
            .padding(16)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func segment(_ title: String, _ value: GoalPeriod) -> some View {
        Button(action: { period = value }) {
            Text(title).padding(.vertical, 8).frame(maxWidth: .infinity)
        }
        .background(RoundedRectangle(cornerRadius: 10).fill(period == value ? Color.white.opacity(0.9) : .clear))
        .foregroundStyle(period == value ? .black : .white)
    }

    private var goalCard: some View {
        let goal = store.goals.first { $0.period == period } ?? store.goals.first
        return Card {
            Text("Reading Goal \(label(for: period))").font(.subheadline).bold().foregroundStyle(.secondary)
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("\(goal?.completedBooks ?? 0)").font(.system(size: 36, weight: .bold))
                Text("/ \(goal?.targetBooks ?? 0) books").font(.headline)
            }
            ProgressView(value: goal?.progress ?? 0)
            Text("\(max(0,(goal?.targetBooks ?? 0) - (goal?.completedBooks ?? 0))) more to reach your goal")
                .font(.caption).foregroundStyle(.secondary)
        }
    }

    private var metricsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            metric(icon: "book", title: "Pages Read", value: String(totalPagesRead()))
            metric(icon: "star.fill", title: "Avg Rating", value: avgRating())
            metric(icon: "heart", title: "Favorites", value: String(store.books.filter{ $0.isFavorite }.count))
            metric(icon: "chart.bar", title: "Pages/Book", value: String(avgPagesPerBook()))
        }
    }

    private func metric(icon: String, title: String, value: String) -> some View {
        Card { HStack(alignment: .top) { Image(systemName: icon); VStack(alignment: .leading) { Text(value).font(.title2).bold(); Text(title).font(.caption).foregroundStyle(.secondary) }; Spacer() } }
    }

    private func totalPagesRead() -> Int {
        store.books.reduce(0) { sum, b in sum + (b.status == .finished ? (b.totalPages ?? 0) : (b.currentPage ?? 0)) }
    }

    private func avgPagesPerBook() -> Int {
        let finished = store.books.filter { $0.status == .finished }
        guard !finished.isEmpty else { return 0 }
        let pages = finished.reduce(0) { $0 + ( $1.totalPages ?? 0 ) }
        return pages / finished.count
    }

    private var genresBreakdown: some View {
        let counts = Dictionary(grouping: store.books.compactMap{ $0.genre }) { $0 }
            .mapValues { $0.count }
            .sorted { $0.value > $1.value }
            .map { (key: $0.key, value: $0.value) }
        return Card {
            Text("Genres Breakdown").font(.subheadline).bold()
            ForEach(Array(counts.enumerated()), id: \.offset) { _, item in
                HStack { Text(item.key); Spacer(); Text("\(item.value) books").foregroundStyle(.secondary); }
                GeometryReader { proxy in
                    RoundedRectangle(cornerRadius: 3).fill(Color.gray.opacity(0.2))
                        .frame(height: 6)
                        .overlay(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3).fill(Color.accentColor)
                                .frame(width: proxy.size.width * CGFloat(Double(item.value) / Double(max(1, counts.first?.value ?? 1))))
                        }
                }
                .frame(height: 6)
            }
        }
    }

    private var recentlyFinished: some View {
        let items = store.books.filter{ $0.status == .finished }.prefix(3)
        return Card {
            Text("Recently Finished").font(.subheadline).bold()
            ForEach(items) { b in
                HStack {
                    RoundedRectangle(cornerRadius: 10).fill(LinearGradient(colors: [.purple, .blue], startPoint: .top, endPoint: .bottom)).frame(width: 38, height: 50)
                    VStack(alignment: .leading) { Text(b.title).font(.subheadline).bold(); Text(b.author ?? "").font(.caption).foregroundStyle(.secondary) }
                    Spacer()
                    HStack(spacing: 2) { ForEach(0..<(b.rating ?? 0), id: \.self) { _ in Image(systemName: "star.fill").foregroundStyle(.yellow) } }
                }
            }
        }
    }
}



