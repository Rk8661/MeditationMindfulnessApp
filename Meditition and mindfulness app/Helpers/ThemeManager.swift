import SwiftUI
import Combine

enum AppTheme: String, CaseIterable {
    case light  = "Light"
    case dark   = "Dark"
    case system = "System"
    
    var colorScheme: ColorScheme? {
        switch self {
        case .light:  return .light
        case .dark:   return .dark
        case .system: return nil
        }
    }
    
    var icon: String {
        switch self {
        case .light:  return "sun.max.fill"
        case .dark:   return "moon.fill"
        case .system: return "iphone"
        }
    }
}

final class ThemeManager: ObservableObject {
    
    @Published var currentTheme: AppTheme = .system {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: Constants.Storage.themeKey)
        }
    }
    
    init() {
        let saved = UserDefaults.standard.string(forKey: Constants.Storage.themeKey)
        currentTheme = AppTheme(rawValue: saved ?? "") ?? .system
    }
    
    func setTheme(_ theme: AppTheme) {
        currentTheme = theme
    }
}
