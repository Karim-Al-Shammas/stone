import SwiftUI

struct ExercisePickerView: View {
    let onPick: (String) -> Void

    @State private var search = ""
    @State private var muscle: String?

    private var filtered: [Exercise] {
        Exercise.all.filter { ex in
            (muscle == nil || ex.muscle == muscle) &&
            (search.isEmpty || ex.name.localizedCaseInsensitiveContains(search))
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            StepCrown().fill(Deco.brass).frame(height: 14)
            VStack(spacing: 2) {
                Kicker(text: "Select", size: 9, tracking: 3)
                Text("ADD EXERCISE").font(.display(24)).tracking(3).foregroundStyle(Deco.ink)
            }
            .padding(.top, 14).padding(.bottom, 8)

            VStack(spacing: 8) {
                DecoSearchField(placeholder: "Search…", text: $search, fill: Deco.cream)
                MuscleChips(selected: $muscle)
            }
            .padding(.horizontal, 20)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(filtered) { ex in
                        Button { onPick(ex.id) } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(ex.name).font(.bodyText(14, .medium)).foregroundStyle(Deco.ink)
                                    Kicker(text: ex.muscle, size: 9, tracking: 1.5)
                                }
                                Spacer()
                                Text("+").font(.system(size: 14)).foregroundStyle(Deco.brass)
                                    .frame(width: 28, height: 28)
                                    .overlay(Rectangle().stroke(Deco.brass, lineWidth: 1))
                            }
                            .padding(.vertical, 12)
                            .contentShape(Rectangle())
                            .overlay(alignment: .bottom) { Rectangle().fill(Deco.lineSoft).frame(height: 1) }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.top, 4)
        }
        .background(Deco.paper.ignoresSafeArea())
        .overlay(alignment: .top) { Rectangle().fill(Deco.brass).frame(height: 2) }
        .presentationDetents([.fraction(0.85)])
    }
}
