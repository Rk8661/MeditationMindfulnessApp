//
//  LocalStorageService.swift
//  Meditition and mindfulness app
//
//  Created by Rohan Kumbhar on 15/06/26.
//

import Foundation

final class LocalStorageService {
    
    static let shared = LocalStorageService()
    
    private let defaults = UserDefaults.standard
    private init() {}
    
    func saveSessions(_ sessions: [MeditationSession]){
        if let encode = try? JSONEncoder().encode(sessions){
            
            
            defaults.set(encode, forKey: Constants.Storage.sessionKey)
        }
    }
    
    func loadSessions() -> [MeditationSession]? {
        guard let data = defaults.data(forKey: Constants.Storage.sessionKey),
              let decoded = try? JSONDecoder().decode([MeditationSession].self, from: data)
        else{ return[] }
        return decoded
        
    }
    
    func deleteSession(id: UUID , from sessions: inout [MeditationSession]){
        sessions.removeAll { $0.id == id}
        saveSessions(sessions)
    }
    
    func saveProfile(_ profile: UserProfile) {
        if let encoded = try? JSONEncoder().encode(profile) {
            defaults.set(encoded, forKey: Constants.Storage.userProfileKey)
        }
    }
    
    func loadProfile() -> UserProfile {
        guard let data = defaults.data(forKey: Constants.Storage.userProfileKey),
              let decoded = try? JSONDecoder().decode(UserProfile.self, from: data)
        else { return .default }
        return decoded
    
    }
    
    func saveTheme(_ theme: AppTheme){
        defaults.set(theme.rawValue, forKey : Constants.Storage.themeKey)
    }
    
    func loadTheme() -> AppTheme {
        guard let raw = defaults.string(forKey: Constants.Storage.themeKey),
                  let theme = AppTheme(rawValue: raw)
        else { return .system }
        return theme
    }
    
    func updateStreak(profile: inout UserProfile){
        let today = Calendar.current.startOfDay(for: Date())
        
        guard let last = profile.lastMeditationDate else {
            
            profile.currentStreak = 1
            profile.longestStreak = max(profile.longestStreak, 1)
            profile.lastMeditationDate = today
            saveProfile(profile)
            return
        }
        
        let lastDay = Calendar.current.startOfDay(for: last)
        let diff = Calendar.current.dateComponents([.day], from: lastDay, to: today).day ?? 0
        
        switch diff {
        case 0 :
          //  already meditated toda so no change
            break
        case  1:
            //consicutive day = increment streak by 1
            profile.currentStreak += 1
            profile.longestStreak = max(profile.longestStreak, profile.currentStreak)
            profile.lastMeditationDate = today
            
        default:
            // when streak broken-- reset to 1
            profile.currentStreak = 1
            profile.lastMeditationDate = today
        
        }
        
        saveProfile(profile)
        
    }
    func clearAll(){
        Constants.Storage.allKeys.forEach { defaults.removeObject(forKey: $0)
        }
    }
}

