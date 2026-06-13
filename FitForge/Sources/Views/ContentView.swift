import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: AppStore
    @State private var tab: Tab = .home

    private static let screenEnv = ProcessInfo.processInfo.environment["FF_SCREEN"]

    var body: some View {
        ZStack(alignment: .bottom) {
            Deco.cream.ignoresSafeArea()

            Group {
                switch tab {
                case .home:     HomeView()
                case .workouts: WorkoutsView()
                case .progress: ProgressTab()
                case .library:  LibraryView()
                }
            }

            ChryslerTabBar(selected: $tab)
                .ignoresSafeArea(edges: .bottom)
        }
        .fullScreenCover(isPresented: Binding(
            get: { store.active != nil },
            set: { if !$0 { store.active = nil } }
        )) {
            if let active = store.active {
                ActiveWorkoutView(active: active)
            }
        }
        .onAppear(perform: applyScreenEnv)
    }

    /// Debug-only: open a specific screen via the FF_SCREEN launch env var.
    private func applyScreenEnv() {
        switch Self.screenEnv {
        case "workouts": tab = .workouts
        case "progress": tab = .progress
        case "library": tab = .library
        case "active":
            store.startWorkout()
            store.active?.addExercise("bench")
            store.active?.addExercise("incline-db")
            store.active?.toggleSet(exerciseIndex: 0, setIndex: 0)
        default: break
        }
    }
}
