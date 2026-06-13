import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }
            WorkoutsView()
                .tabItem { Label("Workouts", systemImage: "dumbbell.fill") }
            ProgressTab()
                .tabItem { Label("Progress", systemImage: "chart.bar.fill") }
            ExercisesView()
                .tabItem { Label("Exercises", systemImage: "book.fill") }
            TimerView()
                .tabItem { Label("Timer", systemImage: "timer") }
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
