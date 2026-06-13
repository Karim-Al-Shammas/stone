import SwiftUI

struct ExercisePickerView: View {
    let onPick: (String) -> Void

    @Environment(\.dismiss) private var dismiss
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
            VStack(alignment: .leading, spacing: 12) {
                SearchField(placeholder: "Search exercises...", text: $search)
                MuscleFilterRow(selected: $muscle)

                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(filtered) { ex in
                            Button { onPick(ex.id) } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(ex.name).font(.system(size: 14, weight: .medium))
                                        Text(ex.muscle).font(.system(size: 12)).foregroundStyle(Theme.sub)
                                    }
                                    Spacer()
                                    Image(systemName: "plus").foregroundStyle(Theme.blue)
                                }
                                .padding(.vertical, 12)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            Divider()
                        }
                    }
                }
            }
            .padding(16)
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { dismiss() } label: { Image(systemName: "xmark") }
                }
            }
        }
        .presentationDetents([.large])
    }
}
