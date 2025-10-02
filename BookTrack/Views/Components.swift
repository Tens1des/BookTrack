import SwiftUI

struct PillTag: View {
    let text: String
    let systemImage: String?
    let color: Color
    var body: some View {
        HStack(spacing: 4) {
            if let systemImage { Image(systemName: systemImage) }
            Text(text)
        }
        .font(.caption2)
        .foregroundStyle(color)
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(color.opacity(0.12))
        .clipShape(Capsule())
    }
}

struct LinearProgressBar: View {
    let progress: Double // 0...1
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 3).fill(Color.gray.opacity(0.2))
            RoundedRectangle(cornerRadius: 3).fill(Color.accentColor)
                .frame(width: max(0, min(1, progress)) * 1)
                .modifier(WidthReader(progress: progress))
        }
        .frame(height: 6)
    }
}

private struct WidthReader: ViewModifier {
    let progress: Double
    func body(content: Content) -> some View {
        GeometryReader { proxy in
            content.frame(width: proxy.size.width * progress)
        }
    }
}

struct Card<Content: View>: View {
    @ViewBuilder var content: () -> Content
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: content)
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 14).fill(.background.opacity(0.6)))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.gray.opacity(0.12)))
    }
}

struct FieldLabel: View {
    let text: String
    var required: Bool = false
    var body: some View {
        HStack(spacing: 4) {
            Text(text).font(.subheadline).bold()
            if required { Text("*").foregroundStyle(.pink) }
            Spacer()
        }
    }
}

struct InputContainer<Content: View>: View {
    var content: () -> Content
    var body: some View {
        HStack { content() }
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .background(RoundedRectangle(cornerRadius: 12).fill(.background))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2)))
    }
}

struct StatusPill: View {
    let title: String
    let icon: String
    let isSelected: Bool
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
            Text(title)
        }
        .font(.subheadline)
        .foregroundStyle(isSelected ? .white : .primary)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(isSelected ? Color.primary.opacity(0.9) : Color.gray.opacity(0.12))
        )
    }
}


