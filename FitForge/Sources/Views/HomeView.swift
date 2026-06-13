import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: AppStore

    private var dateString: String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, MMMM d"
        return f.string(from: Date())
    }

    private var volumeString: String {
        let v = store.weeklyVolume
        return v > 999 ? String(format: "%.1fk", v / 1000) : String(Int(v))
    }

    private var recentPRs: [PersonalRecord] {
        store.personalRecords.values
            .sorted { ($0.date) > ($1.date) }
            .prefix(3)
            .map { $0 }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("FitForge")
                        .font(.system(size: 28, weight: .heavy))
                    Text(dateString)
                        .font(.subheadline)
                        .foregroundStyle(Theme.sub)
                }
                .padding(.bottom, 20)

                HStack(spacing: 10) {
                    StatCard(label: "This Week", value: "\(store.workoutsThisWeek.count)",
                             unit: "workouts", accent: Theme.blue)
                    StatCard(label: "Volume", value: volumeString, unit: "kg", accent: Theme.green)
                    StatCard(label: "Streak", value: "\(store.streak)", unit: "days",
                             accent: Theme.orange, icon: "flame.fill")
                }
                .padding(.bottom, 16)

                Button(action: store.startWorkout) {
                    Label("Start Workout", systemImage: "plus")
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(Theme.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .shadow(color: Theme.blue.opacity(0.35), radius: 14, x: 0, y: 4)
                }
                .padding(.bottom, 24)

                if !recentPRs.isEmpty {
                    SectionHeader(title: "Recent PRs", icon: "trophy")
                    ForEach(recentPRs) { pr in
                        PRRow(pr: pr)
                    }
                }

                let recent = Array(store.workoutsByDateDesc.prefix(3))
                if !recent.isEmpty {
                    Text("Recent Workouts")
                        .font(.system(size: 17, weight: .bold))
                        .padding(.top, 24)
                        .padding(.bottom, 12)
                    ForEach(recent) { w in
                        WorkoutSummaryRow(workout: w)
                    }
                }
            }
            .padding(16)
        }
        .background(Theme.bg)
    }
}

struct StatCard: View {
    let label: String
    let value: String
    let unit: String
    let accent: Color
    var icon: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label.uppercased())
                .font(.system(size: 11))
                .foregroundStyle(Theme.sub)
            HStack(spacing: 4) {
                if let icon {
                    Image(systemName: icon).foregroundStyle(accent).font(.system(size: 14))
                }
                Text(value).font(.system(size: 26, weight: .bold))
                Text(unit).font(.system(size: 12)).foregroundStyle(Theme.sub)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .background(Theme.card)
        .overlay(alignment: .top) { accent.frame(height: 3) }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 3, x: 0, y: 1)
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon).foregroundStyle(Theme.orange)
            Text(title).font(.system(size: 17, weight: .bold))
        }
        .padding(.bottom, 12)
    }
}

struct PRRow: View {
    let pr: PersonalRecord

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(pr.name).font(.system(size: 14, weight: .semibold))
                Text(pr.date).font(.system(size: 12)).foregroundStyle(Theme.sub)
            }
            Spacer()
            Text("\(Int(pr.weight)) kg × \(pr.reps)")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(Theme.blue)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .cardStyle(radius: 10)
        .padding(.bottom, 6)
    }
}

struct WorkoutSummaryRow: View {
    let workout: Workout

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(workout.name).font(.system(size: 15, weight: .semibold))
                Text("\(workout.date) · \(workout.exercises.count) exercises · \(workout.duration)min")
                    .font(.system(size: 12)).foregroundStyle(Theme.sub)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(Theme.sub).font(.system(size: 13))
        }
        .padding(14)
        .cardStyle()
        .padding(.bottom, 8)
    }
}
