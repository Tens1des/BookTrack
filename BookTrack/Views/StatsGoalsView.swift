import SwiftUI

struct StatsGoalsView: View {
    @EnvironmentObject private var store: DataStore
    @State private var period: GoalPeriod = .year

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(.systemBackground),
                        Color(.systemGray6).opacity(0.15),
                        Color(.systemBackground).opacity(0.9)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        header
                        goalCard
                        metricsGrid
                        genresBreakdown
                        recentlyFinished
                        GradientButton(title: "Set New Goal") { }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 8)
                    }
                    .padding(16)
                }
            }
                    .navigationTitle(LocalizedStrings.statistics(store.settings.language))
        }
        .id(store.settings.language)
    }

    private func label(for p: GoalPeriod) -> String { switch p { case .week: return "Week"; case .month: return "Month"; case .year: return "Year" } }

    private func avgRating() -> String {
        let ratings = store.books.compactMap { $0.rating }
        guard !ratings.isEmpty else { return "–" }
        let avg = Double(ratings.reduce(0,+)) / Double(ratings.count)
        return String(format: "%.1f", avg)
    }

    private var header: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Reading Analytics")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    Text("Track your progress and achievements")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.purple, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "chart.bar.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
            }
            
            HStack(spacing: 12) {
                ForEach([GoalPeriod.week, .month, .year], id: \.self) { p in
                    Button(action: { period = p }) {
                        Text(label(for: p))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(period == p ? 
                                        LinearGradient(
                                            colors: [.purple, .blue],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ) : 
                                        LinearGradient(
                                            colors: [.gray.opacity(0.1), .gray.opacity(0.05)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                            .foregroundStyle(period == p ? .white : .primary)
                            .shadow(
                                color: period == p ? .purple.opacity(0.3) : .clear,
                                radius: period == p ? 8 : 0,
                                x: 0,
                                y: period == p ? 4 : 0
                            )
                    }
                    .buttonStyle(.plain)
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
            VStack(spacing: 16) {
                HStack {
                    HStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.green, .mint],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "target")
                                .font(.title3)
                                .foregroundStyle(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Reading Goal \(label(for: period))")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)
                            Text("Track your progress")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                }
                
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text("\(goal?.completedBooks ?? 0)")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.green, .mint],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    Text("/ \(goal?.targetBooks ?? 0) books")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                }
                
                VStack(spacing: 8) {
                    LinearProgressBar(progress: goal?.progress ?? 0)
                    
                    HStack {
                        Text("\(max(0,(goal?.targetBooks ?? 0) - (goal?.completedBooks ?? 0))) more to reach your goal")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("\(Int((goal?.progress ?? 0) * 100))%")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.green)
                    }
                }
            }
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
        Card {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: getMetricGradient(for: icon),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundStyle(.white)
                }
                
                VStack(spacing: 4) {
                    Text(value)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: getMetricGradient(for: icon),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text(title)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
    
    private func getMetricGradient(for icon: String) -> [Color] {
        switch icon {
        case "book":
            return [.blue, .cyan]
        case "star.fill":
            return [.orange, .yellow]
        case "heart":
            return [.pink, .red]
        case "chart.bar":
            return [.purple, .indigo]
        default:
            return [.gray, .gray.opacity(0.7)]
        }
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
            VStack(spacing: 16) {
                HStack {
                    HStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.purple, .indigo],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 30, height: 30)
                            
                            Image(systemName: "chart.pie.fill")
                                .font(.title3)
                                .foregroundStyle(.white)
                        }
                        
                        Text("Genres Breakdown")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    Spacer()
                }
                
                VStack(spacing: 12) {
                    ForEach(Array(counts.enumerated()), id: \.offset) { index, item in
                        VStack(spacing: 8) {
                            HStack {
                                Text(item.key)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Spacer()
                                Text("\(item.value) books")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.secondary)
                            }
                            
                            GeometryReader { proxy in
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.gray.opacity(0.15))
                                    .frame(height: 8)
                                    .overlay(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(
                                                LinearGradient(
                                                    colors: getGenreGradient(for: index),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .frame(width: proxy.size.width * CGFloat(Double(item.value) / Double(max(1, counts.first?.value ?? 1))))
                                    }
                            }
                            .frame(height: 8)
                        }
                    }
                }
            }
        }
    }
    
    private func getGenreGradient(for index: Int) -> [Color] {
        let gradients: [[Color]] = [
            [.blue, .cyan],
            [.green, .mint],
            [.orange, .yellow],
            [.pink, .red],
            [.purple, .indigo]
        ]
        return gradients[index % gradients.count]
    }

    private var recentlyFinished: some View {
        let items = store.books.filter{ $0.status == .finished }.prefix(3)
        return Card {
            VStack(spacing: 16) {
                HStack {
                    HStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.orange, .yellow],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 30, height: 30)
                            
                            Image(systemName: "star.fill")
                                .font(.title3)
                                .foregroundStyle(.white)
                        }
                        
                        Text("Recently Finished")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    Spacer()
                }
                
                VStack(spacing: 12) {
                    ForEach(items) { b in
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        LinearGradient(
                                            colors: [.purple, .blue, .indigo],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 45, height: 60)
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
                                
                                Text(getBookInitials(b.title))
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(b.title)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .lineLimit(2)
                                
                                Text(b.author ?? "")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                            
                            VStack(spacing: 4) {
                                HStack(spacing: 2) {
                                    ForEach(0..<(b.rating ?? 0), id: \.self) { _ in
                                        Image(systemName: "star.fill")
                                            .font(.caption)
                                            .foregroundStyle(.yellow)
                                    }
                                }
                                
                                Text("\(b.rating ?? 0)/10")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
    }
    
    private func getBookInitials(_ title: String) -> String {
        let words = title.split(separator: " ")
        let initials = words.compactMap { $0.first }
        return String(initials.prefix(2)).uppercased()
    }
}



