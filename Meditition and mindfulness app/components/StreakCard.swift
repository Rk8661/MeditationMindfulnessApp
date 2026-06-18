//
//  StreakCard.swift
//  Meditition and mindfulness app
//
//  Created by Rohan Kumbhar on 16/06/26.
//

import SwiftUI

struct StreakCard: View {
    
    let currentStreak: Int
    let longestStreak: Int
    
    var badge: Badge {
        Badge.current(for: currentStreak)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            
            // Top row — streak numbers
            HStack(spacing: 0) {
                streakStat(value: currentStreak, label: "Current Streak", icon: "flame.fill", color: .orange)
                
                Divider()
                    .frame(height: 40)
                    .padding(.horizontal, 8)
                
                streakStat(value: longestStreak, label: "Longest Streak", icon: "trophy.fill", color: .yellow)
            }
            
            Divider()
            
            // Badge row
            HStack(spacing: 12) {
                Image(systemName: badge.icon)
                    .font(.title2)
                    .foregroundColor(badge.color)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(badge.tier == .none ? "No Badge Yet" : "\(badge.title) Badge")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text(badge.tier == .none ? "Meditate 7 days to earn Bronze" : "Keep the streak going!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
        }
        .padding(Constants.UI.cardPadding)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(Constants.UI.cornerRadius)
    }
    
    @ViewBuilder
    private func streakStat(value: Int, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text("\(value)")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}
