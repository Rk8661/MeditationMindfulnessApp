//
//  ProfileViewModel.swift
//  Meditition and mindfulness app
//
//  Created by Rohan Kumbhar on 16/06/26.
//

import Foundation
import Combine

final class ProfileViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var profile: UserProfile = .default
    @Published var sessionHistory: [MeditationSession] = []
    
    // MARK: - Computed Properties
    var totalMinutes: Int {
        profile.totalMinutes(from: sessionHistory)
    }
    
    var totalSessions: Int {
        sessionHistory.count
    }
    
    var currentBadge: Badge {
        Badge.current(for: profile.currentStreak)
    }
    
    var allBadges: [Badge] {
        Badge.all
    }
    
    var nextBadge: Badge? {
        Badge.all.first { $0.requiredDays > profile.currentStreak }
    }
    
    var daysToNextBadge: Int? {
        guard let next = nextBadge else { return nil }
        return next.requiredDays - profile.currentStreak
    }
    
    // MARK: - Private
    private let storage = LocalStorageService.shared
    
    // MARK: - Init
    init() {
        load()
    }
    
    // MARK: - Load / Save
    func load() {
        profile = storage.loadProfile()
        sessionHistory = storage.loadSessions() ?? []
    }
    
    func saveUsername(_ name: String) {
        profile.username = name.trimmingCharacters(in: .whitespaces)
        storage.saveProfile(profile)
    }
    
    func saveMeditationGoal(_ goal: Int) {
        profile.meditationGoal = goal
        storage.saveProfile(profile)
    }
    
    // MARK: - Reset
    func resetProfile() {
        profile = .default
        sessionHistory = []
        storage.clearAll()
    }
}
