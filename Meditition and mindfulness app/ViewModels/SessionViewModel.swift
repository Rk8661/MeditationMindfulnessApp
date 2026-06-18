//
//  SessionViewModel.swift
//  Meditition and mindfulness app
//
//  Created by Rohan Kumbhar on 16/06/26.
//

import Foundation
import Combine

final class SessionViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var guidedSessions: [GuidedSession] = []
    @Published var sessionHistory: [MeditationSession] = []
    @Published var searchText: String = ""
    @Published var selectedCategory: String = "All"
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // MARK: - Computed Properties
    var categories: [String] {
        ["All", "Focus", "Sleep", "Stress Relief"]
    }
    
    var filteredSessions: [GuidedSession] {
        guidedSessions.filter { session in
            let matchesCategory = selectedCategory == "All" || session.category == selectedCategory
            let matchesSearch = searchText.isEmpty || session.title.localizedCaseInsensitiveContains(searchText)
            return matchesCategory && matchesSearch
        }
    }
    
    var totalMinutesMeditated: Int {
        sessionHistory.reduce(0) { $0 + $1.duration }
    }
    
    // MARK: - Private
    private let api = APIService.shared
    private let storage = LocalStorageService.shared
    
    // MARK: - Init
    init() {
        sessionHistory = storage.loadSessions() ?? []
        Task { await fetchSessions() }
    }
    
    // MARK: - API
    @MainActor
    func fetchSessions() async {
        isLoading = true
        errorMessage = nil
        do {
            guidedSessions = try await api.fetchMeditationSessions()
        } catch {
            errorMessage = "Failed to load sessions. Please try again."
        }
        isLoading = false
    }
    
    // MARK: - Session History
    func saveSession(_ session: MeditationSession) {
        sessionHistory.insert(session, at: 0)   // newest first
        storage.saveSessions(sessionHistory)
    }
    
    func deleteSession(id: UUID) {
        storage.deleteSession(id: id, from: &sessionHistory)
    }
    
    func clearHistory() {
        sessionHistory = []
        storage.saveSessions(sessionHistory)
    }
}
