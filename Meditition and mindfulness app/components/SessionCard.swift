//
//  SessionCard.swift
//  Meditition and mindfulness app
//
//  Created by Rohan Kumbhar on 16/06/26.
//

import SwiftUI

struct SessionCard: View {
    
    let session: GuidedSession
    
    var categoryColor: Color {
        switch session.category {
        case "Focus":        return .blue
        case "Sleep":        return .indigo
        case "Stress Relief": return .teal
        default:             return .purple
        }
    }
    
    var difficultyColor: Color {
        switch session.difficulty {
        case "Beginner":     return .green
        case "Intermediate": return .orange
        case "Advanced":     return .red
        default:             return .gray
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Top row — category badge + duration
            HStack {
                Text(session.category)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(categoryColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(categoryColor.opacity(0.15))
                    .clipShape(Capsule())
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption)
                    Text(DateFormatterHelper.durationString(session.duration))
                        .font(.caption)
                }
                .foregroundColor(.secondary)
            }
            
            // Title
            Text(session.title)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(2)
            
            // Description
            Text(session.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            // Bottom row — difficulty
            HStack {
                Circle()
                    .fill(difficultyColor)
                    .frame(width: 8, height: 8)
                Text(session.difficulty)
                    .font(.caption)
                    .foregroundColor(difficultyColor)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(Constants.UI.cardPadding)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(Constants.UI.cornerRadius)
    }
}
