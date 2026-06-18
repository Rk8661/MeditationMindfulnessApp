//
//  UserProfile.swift
//  Meditition and mindfulness app
//
//  Created by Rohan Kumbhar on 08/06/26.
//

import Foundation

struct UserProfile: Codable {
    var username: String
    var meditationGoal: Int           // daily goal in minutes
    var currentStreak: Int
    var longestStreak: Int
    var lastMeditationDate: Date?
    
    // Computed — total minutes from session history passed in
    func totalMinutes(from sessions: [MeditationSession]) -> Int {
        sessions.reduce(0) { $0 + $1.duration }
    }
    
    // Computed — today's minutes
    func todayMinutes(from sessions: [MeditationSession]) -> Int {
        let today = Calendar.current.startOfDay(for: Date())
        return sessions
            .filter { Calendar.current.startOfDay(for: $0.date) == today }
            .reduce(0) { $0 + $1.duration }
    }
    
    // Default profile for first launch
    static let `default` = UserProfile(
        username: "Meditator",
        meditationGoal: 10,
        currentStreak: 0,
        longestStreak: 0,
        lastMeditationDate: nil
    )
}

