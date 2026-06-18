//
//  TimerControls.swift
//  Meditition and mindfulness app
//
//  Created by Rohan Kumbhar on 16/06/26.
//

import SwiftUI

struct TimerControls: View {
    
    let isRunning: Bool
    let isCompleted: Bool
    let onStart: () -> Void
    let onPause: () -> Void
    let onReset: () -> Void
    
    var body: some View {
        HStack(spacing: 24) {
            
            // Reset button
            controlButton(
                icon: "arrow.counterclockwise",
                label: "Reset",
                color: .secondary,
                action: onReset
            )
            
            // Start / Pause primary button
            Button(action: isRunning ? onPause : onStart) {
                ZStack {
                    Circle()
                        .fill(isCompleted ? Color.green : Color.purple)
                        .frame(width: 72, height: 72)
                        .shadow(color: (isCompleted ? Color.green : Color.purple).opacity(0.4), radius: 8)
                    
                    Image(systemName: isCompleted ? "checkmark" : (isRunning ? "pause.fill" : "play.fill"))
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
            .disabled(isCompleted)
            
            // Placeholder to balance layout
            controlButton(
                icon: "xmark",
                label: "Reset",
                color: .clear,
                action: {}
            )
            .hidden()
        }
    }
    
    @ViewBuilder
    private func controlButton(icon: String, label: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    Circle()
                        .fill(Color(.secondarySystemBackground))
                        .frame(width: 48, height: 48)
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(color)
                }
                Text(label)
                    .font(.caption2)
                    .foregroundColor(color)
            }
        }
    }
}
