//
//  GuidedSession.swift
//  Meditition and mindfulness app
//
//  Created by Rohan Kumbhar on 08/06/26.
//

import Foundation

struct GuidedSession: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let duration: Int         // in minutes
    let category: String      // "Focus", "Sleep", "Stress Relief"
    let difficulty: String    // "Beginner", "Intermediate", "Advanced"
}
