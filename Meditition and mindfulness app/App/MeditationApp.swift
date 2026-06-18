import SwiftUI

@main
struct MeditationApp: App {
    
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var sessionViewModel = SessionViewModel()
    @StateObject private var timerViewModel = TimerViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    @StateObject private var themeManager = ThemeManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(homeViewModel)
                .environmentObject(sessionViewModel)
                .environmentObject(timerViewModel)
                .environmentObject(profileViewModel)
                .environmentObject(themeManager)
             
        }
    }
}
