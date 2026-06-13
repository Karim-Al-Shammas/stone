import SwiftUI

/// A wrapping HStack that flows children onto new lines as needed (iOS 16 Layout).
struct FlexibleWrap: Layout {
    var spacing: CGFloat = 6
    var lineSpacing: CGFloat = 6

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var rows = layout(subviews: subviews, maxWidth: maxWidth)
        let height = rows.last.map { $0.y + $0.rowHeight } ?? 0
        rows.removeAll()
        return CGSize(width: proposal.width ?? 0, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = layout(subviews: subviews, maxWidth: bounds.width)
        for item in rows {
            let pt = CGPoint(x: bounds.minX + item.x, y: bounds.minY + item.y)
            subviews[item.index].place(at: pt, anchor: .topLeading, proposal: ProposedViewSize(item.size))
        }
    }

    private struct Item {
        let index: Int
        let x: CGFloat
        let y: CGFloat
        let size: CGSize
        let rowHeight: CGFloat
    }

    private func layout(subviews: Subviews, maxWidth: CGFloat) -> [Item] {
        var items: [Item] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        for (i, sub) in subviews.enumerated() {
            let size = sub.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + lineSpacing
                rowHeight = 0
            }
            items.append(Item(index: i, x: x, y: y, size: size, rowHeight: rowHeight))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        // Patch rowHeight for items on the final row so height calc is correct.
        return items.map { Item(index: $0.index, x: $0.x, y: $0.y, size: $0.size, rowHeight: rowHeight) }
    }
}

/// Pill filter chip used by Exercises, Progress, and the picker.
struct FilterChip: View {
    let title: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(isActive ? .white : Color(hex: 0x555555))
                .padding(.vertical, 6)
                .padding(.horizontal, 14)
                .background(isActive ? Theme.blue : Theme.card)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(isActive ? Theme.blue : Color(hex: 0xE0E0E0), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

/// Horizontal scroller of muscle-group chips with a leading "All" option.
struct MuscleFilterRow: View {
    @Binding var selected: String?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                FilterChip(title: "All", isActive: selected == nil) { selected = nil }
                ForEach(Exercise.muscleGroups, id: \.self) { m in
                    FilterChip(title: m, isActive: selected == m) { selected = m }
                }
            }
        }
    }
}

/// Rounded search field matching the web app's look.
struct SearchField: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass").foregroundStyle(Theme.sub)
            TextField(placeholder, text: $text)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(Theme.inputBg)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
