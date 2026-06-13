import SwiftUI

struct ActiveWorkoutView: View {
    @EnvironmentObject var store: AppStore
    @ObservedObject var active: ActiveWorkout
    @State private var showPicker = false
    @State private var confirmCancel = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    TextField("Workout name", text: $active.name)
                        .font(.system(size: 22, weight: .bold))

                    if active.restRemaining > 0 {
                        RestBanner(active: active)
                    }

                    ForEach(Array(active.exercises.enumerated()), id: \.element.id) { index, entry in
                        ExerciseBlock(active: active, index: index, entry: entry)
                    }

                    Button { showPicker = true } label: {
                        Label("Add Exercise", systemImage: "plus")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Theme.blue)
                            .frame(maxWidth: .infinity)
                            .padding(14)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .strokeBorder(Color(hex: 0xD4E6FF), style: StrokeStyle(lineWidth: 2, dash: [6]))
                            )
                    }

                    if !active.exercises.isEmpty {
                        Button {
                            store.finishActive()
                        } label: {
                            Label("Finish Workout", systemImage: "checkmark")
                                .font(.system(size: 16, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding(16)
                                .background(Theme.green)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                    }
                }
                .padding(16)
            }
            .background(Theme.bg)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { confirmCancel = true }
                }
                ToolbarItem(placement: .principal) {
                    Text(formatTime(active.elapsed))
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Theme.blue)
                        .monospacedDigit()
                }
            }
            .confirmationDialog("Discard workout?", isPresented: $confirmCancel, titleVisibility: .visible) {
                Button("Discard", role: .destructive) { store.cancelActive() }
            }
            .sheet(isPresented: $showPicker) {
                ExercisePickerView { id in
                    active.addExercise(id)
                    showPicker = false
                }
            }
        }
    }
}

struct RestBanner: View {
    @ObservedObject var active: ActiveWorkout

    var body: some View {
        HStack {
            Text("Rest").font(.system(size: 13))
            Spacer()
            Text(formatTime(active.restRemaining))
                .font(.system(size: 22, weight: .bold))
                .monospacedDigit()
            Spacer()
            HStack(spacing: 8) {
                CircleIconButton(system: active.restRunning ? "pause.fill" : "play.fill") {
                    active.toggleRest()
                }
                CircleIconButton(system: "arrow.counterclockwise") {
                    active.resetRest()
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .background(Color(hex: 0xF0F7FF))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color(hex: 0xD4E6FF)))
    }
}

struct CircleIconButton: View {
    let system: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: system)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 34, height: 34)
                .background(Theme.blue)
                .clipShape(Circle())
        }
    }
}

struct ExerciseBlock: View {
    @ObservedObject var active: ActiveWorkout
    let index: Int
    let entry: ExerciseEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.exercise?.name ?? "").font(.system(size: 15, weight: .semibold))
                    Text(entry.exercise?.muscle ?? "").font(.system(size: 12)).foregroundStyle(Theme.blue)
                }
                Spacer()
                Button(role: .destructive) {
                    active.removeExercise(at: index)
                } label: {
                    Image(systemName: "trash").foregroundStyle(Theme.sub).font(.system(size: 14))
                }
            }

            HStack(spacing: 8) {
                Text("SET").frame(width: 35)
                Text("KG").frame(maxWidth: .infinity)
                Text("REPS").frame(maxWidth: .infinity)
                Spacer().frame(width: 36)
            }
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(Theme.sub)

            ForEach(Array(entry.sets.enumerated()), id: \.element.id) { si, _ in
                SetRow(active: active, exerciseIndex: index, setIndex: si)
            }

            Button {
                active.addSet(exerciseIndex: index)
            } label: {
                Text("+ Add Set")
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.sub)
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .strokeBorder(Color(hex: 0xDDDDDD), style: StrokeStyle(lineWidth: 1, dash: [4]))
                    )
            }
            .padding(.top, 6)
        }
        .padding(14)
        .cardStyle(radius: 14)
    }
}

struct SetRow: View {
    @ObservedObject var active: ActiveWorkout
    let exerciseIndex: Int
    let setIndex: Int

    private var binding: Binding<SetEntry> {
        Binding(
            get: { active.exercises[exerciseIndex].sets[setIndex] },
            set: { active.exercises[exerciseIndex].sets[setIndex] = $0 }
        )
    }

    var body: some View {
        let set = active.exercises[exerciseIndex].sets[setIndex]
        HStack(spacing: 8) {
            Text("\(setIndex + 1)")
                .font(.system(size: 13))
                .foregroundStyle(Theme.sub)
                .frame(width: 35)

            NumberField(value: Binding(
                get: { binding.wrappedValue.weight },
                set: { binding.wrappedValue.weight = $0 }
            ))
            NumberField(value: Binding(
                get: { Double(binding.wrappedValue.reps) },
                set: { binding.wrappedValue.reps = Int($0) }
            ))

            Button {
                active.toggleSet(exerciseIndex: exerciseIndex, setIndex: setIndex)
            } label: {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(set.done ? .white : Color(hex: 0x999999))
                    .frame(width: 36, height: 36)
                    .background(set.done ? Theme.blue : Color(hex: 0xE8E8E8))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 4)
        .background(set.done ? Color(hex: 0xF0F7FF) : .clear)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

/// Numeric text field that shows an empty string for zero, like the web inputs.
struct NumberField: View {
    @Binding var value: Double

    var body: some View {
        TextField("0", text: Binding(
            get: { value == 0 ? "" : trimmed(value) },
            set: { value = Double($0) ?? 0 }
        ))
        .keyboardType(.decimalPad)
        .multilineTextAlignment(.center)
        .font(.system(size: 15, weight: .semibold))
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Theme.bg)
        .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).stroke(Color(hex: 0xE8E8E8)))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private func trimmed(_ v: Double) -> String {
        v.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(v)) : String(v)
    }
}
