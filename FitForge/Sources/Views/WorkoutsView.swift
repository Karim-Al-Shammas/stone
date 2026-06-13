import SwiftUI

struct WorkoutsView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        VStack(spacing: 0) {
            DecoHeader(title: "THE FORGE", sub: "Session Ledger")
            ScrollView(showsIndicators: false) {
                VStack(spacing: 10) {
                    Button(action: store.startWorkout) {
                        Text("+   NEW SESSION")
                            .font(.display(16)).tracking(4).foregroundStyle(Deco.cream)
                            .frame(maxWidth: .infinity).padding(16)
                            .background(Deco.ink)
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, 8)

                    if store.workouts.isEmpty {
                        Text("NO SESSIONS LOGGED").font(.mono(11)).tracking(2)
                            .foregroundStyle(Deco.inkSoft).padding(.top, 50)
                    }

                    ForEach(store.workoutsByDateDesc) { workout in
                        WorkoutLedgerCard(workout: workout) { store.deleteWorkout(workout) }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 18)
                .padding(.bottom, 120)
            }
        }
        .background(Deco.cream)
    }
}

struct WorkoutLedgerCard: View {
    let workout: Workout
    let onDelete: () -> Void
    @State private var confirming = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .firstTextBaseline) {
                Text(workout.name.uppercased()).font(.display(18)).tracking(1.8).foregroundStyle(Deco.ink)
                Spacer()
                Text(workout.date.uppercased()).font(.mono(9)).tracking(2).foregroundStyle(Deco.brassDeep)
            }
            HStack(spacing: 16) {
                Text("\(workout.exercises.count) EXERCISES")
                Text("·")
                Text("\(workout.totalSets) SETS")
                Text("·")
                Text("\(workout.duration) MIN")
            }
            .font(.mono(10)).tracking(1).foregroundStyle(Deco.inkSoft)
            .padding(.top, 8)

            FlexibleWrap(spacing: 6, lineSpacing: 6) {
                ForEach(Array(workout.exercises.enumerated()), id: \.offset) { _, e in
                    Text(e.exercise?.name ?? e.exerciseId)
                        .font(.bodyText(10)).tracking(0.5).foregroundStyle(Deco.brassDeep)
                        .padding(.vertical, 3).padding(.horizontal, 8)
                        .overlay(Rectangle().stroke(Deco.brass, lineWidth: 1))
                }
            }
            .padding(.top, 10)
        }
        .padding(.vertical, 14).padding(.horizontal, 16)
        .decoCard()
        .contextMenu {
            Button("Delete Session", role: .destructive) { confirming = true }
        }
        .confirmationDialog("Delete this session?", isPresented: $confirming, titleVisibility: .visible) {
            Button("Delete", role: .destructive, action: onDelete)
        }
    }
}
