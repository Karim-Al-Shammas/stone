import SwiftUI

@main
struct FitForgeApp: App {
    @StateObject private var store = AppStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .tint(Deco.brass)
        }
    }
}
