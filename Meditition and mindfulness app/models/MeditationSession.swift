//
//  MeditationSession.swift
//  Meditition and mindfulness app
//
//  Created by Rohan Kumbhar on 08/06/26.
//

import Foundation

struct MeditationSession: Codable, Identifiable {
    let id: UUID
    let title: String
    let duration: Int         // in minutes
    let date: Date
    let type: String          // "Guided", "Timer", "Breathing"
}
