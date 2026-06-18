import Foundation

final class APIService {
    
    static let shared = APIService()
    private init() {}
    
    // MARK: - Fetch Guided Sessions
    
    func fetchMeditationSessions() async throws -> [GuidedSession] {
        // Load from local JSON bundle
        guard let url = Bundle.main.url(forResource: "sessions", withExtension: "json") else {
            throw APIError.fileNotFound
        }
        
        let data = try Data(contentsOf: url)
        let sessions = try JSONDecoder().decode([GuidedSession].self, from: data)
        
        // Simulate network delay so loading state is visible
        try await Task.sleep(nanoseconds: 800_000_000)   // 0.8 seconds
        
        return sessions
    }
}

// MARK: - API Errors

enum APIError: LocalizedError {
    case fileNotFound
    case decodingFailed
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:   return "Session data file not found."
        case .decodingFailed: return "Failed to decode session data."
        }
    }
}
