import SwiftUI

enum Tab: Hashable { case home, workouts, progress, library }

/// Centered screen header: spire crown + Cinzel title + mono sub-kicker.
struct DecoHeader: View {
    let title: String
    var sub: String?

    var body: some View {
        VStack(spacing: 0) {
            Spire().frame(width: 180, height: 44)
            Text(title)
                .font(.display(32))
                .tracking(6)
                .foregroundStyle(Deco.ink)
                .padding(.top, 4)
            if let sub {
                Text(sub.uppercased())
                    .font(.mono(10))
                    .tracking(4)
                    .foregroundStyle(Deco.brassDeep)
                    .padding(.top, 2)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .overlay(alignment: .bottom) { Rectangle().fill(Deco.line).frame(height: 1) }
    }
}

/// Mono kicker label (uppercase, letter-spaced).
struct Kicker: View {
    let text: String
    var color: Color = Deco.brassDeep
    var size: CGFloat = 9
    var tracking: CGFloat = 3
    var body: some View {
        Text(text.uppercased())
            .font(.mono(size))
            .tracking(tracking)
            .foregroundStyle(color)
    }
}

/// Section heading: kicker + diamond + Cinzel title + rule.
struct SectionTitle: View {
    let title: String
    var kicker: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let kicker { Kicker(text: kicker, size: 10) }
            HStack(spacing: 10) {
                DiamondDot()
                Text(title)
                    .font(.display(22))
                    .tracking(1.5)
                    .foregroundStyle(Deco.ink)
                Rectangle().fill(Deco.line).frame(height: 1)
            }
        }
        .padding(.top, 22)
    }
}

/// Square paper card border.
struct DecoCard: ViewModifier {
    var border: Color = Deco.line
    func body(content: Content) -> some View {
        content
            .background(Deco.paper)
            .overlay(Rectangle().stroke(border, lineWidth: 1))
    }
}

extension View {
    func decoCard(border: Color = Deco.line) -> some View { modifier(DecoCard(border: border)) }
}

/// Read-only deco search field look (matches the prototype's static field).
struct DecoSearchField: View {
    var placeholder: String
    @Binding var text: String
    var fill: Color = Deco.paper

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass").foregroundStyle(Deco.brass).font(.system(size: 14))
            TextField("", text: $text, prompt: Text(placeholder).foregroundColor(Deco.inkSoft))
                .font(.bodyText(13))
                .foregroundStyle(Deco.ink)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(fill)
        .overlay(Rectangle().stroke(Deco.line, lineWidth: 1))
    }
}

/// Horizontal muscle-group filter chips (square, ink-active).
struct MuscleChips: View {
    @Binding var selected: String?
    private let all = ["All"] + Exercise.muscleGroups

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(all, id: \.self) { m in
                    let isAll = m == "All"
                    let active = isAll ? selected == nil : selected == m
                    Text(m.uppercased())
                        .font(.mono(10))
                        .tracking(2)
                        .foregroundStyle(active ? Deco.cream : Deco.inkSoft)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(active ? Deco.ink : Deco.paper)
                        .overlay(Rectangle().stroke(active ? Deco.brass : Deco.line, lineWidth: 1))
                        .onTapGesture { selected = isAll ? nil : m }
                }
            }
            .padding(.bottom, 4)
        }
    }
}

/// Ink bottom tab bar with deco glyphs (Home / Forge / Charts / Library).
struct ChryslerTabBar: View {
    @Binding var selected: Tab

    private let tabs: [(Tab, String, String)] = [
        (.home, "Home", "◆"),
        (.workouts, "Forge", "▲"),
        (.progress, "Charts", "◈"),
        (.library, "Library", "❖"),
    ]

    var body: some View {
        HStack {
            ForEach(tabs, id: \.0) { tab, label, glyph in
                let active = selected == tab
                VStack(spacing: 2) {
                    Text(glyph)
                        .font(.system(size: 14))
                        .foregroundStyle(active ? Deco.gold : Deco.brassLight)
                    Text(label.uppercased())
                        .font(.mono(9))
                        .tracking(2)
                        .foregroundStyle(active ? Deco.brassLight : Color(hex: 0xF3EAD7, alpha: 0.55))
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture { selected = tab }
            }
        }
        .padding(.top, 14)
        .padding(.bottom, 6)
        .frame(maxWidth: .infinity)
        .background(Deco.ink)
        .overlay(alignment: .top) { Rectangle().fill(Deco.brass).frame(height: 2) }
    }
}

/// Wrapping HStack (iOS 16 Layout) for tag chips.
struct FlexibleWrap: Layout {
    var spacing: CGFloat = 6
    var lineSpacing: CGFloat = 6

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = layout(subviews: subviews, maxWidth: proposal.width ?? .infinity)
        let height = rows.map { $0.y + $0.size.height }.max() ?? 0
        return CGSize(width: proposal.width ?? 0, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        for item in layout(subviews: subviews, maxWidth: bounds.width) {
            subviews[item.index].place(
                at: CGPoint(x: bounds.minX + item.x, y: bounds.minY + item.y),
                anchor: .topLeading,
                proposal: ProposedViewSize(item.size)
            )
        }
    }

    private struct Item { let index: Int; let x: CGFloat; let y: CGFloat; let size: CGSize }

    private func layout(subviews: Subviews, maxWidth: CGFloat) -> [Item] {
        var items: [Item] = []
        var x: CGFloat = 0, y: CGFloat = 0, rowHeight: CGFloat = 0
        for (i, sub) in subviews.enumerated() {
            let size = sub.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0; y += rowHeight + lineSpacing; rowHeight = 0
            }
            items.append(Item(index: i, x: x, y: y, size: size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        return items
    }
}
