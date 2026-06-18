import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var profile: UserProfile = .default
    @Published var todaySessions: [MeditationSession] = []
    @Published var dailyQuote: String = ""
    
    // MARK: - Computed Properties
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:  return "Good Morning"
        case 12..<17: return "Good Afternoon"
        case 17..<21: return "Good Evening"
        default:      return "Good Night"
        }
    }
    
    var todayMinutes: Int {
        profile.todayMinutes(from: todaySessions)
    }
    
    var progressValue: Double {
        guard profile.meditationGoal > 0 else { return 0 }
        return min(Double(todayMinutes) / Double(profile.meditationGoal), 1.0)
    }
    
    var currentBadge: Badge {
        Badge.current(for: profile.currentStreak)
    }
    
    // MARK: - Private
    private let storage = LocalStorageService.shared
    
    // MARK: - Init
    init() {
        load()
    }
    
    // MARK: - Load
    func load() {
        profile = storage.loadProfile()
        let allSessions = storage.loadSessions() ?? []
        let today = Calendar.current.startOfDay(for: Date())
        todaySessions = allSessions.filter {
            Calendar.current.startOfDay(for: $0.date) == today
        }
        dailyQuote = Constants.Quotes.todaysQuote
    }
}
