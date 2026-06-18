//
//  Haptics.swift
//  Meditition and mindfulness app
//
//  Created by Rohan Kumbhar on 16/06/26.
//
import UIKit

enum Haptics {
    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
