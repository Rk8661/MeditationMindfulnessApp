import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            HomeView()
                .tabItem {
                    Label("Home", systemImage: selectedTab == 0 ? "house.fill" : "house")
                }
                .tag(0)
            
            NavigationStack {
                SessionsView()
            }
            .tabItem {
                Label("Sessions", systemImage: selectedTab == 1 ? "play.circle.fill" : "play.circle")
            }
            .tag(1)
            
            BreathingView()
                .tabItem {
                    Label("Breathe", systemImage: selectedTab == 2 ? "wind" : "wind")
                }
                .tag(2)
            
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: selectedTab == 3 ? "person.fill" : "person")
            }
            .tag(3)
        }
        .accentColor(.purple)
        .preferredColorScheme(themeManager.currentTheme.colorScheme)  // moved here
        .id(themeManager.currentTheme)                                  // force re-render
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    ContentView()
        .environmentObject(HomeViewModel())
        .environmentObject(SessionViewModel())
        .environmentObject(TimerViewModel())
        .environmentObject(ProfileViewModel())
        .environmentObject(ThemeManager())
}
