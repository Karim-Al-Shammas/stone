import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: AppStore

    private var greeting: String {
        switch Calendar.current.component(.hour, from: Date()) {
        case 5..<12: return "Good morning,"
        case 12..<17: return "Good afternoon,"
        default: return "Good evening,"
        }
    }

    private var headerSub: String {
        let f = DateFormatter(); f.dateFormat = "MMMM"
        let year = Calendar.current.component(.year, from: Date())
        return "\(f.string(from: Date())) · \(roman(year))"
    }

    private var volume: String {
        String(format: "%.1f", store.weeklyVolume / 1000)
    }

    private var recentPRs: [PersonalRecord] {
        store.personalRecords.values.sorted { $0.date > $1.date }.prefix(3).map { $0 }
    }

    var body: some View {
        VStack(spacing: 0) {
            DecoHeader(title: "FITFORGE", sub: headerSub)
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(greeting).font(.bodyText(13)).tracking(0.5).foregroundStyle(Deco.inkSoft)
                    Text("ATHLETE").font(.display(28)).tracking(2).foregroundStyle(Deco.ink)
                        .padding(.top, 2)

                    statsTrio.padding(.top, 22)
                    beginButton.padding(.top, 22)

                    if !recentPRs.isEmpty {
                        SectionTitle(title: "RECENT RECORDS", kicker: "Laureates")
                        recordsCard.padding(.top, 10)
                    }

                    let recent = Array(store.workoutsByDateDesc.prefix(3))
                    if !recent.isEmpty {
                        SectionTitle(title: "RECENT SESSIONS", kicker: "Ledger")
                        VStack(spacing: 6) {
                            ForEach(recent) { SessionRow(workout: $0) }
                        }
                        .padding(.top, 10)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 120)
            }
        }
        .background(Deco.cream)
    }

    private var statsTrio: some View {
        HStack(spacing: 0) {
            statCell("WEEK", "\(store.workoutsThisWeek.count)", "sessions", divider: true)
            statCell("VOLUME", volume, "kt", divider: true)
            statCell("STREAK", "\(store.streak)", "days", divider: false)
        }
        .background(Deco.paper)
        .overlay(Rectangle().stroke(Deco.brass, lineWidth: 1))
    }

    private func statCell(_ label: String, _ value: String, _ unit: String, divider: Bool) -> some View {
        VStack(spacing: 0) {
            Rectangle().fill(Deco.brass).frame(width: 1, height: 6)
            Kicker(text: label, size: 9).padding(.top, 8)
            Text(value).font(.display(38)).tracking(1).foregroundStyle(Deco.ink)
                .padding(.top, 6).lineLimit(1).minimumScaleFactor(0.6)
            Text(unit).font(.mono(9)).tracking(1.5).foregroundStyle(Deco.inkSoft).padding(.top, 6)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .overlay(alignment: .trailing) {
            if divider { Rectangle().fill(Deco.lineSoft).frame(width: 1) }
        }
    }

    private var beginButton: some View {
        Button(action: store.startWorkout) {
            ZStack {
                ChamferShape(cut: 11).stroke(Deco.brass, lineWidth: 1)
                Text("▲  BEGIN SESSION  ▲")
                    .font(.display(18)).tracking(6).foregroundStyle(Deco.cream)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(Deco.ink, in: ChamferShape(cut: 8))
                    .padding(3)
            }
        }
        .buttonStyle(.plain)
    }

    private var recordsCard: some View {
        VStack(spacing: 0) {
            ForEach(Array(recentPRs.enumerated()), id: \.element.id) { i, pr in
                HStack(spacing: 12) {
                    Text("\(i + 1)")
                        .font(.display(14)).foregroundStyle(Deco.brass)
                        .frame(width: 34, height: 34)
                        .overlay(Rectangle().stroke(Deco.brass, lineWidth: 1))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(pr.name).font(.bodyText(14, .medium)).tracking(0.3).foregroundStyle(Deco.ink)
                        Kicker(text: pr.date, color: Deco.inkSoft, size: 9, tracking: 1.5)
                    }
                    Spacer()
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(trim(pr.weight)).font(.display(22)).tracking(1).foregroundStyle(Deco.brassDeep)
                        Text("KG×\(pr.reps)").font(.mono(9)).tracking(1.5).foregroundStyle(Deco.inkSoft)
                    }
                }
                .padding(.vertical, 14).padding(.horizontal, 16)
                if i < recentPRs.count - 1 { Rectangle().fill(Deco.lineSoft).frame(height: 1) }
            }
        }
        .decoCard()
    }
}

struct SessionRow: View {
    let workout: Workout
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(workout.name.uppercased()).font(.display(16)).tracking(1.5).foregroundStyle(Deco.ink)
                Kicker(text: "\(workout.date) · \(workout.exercises.count) EX · \(workout.duration)M",
                       color: Deco.inkSoft, size: 9, tracking: 1.5)
            }
            Spacer()
            Text("›").foregroundStyle(Deco.brass).font(.system(size: 16))
        }
        .padding(.vertical, 12).padding(.horizontal, 14)
        .decoCard()
    }
}

/// Bottom-corner-chamfered rectangle for the Begin Session CTA.
struct ChamferShape: Shape {
    var cut: CGFloat
    func path(in r: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: r.minX, y: r.minY))
        p.addLine(to: CGPoint(x: r.maxX, y: r.minY))
        p.addLine(to: CGPoint(x: r.maxX, y: r.maxY - cut))
        p.addLine(to: CGPoint(x: r.maxX - cut, y: r.maxY))
        p.addLine(to: CGPoint(x: r.minX + cut, y: r.maxY))
        p.addLine(to: CGPoint(x: r.minX, y: r.maxY - cut))
        p.closeSubpath()
        return p
    }
}

/// Shared numeric trim + Roman numeral helpers.
func trim(_ v: Double) -> String {
    v.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(v)) : String(v)
}

func roman(_ number: Int) -> String {
    let table: [(Int, String)] = [
        (1000, "M"), (900, "CM"), (500, "D"), (400, "CD"), (100, "C"),
        (90, "XC"), (50, "L"), (40, "XL"), (10, "X"), (9, "IX"),
        (5, "V"), (4, "IV"), (1, "I"),
    ]
    var n = number, out = ""
    for (v, s) in table { while n >= v { out += s; n -= v } }
    return out
}
