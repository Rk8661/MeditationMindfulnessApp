import SwiftUI

enum BadgeTier {
    case none
    case bronze   // 7 days
    case silver   // 15 days
    case gold     // 30 days
}

struct Badge {
    let tier: BadgeTier
    let title: String
    let requiredDays: Int
    let icon: String      // SF Symbol name
    let color: Color
    
    // Derive current badge from streak count
    static func current (for Streak : Int ) -> Badge {
        switch Streak {
        case 30...:
            return Badge(tier : .gold  , title: "Gold",   requiredDays: 30, icon: "🥇", color: .yellow)
        case 15...:
            return Badge(tier : .silver, title: "Silver", requiredDays: 15, icon: "🥈",   color: .gray)
        case 7...:
            return Badge(tier : .bronze, title: "Bronze", requiredDays: 7,  icon: "🥉",  color: .brown)
        default:
            return Badge(tier: .none, title: "None", requiredDays: 7, icon: "circle.dashed", color: .clear)
        }
    }
    
    // All badges — for display in ProfileView or StreakCard
    static let all: [Badge] = [
        Badge(tier: .bronze, title: "Bronze", requiredDays: 7,  icon: "medal.fill",  color: .brown),
        Badge(tier: .silver, title: "Silver", requiredDays: 15, icon: "star.fill",   color: .gray),
        Badge(tier: .gold,   title: "Gold",   requiredDays: 30, icon: "trophy.fill", color: .yellow)
    ]
}
