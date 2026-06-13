import SwiftUI

struct ActiveWorkoutView: View {
    @EnvironmentObject var store: AppStore
    @ObservedObject var active: ActiveWorkout
    @State private var showPicker = false
    @State private var confirmCancel = false

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Text(active.name.isEmpty ? "WORKOUT" : active.name.uppercased())
                        .font(.display(26)).tracking(3).foregroundStyle(Deco.ink)
                        .frame(maxWidth: .infinity)
                    Rectangle().fill(Deco.brass).frame(width: 60, height: 1).padding(.top, 4)

                    TextField("Name this session", text: $active.name)
                        .font(.mono(9)).tracking(2).multilineTextAlignment(.center)
                        .foregroundStyle(Deco.inkSoft).padding(.top, 6)

                    if active.restRemaining > 0 { restBanner.padding(.top, 16) }

                    ForEach(Array(active.exercises.enumerated()), id: \.element.id) { i, entry in
                        ExerciseBlock(active: active, index: i, entry: entry).padding(.top, 16)
                    }

                    Button { showPicker = true } label: {
                        Text("+ ADD EXERCISE")
                            .font(.mono(11)).tracking(3).foregroundStyle(Deco.brassDeep)
                            .frame(maxWidth: .infinity).padding(14)
                            .background(Deco.restTint)
                            .overlay(Rectangle().strokeBorder(Deco.brass, style: StrokeStyle(lineWidth: 1, dash: [4])))
                    }
                    .buttonStyle(.plain).padding(.top, 16)

                    if !active.exercises.isEmpty {
                        Button { store.finishActive() } label: {
                            Text("✓   CONCLUDE SESSION")
                                .font(.display(16)).tracking(4).foregroundStyle(Deco.cream)
                                .frame(maxWidth: .infinity).padding(18)
                                .background(Deco.brassDeep)
                        }
                        .buttonStyle(.plain).padding(.top, 16)
                    }
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 14)
                .padding(.bottom, 30)
            }
        }
        .background(Deco.cream.ignoresSafeArea())
        .sheet(isPresented: $showPicker) {
            ExercisePickerView { id in active.addExercise(id); showPicker = false }
        }
        .confirmationDialog("Discard this session?", isPresented: $confirmCancel, titleVisibility: .visible) {
            Button("Discard", role: .destructive) { store.cancelActive() }
        }
    }

    private var topBar: some View {
        HStack {
            Button { confirmCancel = true } label: {
                Text("‹ CANCEL").font(.mono(11)).tracking(2).foregroundStyle(Deco.brassDeep)
            }
            Spacer()
            VStack(spacing: 0) {
                Kicker(text: "Elapsed", color: Deco.inkSoft, size: 9, tracking: 3)
                Text(formatTime(active.elapsed)).font(.display(22)).tracking(2).foregroundStyle(Deco.ink)
            }
            Spacer()
            Text("···").font(.mono(11)).tracking(2).foregroundStyle(Deco.inkSoft)
        }
        .padding(.horizontal, 20).padding(.top, 8).padding(.bottom, 12)
        .overlay(alignment: .bottom) { Rectangle().fill(Deco.line).frame(height: 1) }
    }

    private var restBanner: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Kicker(text: "Rest", color: Deco.brassLight, size: 9, tracking: 3)
                Text(formatTime(active.restRemaining)).font(.display(28)).tracking(2).foregroundStyle(Deco.cream)
            }
            Spacer()
            HStack(spacing: 8) {
                squareGlyph(active.restRunning ? "▌▌" : "▶") { active.toggleRest() }
                squareGlyph("↺") { active.resetRest() }
            }
        }
        .padding(.vertical, 14).padding(.horizontal, 16)
        .background(Deco.ink)
    }

    private func squareGlyph(_ glyph: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(glyph).font(.system(size: 12)).foregroundStyle(Deco.brassLight)
                .frame(width: 36, height: 36)
                .overlay(Rectangle().stroke(Deco.brass, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

struct ExerciseBlock: View {
    @ObservedObject var active: ActiveWorkout
    let index: Int
    let entry: ExerciseEntry

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.exercise?.name.uppercased() ?? "").font(.display(16)).tracking(1.5).foregroundStyle(Deco.ink)
                    Kicker(text: entry.exercise?.muscle ?? "", size: 9, tracking: 2)
                }
                Spacer()
                Button { active.removeExercise(at: index) } label: {
                    Text("⌫").foregroundStyle(Deco.inkSoft).font(.system(size: 15))
                }.buttonStyle(.plain)
            }
            .padding(.vertical, 12).padding(.horizontal, 16)
            .overlay(alignment: .bottom) { Rectangle().fill(Deco.lineSoft).frame(height: 1) }

            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    Text("SET").frame(width: 32, alignment: .leading)
                    Text("KG").frame(maxWidth: .infinity)
                    Text("REPS").frame(maxWidth: .infinity)
                    Spacer().frame(width: 40)
                }
                .font(.mono(9)).tracking(2).foregroundStyle(Deco.inkSoft)
                .padding(.bottom, 6)
                .overlay(alignment: .bottom) { Rectangle().fill(Deco.lineSoft).frame(height: 1) }

                ForEach(Array(entry.sets.enumerated()), id: \.element.id) { si, _ in
                    SetRow(active: active, exerciseIndex: index, setIndex: si,
                           isLast: si == entry.sets.count - 1)
                }

                Button { active.addSet(exerciseIndex: index) } label: {
                    Text("+ ADD SET").font(.mono(10)).tracking(2).foregroundStyle(Deco.brassDeep)
                        .frame(maxWidth: .infinity).padding(8)
                        .overlay(Rectangle().strokeBorder(Deco.brass, style: StrokeStyle(lineWidth: 1, dash: [4])))
                }
                .buttonStyle(.plain).padding(.top, 10)
            }
            .padding(.horizontal, 16).padding(.top, 10).padding(.bottom, 12)
        }
        .decoCard()
    }
}

struct SetRow: View {
    @ObservedObject var active: ActiveWorkout
    let exerciseIndex: Int
    let setIndex: Int
    let isLast: Bool

    var body: some View {
        let set = active.exercises[exerciseIndex].sets[setIndex]
        HStack(spacing: 8) {
            Text("\(setIndex + 1)").font(.display(14)).foregroundStyle(Deco.brassDeep).frame(width: 32, alignment: .leading)
            decoNumberField(get: { set.weight }, set: { active.exercises[exerciseIndex].sets[setIndex].weight = $0 })
            decoNumberField(get: { Double(set.reps) }, set: { active.exercises[exerciseIndex].sets[setIndex].reps = Int($0) })
            Button {
                active.toggleSet(exerciseIndex: exerciseIndex, setIndex: setIndex)
            } label: {
                Text("✓").font(.system(size: 14))
                    .foregroundStyle(set.done ? Deco.cream : .clear)
                    .frame(width: 28, height: 28)
                    .background(set.done ? Deco.brass : .clear)
                    .overlay(Rectangle().stroke(set.done ? Deco.brass : Deco.line, lineWidth: 1))
            }
            .buttonStyle(.plain)
            .frame(maxWidth: 40, alignment: .trailing)
        }
        .padding(.vertical, 8)
        .background(set.done ? Deco.restTint : .clear)
        .overlay(alignment: .bottom) { if !isLast { Rectangle().fill(Deco.lineSoft).frame(height: 1) } }
    }

    private func decoNumberField(get: @escaping () -> Double, set: @escaping (Double) -> Void) -> some View {
        TextField("0", text: Binding(
            get: { get() == 0 ? "" : trim(get()) },
            set: { set(Double($0) ?? 0) }
        ))
        .keyboardType(.decimalPad)
        .multilineTextAlignment(.center)
        .font(.display(18)).foregroundStyle(Deco.ink)
        .frame(maxWidth: .infinity)
    }
}
