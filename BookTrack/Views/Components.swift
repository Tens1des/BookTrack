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
        .fontWeight(.medium)
        .foregroundStyle(color)
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
        .background(
            Capsule()
                .fill(color.opacity(0.15))
                .overlay(
                    Capsule()
                        .stroke(color.opacity(0.3), lineWidth: 0.5)
                )
        )
        .shadow(color: color.opacity(0.2), radius: 2, x: 0, y: 1)
    }
}

struct LinearProgressBar: View {
    let progress: Double // 0...1
    var body: some View {
        ZStack(alignment: .leading) {
            // Background track
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(0.1))
                .frame(height: 6)
            
            // Progress fill with gradient
            RoundedRectangle(cornerRadius: 4)
                .fill(
                    LinearGradient(
                        colors: [.purple.opacity(0.8), .blue.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .modifier(WidthReader(progress: progress))
                .animation(.easeInOut(duration: 0.3), value: progress)
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
        VStack(alignment: .leading, spacing: 12, content: content)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.background)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
}

struct GradientButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(.vertical, 12)
                .padding(.horizontal, 24)
                .background(
                    LinearGradient(
                        colors: [Color.accentColor, Color.accentColor.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Capsule())
                .shadow(color: Color.accentColor.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

struct FloatingActionButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.accentColor, Color.accentColor.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: Color.accentColor.opacity(0.4), radius: 12, x: 0, y: 6)
                )
        }
        .buttonStyle(.plain)
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
    
    private var iconColor: Color {
        if !isSelected { return .gray }
        switch title {
        case "To Read": return .purple
        case "Reading": return .blue
        case "Done": return .green
        default: return .primary
        }
    }
    
    private var backgroundColor: Color {
        if !isSelected { return Color.gray.opacity(0.12) }
        switch title {
        case "To Read": return .purple.opacity(0.1)
        case "Reading": return .blue.opacity(0.1)
        case "Done": return .green.opacity(0.1)
        default: return Color.primary.opacity(0.1)
        }
    }
    
    private var borderColor: Color {
        if !isSelected { return .clear }
        switch title {
        case "To Read": return .purple
        case "Reading": return .blue
        case "Done": return .green
        default: return .primary
        }
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(iconColor)
            Text(title)
                .foregroundStyle(isSelected ? iconColor : .primary)
        }
        .font(.subheadline)
        .fontWeight(isSelected ? .semibold : .regular)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(backgroundColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(borderColor, lineWidth: isSelected ? 2 : 0)
        )
    }
}


