import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: AppStore
    @State private var tab: Tab = .home

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
    }
}
