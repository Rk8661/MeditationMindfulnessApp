import Foundation

enum DateFormatterHelper {
    
    // "Jun 8, 2026"
    static let displayDate: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        return f
    }()
    
    // "Monday"
    static let weekdayName: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "EEEE"
        return f
    }()
    
    // "8 Jun"
    static let shortDate: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d MMM"
        return f
    }()
    
    // "10:30 AM"
    static let timeOnly: DateFormatter = {
        let f = DateFormatter()
        f.timeStyle = .short
        f.dateStyle = .none
        return f
    }()
    
    // Convenience function
    static func format(_ date: Date, using formatter: DateFormatter) -> String {
        formatter.string(from: date)
    }
    
    // "2 hours ago", "Just now", "Yesterday"
    static func relativeString(from date: Date) -> String {
        let now = Date()
        let diff = Calendar.current.dateComponents([.minute, .hour, .day], from: date, to: now)
        
        if let day = diff.day, day >= 2   { return "\(day) days ago" }
        if let day = diff.day, day == 1   { return "Yesterday" }
        if let hour = diff.hour, hour >= 1 { return "\(hour)h ago" }
        if let min = diff.minute, min >= 1 { return "\(min)m ago" }
        return "Just now"
    }
    
    // "10 min" from an Int duration
    static func durationString(_ minutes: Int) -> String {
        minutes == 1 ? "1 min" : "\(minutes) min"
    }
}
