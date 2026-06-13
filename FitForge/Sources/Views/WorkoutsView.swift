import SwiftUI

struct WorkoutsView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Workouts").font(.system(size: 28, weight: .heavy))
                    Spacer()
                    Button(action: store.startWorkout) {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 38, height: 38)
                            .background(Theme.blue)
                            .clipShape(Circle())
                    }
                }
                .padding(.bottom, 16)

                if store.workouts.isEmpty {
                    Text("No workouts yet!")
                        .foregroundStyle(Theme.sub)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                }

                ForEach(store.workoutsByDateDesc) { workout in
                    WorkoutCard(workout: workout) {
                        store.deleteWorkout(workout)
                    }
                }
            }
            .padding(16)
        }
        .background(Theme.bg)
    }
}

struct WorkoutCard: View {
    let workout: Workout
    let onDelete: () -> Void
    @State private var confirming = false

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text(workout.name).font(.system(size: 15, weight: .semibold))
                Text(meta).font(.system(size: 12)).foregroundStyle(Theme.sub)
                FlowTags(names: workout.exercises.map { $0.exercise?.name ?? $0.exerciseId })
            }
            Spacer()
            Button(role: .destructive) { confirming = true } label: {
                Image(systemName: "trash").foregroundStyle(Theme.sub).font(.system(size: 14))
            }
        }
        .padding(14)
        .cardStyle()
        .padding(.bottom, 8)
        .confirmationDialog("Delete this workout?", isPresented: $confirming, titleVisibility: .visible) {
            Button("Delete", role: .destructive, action: onDelete)
        }
    }

    private var meta: String {
        var parts = ["\(workout.date)", "\(workout.exercises.count) exercises", "\(workout.totalSets) sets"]
        if workout.duration > 0 { parts.append("\(workout.duration)min") }
        return parts.joined(separator: " · ")
    }
}

/// Simple wrapping tag layout for exercise names.
struct FlowTags: View {
    let names: [String]

    var body: some View {
        FlexibleWrap(spacing: 4, lineSpacing: 4) {
            ForEach(Array(names.enumerated()), id: \.offset) { _, name in
                Text(name)
                    .font(.system(size: 11))
                    .foregroundStyle(Color(hex: 0x666666))
                    .padding(.vertical, 2)
                    .padding(.horizontal, 8)
                    .background(Theme.inputBg)
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            }
        }
    }
}
