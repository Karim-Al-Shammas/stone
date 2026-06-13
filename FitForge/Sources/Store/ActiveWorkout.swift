import Foundation
import Combine

/// Drives an in-progress workout: the elapsed clock and the auto-started
/// rest timer that fires whenever a set is checked off.
@MainActor
final class ActiveWorkout: ObservableObject {
    @Published var name = "Workout"
    @Published var exercises: [ExerciseEntry] = []
    @Published var elapsed = 0
    @Published var restRemaining = 0
    @Published var restRunning = false

    private var startTime = Date()
    private var elapsedTimer: Timer?
    private var restTimer: Timer?

    static let restDuration = 90

    func start() {
        startTime = Date()
        elapsed = 0
        elapsedTimer?.invalidate()
        elapsedTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self else { return }
                self.elapsed = Int(Date().timeIntervalSince(self.startTime))
            }
        }
    }

    func stop() {
        elapsedTimer?.invalidate()
        restTimer?.invalidate()
        elapsedTimer = nil
        restTimer = nil
        restRunning = false
    }

    // MARK: Exercises & sets

    func addExercise(_ id: String) {
        exercises.append(ExerciseEntry(exerciseId: id, sets: [SetEntry()]))
    }

    func removeExercise(at index: Int) {
        guard exercises.indices.contains(index) else { return }
        exercises.remove(at: index)
    }

    func addSet(exerciseIndex: Int) {
        guard exercises.indices.contains(exerciseIndex) else { return }
        let last = exercises[exerciseIndex].sets.last
        exercises[exerciseIndex].sets.append(
            SetEntry(weight: last?.weight ?? 0, reps: last?.reps ?? 0, done: false)
        )
    }

    func toggleSet(exerciseIndex: Int, setIndex: Int) {
        guard exercises.indices.contains(exerciseIndex),
              exercises[exerciseIndex].sets.indices.contains(setIndex) else { return }
        exercises[exerciseIndex].sets[setIndex].done.toggle()
        if exercises[exerciseIndex].sets[setIndex].done {
            startRest()
        }
    }

    // MARK: Rest timer

    func startRest() {
        restRemaining = Self.restDuration
        restRunning = true
        scheduleRest()
    }

    func toggleRest() {
        restRunning.toggle()
        restRunning ? scheduleRest() : restTimer?.invalidate()
    }

    func resetRest() {
        restRemaining = 0
        restRunning = false
        restTimer?.invalidate()
    }

    private func scheduleRest() {
        restTimer?.invalidate()
        restTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self else { return }
                if self.restRemaining <= 1 {
                    self.restRemaining = 0
                    self.restRunning = false
                    self.restTimer?.invalidate()
                } else {
                    self.restRemaining -= 1
                }
            }
        }
    }
}
