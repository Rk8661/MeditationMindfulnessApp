//
//  constants.swift
//  Meditition and mindfulness app
//
//  Created by Rohan Kumbhar on 11/06/26.
//

import Foundation

enum Constants {
    

    enum Meditation {
        static let defaultGoalMinutes: Int = 10//  in minutes
        static let timerPresets : [Int] = [5, 10 ,15 ,20]
        static let defaultTimerDuration: Int = 10
    
    }
    
    enum Breathing {
        static let inhaleDuration: Double = 4.0//  in seconds
        static let holdDuration: Double =   4.0
        static let exhaleDuration: Double = 6.0
        static let cycleDuration: Double =  inhaleDuration + holdDuration + exhaleDuration
    }
    
    enum Streak {
        static let bronzeThreshold: Int = 7
        static let silverThreshold: Int = 15
        static let goldThreshold:   Int = 30
    }
    
    enum Storage {
        static let sessionKey =      "saved_session"
        static let userProfileKey =  "user_profile"
        static let themeKey =        "app_theme"
        static let allKeys: [String] = [sessionKey, userProfileKey, themeKey]
    }
    
    enum API {
        static let baseURL = "https://api.meditation-app.com"
        static let timeout: Double = 15.0
    }
    
    enum UI {
        static let cornerRadius: CGFloat = 16
        static let cardPadding: CGFloat = 16
        static let animationDuration: Double = 0.3
    }
    
    enum Quotes {
        static let daily: [String] = [
            
            "The mind is everything. What you think, you become.",
            "Peace comes from within. Do not seek it without.",
            "Breathe. Let go. And remind yourself that this very moment is the only one you know you have for sure.",
            "You are the sky. Everything else is just the weather.",
            "Almost everything will work again if you unplug it for a few minutes — including you.",
            "Within you, there is a stillness and a sanctuary to which you can retreat at any time.",
            "The present moment is the only moment available to us, and it is the door to all moments.",
            "Quiet the mind, and the soul will speak.",
            "Meditation is not about stopping thoughts, but recognizing that you are more than your thoughts.",
            "In the middle of difficulty lies opportunity — breathe through it.",
            "Your calm mind is the ultimate weapon against your challenges.",
            "Be where you are, not where you think you should be.",
            "Wherever you are, be all there.",
            "The thing about meditation is: you become more and more you.",
            "Rest in natural great peace, this exhausted mind."
            // total 15 quotes , total 365 days so if it is 200th day then we get 200 % 15 = 5 so we get the quote no 5
        ]
        static var todaysQuote: String {
            let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
            let index = max(0, (dayOfYear - 1) % daily.count)
            return daily[index]
        }

    }
}

