import SwiftUI

struct ProgressTab: View {
    @EnvironmentObject var store: AppStore
    @State private var selectedEx = "bench"

    private var chartable: [Exercise] {
        var seen = Set<String>()
        for w in store.workouts { for e in w.exercises { seen.insert(e.exerciseId) } }
        return Exercise.all.filter { seen.contains($0.id) }
    }

    private var points: [(label: String, value: Double)] {
        let sorted = store.workouts.sorted {
            (AppDate.parse($0.date) ?? .distantPast) < (AppDate.parse($1.date) ?? .distantPast)
        }
        return sorted.compactMap { w in
            guard let e = w.exercises.first(where: { $0.exerciseId == selectedEx }) else { return nil }
            let maxW = e.sets.filter(\.done).map(\.weight).max() ?? 0
            return maxW > 0 ? (String(w.date.suffix(5)), maxW) : nil
        }
    }

    private var records: [PersonalRecord] {
        store.personalRecords.values.sorted { $0.weight > $1.weight }
    }

    private var selectedName: String {
        Exercise.byId(selectedEx)?.name ?? selectedEx
    }

    var body: some View {
        VStack(spacing: 0) {
            DecoHeader(title: "CHARTS", sub: "Strength Atlas")
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(spacing: 2) {
                        Kicker(text: "Exercise", size: 9, tracking: 3)
                        Menu {
                            ForEach(chartable) { ex in
                                Button(ex.name) { selectedEx = ex.id }
                            }
                        } label: {
                            Text("\(selectedName.uppercased()) ▾")
                                .font(.display(26)).tracking(3).foregroundStyle(Deco.ink)
                        }
                    }
                    .frame(maxWidth: .infinity)

                    chartCard.padding(.top, 18)
                    summaryRow.padding(.top, 12)

                    SectionTitle(title: "RECORDS", kicker: "Hall of")
                    recordsList.padding(.top, 10)
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 120)
            }
        }
        .background(Deco.cream)
    }

    @ViewBuilder
    private var chartCard: some View {
        let data = points
        VStack(spacing: 4) {
            if data.count > 1 {
                DecoLineChart(points: data.map(\.value)).frame(height: 160)
                HStack {
                    Text(data.first!.label.uppercased())
                    Spacer()
                    Text(data.last!.label.uppercased())
                }
                .font(.mono(9)).tracking(1.5).foregroundStyle(Deco.inkSoft)
                .padding(.horizontal, 10)
            } else {
                Text("NEED AT LEAST 2 SESSIONS")
                    .font(.mono(10)).tracking(2).foregroundStyle(Deco.inkSoft)
                    .frame(maxWidth: .infinity).frame(height: 160)
            }
        }
        .padding(.vertical, 12).padding(.horizontal, 10)
        .background(Deco.paper)
        .overlay(Rectangle().stroke(Deco.brass, lineWidth: 1))
        .overlay(alignment: .top) { DashRule().frame(height: 5) }
    }

    private var summaryRow: some View {
        let data = points.map(\.value)
        let current = data.last ?? 0
        let peak = data.max() ?? 0
        let gained = (data.last ?? 0) - (data.first ?? 0)
        return HStack(spacing: 8) {
            summaryCell("CURRENT", trim(current))
            summaryCell("GAINED", (gained >= 0 ? "+" : "") + trim(gained))
            summaryCell("PEAK", trim(peak))
        }
    }

    private func summaryCell(_ label: String, _ value: String) -> some View {
        VStack(spacing: 4) {
            Kicker(text: label, size: 8, tracking: 2)
            Text(value).font(.display(22)).foregroundStyle(Deco.ink)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 6)
        .decoCard()
    }

    private var recordsList: some View {
        VStack(spacing: 0) {
            if records.isEmpty {
                Text("NO RECORDS YET").font(.mono(10)).tracking(2).foregroundStyle(Deco.inkSoft)
                    .frame(maxWidth: .infinity).padding(.vertical, 20)
            }
            ForEach(Array(records.enumerated()), id: \.element.id) { i, pr in
                HStack(spacing: 16) {
                    Rectangle().stroke(Deco.brass, lineWidth: 1)
                        .frame(width: 20, height: 20).rotationEffect(.degrees(45))
                        .frame(width: 28, height: 28)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(pr.name).font(.bodyText(14, .medium)).foregroundStyle(Deco.ink)
                        Kicker(text: pr.date, color: Deco.inkSoft, size: 9, tracking: 1.5)
                    }
                    Spacer()
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(trim(pr.weight)).font(.display(20)).tracking(1).foregroundStyle(Deco.brassDeep)
                        Text("KG").font(.mono(9)).foregroundStyle(Deco.inkSoft)
                    }
                }
                .padding(.vertical, 12).padding(.horizontal, 16)
                if i < records.count - 1 { Rectangle().fill(Deco.lineSoft).frame(height: 1) }
            }
        }
        .decoCard()
    }
}

/// Bespoke brass line chart with diamond data points and dashed gridlines.
struct DecoLineChart: View {
    let points: [Double]

    var body: some View {
        Canvas { ctx, size in
            let p: CGFloat = 16
            let maxV = points.max() ?? 1
            let minV = points.min() ?? 0
            let range = maxV - minV == 0 ? 1 : maxV - minV
            let xs = points.indices.map { p + CGFloat($0) * (size.width - 2 * p) / CGFloat(max(points.count - 1, 1)) }
            let ys = points.map { p + (1 - CGFloat(($0 - minV) / range)) * (size.height - 2 * p) }

            for (i, f) in [0.0, 0.25, 0.5, 0.75, 1.0].enumerated() {
                let y = p + CGFloat(f) * (size.height - 2 * p)
                var line = Path(); line.move(to: CGPoint(x: p, y: y)); line.addLine(to: CGPoint(x: size.width - p, y: y))
                let style = StrokeStyle(lineWidth: 0.5, dash: i % 2 == 1 ? [2, 3] : [])
                ctx.stroke(line, with: .color(Deco.line), style: style)
            }

            var path = Path()
            for (i, x) in xs.enumerated() {
                let pt = CGPoint(x: x, y: ys[i])
                i == 0 ? path.move(to: pt) : path.addLine(to: pt)
            }
            ctx.stroke(path, with: .color(Deco.brassDeep), lineWidth: 1.5)

            for (i, x) in xs.enumerated() {
                let c = CGPoint(x: x, y: ys[i])
                var d = Path()
                d.move(to: CGPoint(x: c.x, y: c.y - 4))
                d.addLine(to: CGPoint(x: c.x + 4, y: c.y))
                d.addLine(to: CGPoint(x: c.x, y: c.y + 4))
                d.addLine(to: CGPoint(x: c.x - 4, y: c.y))
                d.closeSubpath()
                ctx.fill(d, with: .color(Deco.cream))
                ctx.stroke(d, with: .color(Deco.brassDeep), lineWidth: 1)
            }
        }
    }
}

/// Repeating brass dash rule (top edge of the chart card).
struct DashRule: View {
    var body: some View {
        Canvas { ctx, size in
            var x: CGFloat = 0
            while x < size.width {
                ctx.fill(Path(CGRect(x: x, y: 0, width: 8, height: size.height)), with: .color(Deco.brass))
                x += 12
            }
        }
    }
}
