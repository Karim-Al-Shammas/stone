import SwiftUI
import Charts

struct ProgressTab: View {
    @EnvironmentObject var store: AppStore
    @State private var selectedEx = "bench"

    /// Exercises that appear in at least one logged workout (max 8 chips).
    private var chartableExercises: [Exercise] {
        var seen = Set<String>()
        for w in store.workouts { for e in w.exercises { seen.insert(e.exerciseId) } }
        return Exercise.all.filter { seen.contains($0.id) }.prefix(8).map { $0 }
    }

    private var chartData: [(date: String, weight: Double)] {
        let sorted = store.workouts.sorted {
            (AppDate.parse($0.date) ?? .distantPast) < (AppDate.parse($1.date) ?? .distantPast)
        }
        return sorted.compactMap { w in
            guard let entry = w.exercises.first(where: { $0.exerciseId == selectedEx }) else { return nil }
            let maxW = entry.sets.filter(\.done).map(\.weight).max() ?? 0
            guard maxW > 0 else { return nil }
            return (String(w.date.suffix(5)), maxW)
        }
    }

    private var prList: [PersonalRecord] {
        store.personalRecords.values.sorted { $0.weight > $1.weight }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("Progress").font(.system(size: 28, weight: .heavy)).padding(.bottom, 12)

                Text("Strength Chart").font(.system(size: 17, weight: .bold)).padding(.bottom, 12)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(chartableExercises) { ex in
                            FilterChip(title: ex.name, isActive: selectedEx == ex.id) {
                                selectedEx = ex.id
                            }
                        }
                    }
                }
                .padding(.bottom, 12)

                chart

                HStack(spacing: 8) {
                    Image(systemName: "trophy").foregroundStyle(Theme.orange)
                    Text("Personal Records").font(.system(size: 17, weight: .bold))
                }
                .padding(.top, 24)
                .padding(.bottom, 12)

                if prList.isEmpty {
                    Text("No PRs yet").foregroundStyle(Theme.sub)
                }
                ForEach(prList) { pr in
                    PRRow(pr: pr)
                }
            }
            .padding(16)
        }
        .background(Theme.bg)
    }

    @ViewBuilder
    private var chart: some View {
        let data = chartData
        if data.count > 1 {
            Chart(Array(data.enumerated()), id: \.offset) { _, point in
                LineMark(x: .value("Date", point.date), y: .value("Weight", point.weight))
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(Theme.blue)
                PointMark(x: .value("Date", point.date), y: .value("Weight", point.weight))
                    .foregroundStyle(Theme.blue)
            }
            .chartYScale(domain: .automatic(includesZero: false))
            .frame(height: 180)
            .padding(16)
            .cardStyle()
        } else {
            Text("Need at least 2 sessions to chart")
                .font(.system(size: 14))
                .foregroundStyle(Theme.sub)
                .frame(maxWidth: .infinity)
                .padding(30)
                .cardStyle()
        }
    }
}
