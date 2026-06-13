import SwiftUI

struct ExercisesView: View {
    @State private var search = ""
    @State private var muscle: String?

    private var filtered: [Exercise] {
        Exercise.all.filter { ex in
            (muscle == nil || ex.muscle == muscle) &&
            (search.isEmpty || ex.name.localizedCaseInsensitiveContains(search))
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Exercise Library").font(.system(size: 28, weight: .heavy)).padding(.bottom, 12)
                    SearchField(placeholder: "Search exercises...", text: $search)
                        .padding(.bottom, 12)
                    MuscleFilterRow(selected: $muscle)
                        .padding(.bottom, 12)

                    ForEach(filtered) { ex in
                        NavigationLink {
                            ExerciseDetailView(exercise: ex)
                        } label: {
                            ExerciseListItem(exercise: ex)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(16)
            }
            .background(Theme.bg)
        }
    }
}

struct ExerciseListItem: View {
    let exercise: Exercise

    var body: some View {
        HStack(spacing: 10) {
            Text(exercise.muscle.uppercased())
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(Theme.blue)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(Color(hex: 0xF0F7FF))
                .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            VStack(alignment: .leading, spacing: 2) {
                Text(exercise.name).font(.system(size: 15, weight: .medium))
                Text(exercise.type.rawValue.capitalized).font(.system(size: 12)).foregroundStyle(Theme.sub)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(Theme.sub).font(.system(size: 13))
        }
        .padding(14)
        .cardStyle()
        .padding(.bottom, 6)
    }
}

struct ExerciseDetailView: View {
    let exercise: Exercise

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(exercise.muscle)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 12)
                    .background(Theme.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                Text(exercise.name).font(.system(size: 22, weight: .bold))
                Text(exercise.desc).font(.system(size: 15)).foregroundStyle(Color(hex: 0x555555)).lineSpacing(4)

                VStack(alignment: .leading, spacing: 4) {
                    Text("TYPE").font(.system(size: 12, weight: .semibold)).foregroundStyle(Theme.blue)
                    Text(exercise.type.rawValue.capitalized).font(.system(size: 14))
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(hex: 0xF0F7FF))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            .padding(16)
        }
        .background(Theme.bg)
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
