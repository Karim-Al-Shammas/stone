import Foundation

/// A single logged set within an exercise entry.
struct SetEntry: Codable, Identifiable, Hashable {
    var id = UUID()
    var weight: Double = 0
    var reps: Int = 0
    var done: Bool = false
}

/// One exercise performed in a workout, with its sets.
struct ExerciseEntry: Codable, Identifiable, Hashable {
    var id = UUID()
    var exerciseId: String
    var sets: [SetEntry] = []

    var exercise: Exercise? { Exercise.byId(exerciseId) }
}

/// A completed workout session.
struct Workout: Codable, Identifiable, Hashable {
    var id = UUID()
    /// Stored as `yyyy-MM-dd`, matching the original web app.
    var date: String
    var name: String
    var exercises: [ExerciseEntry]
    var duration: Int  // minutes

    var totalSets: Int { exercises.reduce(0) { $0 + $1.sets.count } }
}

/// A computed personal record for an exercise.
struct PersonalRecord: Identifiable {
    var id: String { exerciseId }
    let exerciseId: String
    let weight: Double
    let reps: Int
    let date: String

    var name: String { Exercise.byId(exerciseId)?.name ?? exerciseId }
}

/// Shared date helpers so every screen formats dates identically.
enum AppDate {
    static let iso: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = .current
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    static func key(_ date: Date) -> String { iso.string(from: date) }
    static func parse(_ key: String) -> Date? { iso.date(from: key) }
}

func formatTime(_ seconds: Int) -> String {
    String(format: "%d:%02d", seconds / 60, seconds % 60)
}
