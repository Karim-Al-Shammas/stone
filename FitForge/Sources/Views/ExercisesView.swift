import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var store: AppStore
    @State private var search = ""
    @State private var muscle: String?
    @State private var detail: Exercise?

    private var filtered: [Exercise] {
        Exercise.all.filter { ex in
            (muscle == nil || ex.muscle == muscle) &&
            (search.isEmpty || ex.name.localizedCaseInsensitiveContains(search))
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            DecoHeader(title: "LIBRARY", sub: "Catalogue of Exercises")
            ScrollView(showsIndicators: false) {
                VStack(spacing: 6) {
                    DecoSearchField(placeholder: "Search the catalogue…", text: $search)
                        .padding(.bottom, 8)
                    MuscleChips(selected: $muscle).padding(.bottom, 8)

                    ForEach(filtered) { ex in
                        Button { detail = ex } label: { ExerciseRow(exercise: ex) }
                            .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)
                .padding(.bottom, 120)
            }
        }
        .background(Deco.cream)
        .fullScreenCover(item: $detail) { ex in
            ExerciseDetailView(exercise: ex) { detail = nil }
        }
    }
}

struct ExerciseRow: View {
    let exercise: Exercise
    var body: some View {
        HStack(spacing: 12) {
            Text(String(exercise.muscle.prefix(1)))
                .font(.display(14)).foregroundStyle(Deco.brassDeep)
                .frame(width: 36, height: 36)
                .overlay(Rectangle().stroke(Deco.brass, lineWidth: 1))
            VStack(alignment: .leading, spacing: 2) {
                Text(exercise.name).font(.bodyText(14, .medium)).tracking(0.2).foregroundStyle(Deco.ink)
                Kicker(text: "\(exercise.muscle) · \(exercise.type.rawValue)", size: 9, tracking: 1.5)
            }
            Spacer()
            Text("›").foregroundStyle(Deco.inkSoft).font(.system(size: 16))
        }
        .padding(.vertical, 12).padding(.horizontal, 14)
        .decoCard()
    }
}

struct ExerciseDetailView: View {
    @EnvironmentObject var store: AppStore
    let exercise: Exercise
    let onBack: () -> Void

    private var record: PersonalRecord? { store.personalRecords[exercise.id] }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: onBack) {
                    Text("‹ LIBRARY").font(.mono(11)).tracking(2).foregroundStyle(Deco.brassDeep)
                }
                Spacer()
            }
            .padding(.horizontal, 20).padding(.top, 8).padding(.bottom, 12)
            .overlay(alignment: .bottom) { Rectangle().fill(Deco.line).frame(height: 1) }

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Spire().frame(width: 140, height: 50)
                    Kicker(text: "\(exercise.muscle) · \(exercise.type.rawValue)", size: 9, tracking: 3)
                        .padding(.top, 6)
                    Text(exercise.name.uppercased()).font(.display(36)).tracking(3)
                        .foregroundStyle(Deco.ink).multilineTextAlignment(.center).padding(.top, 4)
                    HStack(spacing: 4) {
                        DiamondDot(size: 5); DiamondDot(size: 7); DiamondDot(size: 5)
                    }
                    .padding(.top, 6)

                    HatchFill().frame(height: 180).padding(.top, 22)
                        .overlay(Text("[ EXERCISE DEMONSTRATION ]").font(.mono(10)).tracking(3).foregroundStyle(Deco.brassDeep))
                        .overlay(Rectangle().stroke(Deco.brass, lineWidth: 1).padding(.top, 22))

                    detailSection(title: "FORM") {
                        Text(exercise.desc).font(.bodyText(14)).foregroundStyle(Deco.inkSoft).lineSpacing(5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    detailSection(title: "CUES") {
                        VStack(spacing: 0) {
                            ForEach(Array(exercise.cues.enumerated()), id: \.offset) { i, cue in
                                HStack(spacing: 12) {
                                    Text(String(format: "%02d", i + 1)).font(.display(14)).tracking(1).foregroundStyle(Deco.brass)
                                    Text(cue).font(.bodyText(14)).foregroundStyle(Deco.ink)
                                    Spacer()
                                }
                                .padding(.vertical, 8)
                                if i < exercise.cues.count - 1 { Rectangle().fill(Deco.lineSoft).frame(height: 1) }
                            }
                        }
                    }

                    recordCard.padding(.top, 24)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
        }
        .background(Deco.cream.ignoresSafeArea())
    }

    private func detailSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Kicker(text: title, size: 9, tracking: 3)
            Rectangle().fill(Deco.brass).frame(height: 1).padding(.top, 4).padding(.bottom, 10)
            content()
        }
        .padding(.top, 22)
    }

    private var recordCard: some View {
        VStack(spacing: 4) {
            Kicker(text: "Your Record", color: Deco.brassLight, size: 9, tracking: 3)
            if let pr = record {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text(trim(pr.weight)).font(.display(32)).tracking(2).foregroundStyle(Deco.cream)
                    Text("KG × \(pr.reps)").font(.mono(12)).foregroundStyle(Deco.cream)
                }
                Kicker(text: pr.date, color: Deco.brassLight, size: 9, tracking: 2)
            } else {
                Text("—").font(.display(32)).foregroundStyle(Deco.cream)
            }
        }
        .frame(maxWidth: .infinity).padding(16)
        .background(Deco.ink)
    }
}
