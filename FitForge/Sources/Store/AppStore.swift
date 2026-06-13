import Foundation
import Combine

/// Holds all persisted workouts and derives stats / PRs. Persisted to
/// UserDefaults under `fg_workouts`, matching the original localStorage key.
@MainActor
final class AppStore: ObservableObject {
    @Published var workouts: [Workout] = []
    /// Non-nil while a workout is in progress; drives the full-screen cover.
    @Published var active: ActiveWorkout?

    private let storageKey = "fg_workouts"

    init() {
        load()
        if workouts.isEmpty {
            seedDemoData()
        }
    }

    // MARK: Persistence

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([Workout].self, from: data)
        else { return }
        workouts = decoded
    }

    func save() {
        guard let data = try? JSONEncoder().encode(workouts) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    // MARK: Mutations

    func deleteWorkout(_ workout: Workout) {
        workouts.removeAll { $0.id == workout.id }
        save()
    }

    func startWorkout() {
        let session = ActiveWorkout()
        session.start()
        active = session
    }

    func cancelActive() {
        active?.stop()
        active = nil
    }

    func finishActive() {
        guard let session = active, !session.exercises.isEmpty else { return }
        session.stop()
        let workout = Workout(
            date: AppDate.key(Date()),
            name: session.name.isEmpty ? "Workout" : session.name,
            exercises: session.exercises,
            duration: Int((Double(session.elapsed) / 60).rounded())
        )
        workouts.append(workout)
        save()
        active = nil
    }

    // MARK: Derived data

    /// Best done set per exercise, keyed by exercise id.
    var personalRecords: [String: PersonalRecord] {
        var prs: [String: PersonalRecord] = [:]
        for workout in workouts {
            for entry in workout.exercises {
                for set in entry.sets where set.done && set.weight > 0 {
                    if let existing = prs[entry.exerciseId], existing.weight >= set.weight {
                        continue
                    }
                    prs[entry.exerciseId] = PersonalRecord(
                        exerciseId: entry.exerciseId,
                        weight: set.weight,
                        reps: set.reps,
                        date: workout.date
                    )
                }
            }
        }
        return prs
    }

    var workoutsThisWeek: [Workout] {
        let now = Date()
        return workouts.filter {
            guard let d = AppDate.parse($0.date) else { return false }
            return now.timeIntervalSince(d) / 86_400 < 7
        }
    }

    var weeklyVolume: Double {
        workoutsThisWeek.reduce(0) { sum, w in
            sum + w.exercises.reduce(0) { s, e in
                s + e.sets.reduce(0) { $0 + ($1.done ? $1.weight * Double($1.reps) : 0) }
            }
        }
    }

    /// Consecutive-day streak ending today (today may be empty without breaking it).
    var streak: Int {
        let dates = Set(workouts.map(\.date))
        var streak = 0
        var day = Date()
        let cal = Calendar.current
        for i in 0..<60 {
            if dates.contains(AppDate.key(day)) {
                streak += 1
            } else if i > 0 {
                break
            }
            guard let prev = cal.date(byAdding: .day, value: -1, to: day) else { break }
            day = prev
        }
        return streak
    }

    var workoutsByDateDesc: [Workout] {
        workouts.sorted {
            (AppDate.parse($0.date) ?? .distantPast) > (AppDate.parse($1.date) ?? .distantPast)
        }
    }

    // MARK: Seed

    private func seedDemoData() {
        let now = Date()
        let day: TimeInterval = 86_400
        let pool = ["squat", "bench", "deadlift", "ohp", "row", "pullup"]
        let base: [String: Double] = [
            "squat": 60, "bench": 50, "deadlift": 70, "ohp": 30, "row": 45, "pullup": 0,
        ]
        var seeded: [Workout] = []
        var i = 29
        while i >= 0 {
            let date = now.addingTimeInterval(-Double(i) * day)
            let picks = pool.shuffled().prefix(3)
            let entries = picks.map { eid -> ExerciseEntry in
                let sets = (0..<3).map { _ -> SetEntry in
                    SetEntry(
                        weight: (base[eid] ?? 0) + Double((30 - i)) * 0.5 + Double(Int.random(in: 0..<5)),
                        reps: 5 + Int.random(in: 0..<4),
                        done: true
                    )
                }
                return ExerciseEntry(exerciseId: eid, sets: sets)
            }
            seeded.append(Workout(
                date: AppDate.key(date),
                name: "Workout",
                exercises: entries,
                duration: 40 + Int.random(in: 0..<30)
            ))
            i -= 3
        }
        workouts = seeded
        save()
    }
}
