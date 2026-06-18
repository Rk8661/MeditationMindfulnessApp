//
//  BreathingCircle.swift
//  Meditition and mindfulness app
//
//  Created by Rohan Kumbhar on 16/06/26.
//

import SwiftUI

struct BreathingCircle: View {
    
    let phase: BreathingPhase
    let size: CGFloat
    
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 0.6
    
    init(phase: BreathingPhase, size: CGFloat = 220) {
        self.phase = phase
        self.size = size
    }
    
    var phaseColor: Color {
        switch phase {
        case .inhale: return Color(hex: "E8A598")
        case .hold:   return Color(hex: "F2A07B")
        case .exhale: return Color(hex: "8DB596")
        case .idle:   return Color(hex: "C9B8B2")
        }
    }
    
    var body: some View {
        ZStack {
            // Outer glow ring
            Circle()
                .fill(phaseColor.opacity(0.15))
                .frame(width: size * 1.3, height: size * 1.3)
                .scaleEffect(scale)
            
            // Mid ring
            Circle()
                .fill(phaseColor.opacity(0.25))
                .frame(width: size * 1.1, height: size * 1.1)
                .scaleEffect(scale)
            
            // Main circle
            Circle()
                .fill(
                    RadialGradient(
                        colors: [phaseColor.opacity(0.8), phaseColor.opacity(0.4)],
                        center: .center,
                        startRadius: 0,
                        endRadius: size / 2
                    )
                )
                .frame(width: size, height: size)
                .scaleEffect(scale)
                .opacity(opacity)
            
            // Phase label
            Text(phase.label)
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
        }
        .onChange(of: phase) { newPhase in
            animateForPhase(newPhase)
        }
        .onAppear {
            animateForPhase(phase)
        }
    }
    
    private func animateForPhase(_ phase: BreathingPhase) {
        switch phase {
        case .inhale:
            withAnimation(.easeIn(duration: Constants.Breathing.inhaleDuration)) {
                scale = 1.3
                opacity = 1.0
            }
        case .hold:
            withAnimation(.easeInOut(duration: Constants.Breathing.holdDuration)) {
                scale = 1.3
                opacity = 0.9
            }
        case .exhale:
            withAnimation(.easeOut(duration: Constants.Breathing.exhaleDuration)) {
                scale = 1.0
                opacity = 0.6
            }
        case .idle:
            withAnimation(.easeInOut(duration: 0.5)) {
                scale = 1.0
                opacity = 0.6
            }
        }
    }
}

// MARK: - Breathing Phase
enum BreathingPhase {
    case idle
    case inhale
    case hold
    case exhale
    
    var label: String {
        switch self {
        case .idle:   return "Ready"
        case .inhale: return "Inhale"
        case .hold:   return "Hold"
        case .exhale: return "Exhale"
        }
    }
}
