//
//  SessionDetailView.swift
//  Meditition and mindfulness app
//
//  Created by Rohan Kumbhar on 16/06/26.
//
import SwiftUI

struct SessionDetailView: View {
    
    // MARK: - Environment
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var timerViewModel: TimerViewModel
    
    // MARK: - Properties
    let session: GuidedSession
    let isReadOnly: Bool
    
    @State private var showTimer: Bool = false
    
    init(session: GuidedSession, isReadOnly: Bool = false) {
        self.session = session
        self.isReadOnly = isReadOnly
    }
    
    var categoryColor: Color {
        switch session.category {
        case "Focus":         return .blue
        case "Sleep":         return .indigo
        case "Stress Relief": return .teal
        default:              return .purple
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // MARK: - Hero Header
                heroHeader
                
                // MARK: - Info Cards
                infoCards
                
                // MARK: - Description
                descriptionSection
                
                // MARK: - Start Button
                if !isReadOnly {
                    startButton
                }
                
                Spacer(minLength: 32)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showTimer) {
            timerSheet
        }
    }
    
    // MARK: - Hero Header
    private var heroHeader: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                .fill(
                    LinearGradient(
                        colors: [categoryColor.opacity(0.8), categoryColor.opacity(0.4)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(maxWidth: .infinity)
                .frame(height: 180)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(session.category.uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white.opacity(0.8))
                    .tracking(2)
                Text(session.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding()
        }
    }
    
    // MARK: - Info Cards
    private var infoCards: some View {
        HStack(spacing: 12) {
            infoCard(icon: "clock.fill",    value: DateFormatterHelper.durationString(session.duration), label: "Duration",   color: .purple)
            infoCard(icon: "speedometer",   value: session.difficulty,                                    label: "Difficulty", color: categoryColor)
            infoCard(icon: "tag.fill",      value: session.category,                                      label: "Category",   color: .orange)
        }
    }
    
    private func infoCard(icon: String, value: String, label: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
            Text(value)
                .font(.caption)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    // MARK: - Description
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("About this session")
                .font(.headline)
            Text(session.description)
                .font(.body)
                .foregroundColor(.secondary)
                .lineSpacing(6)
        }
    }
    
    // MARK: - Start Button
    private var startButton: some View {
        Button {
            timerViewModel.selectDuration(session.duration)
            showTimer = true
            Haptics.impact(.medium)
        } label: {
            HStack {
                Image(systemName: "play.fill")
                Text("Start Meditation")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(categoryColor)
            .foregroundColor(.white)
            .cornerRadius(Constants.UI.cornerRadius)
        }
    }
    
    // MARK: - Timer Sheet
    private var timerSheet: some View {
        NavigationStack {
            TimerSheetView(session: session)
                .environmentObject(timerViewModel)
                .environmentObject(sessionViewModel)
                .environmentObject(homeViewModel)
                .navigationTitle(session.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Close") {
                            showTimer = false
                            timerViewModel.resetTimer()
                        }
                    }
                }
        }
    }
}

// MARK: - Timer Sheet View
struct TimerSheetView: View {
    
    @EnvironmentObject var timerViewModel: TimerViewModel
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    let session: GuidedSession
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Progress Ring
            ZStack {
                ProgressRing(
                    progress: timerViewModel.progress,
                    size: 220,
                    lineWidth: 16,
                    color: .purple
                )
                Text(timerViewModel.timeString)
                    .font(.system(size: 48, weight: .thin, design: .rounded))
                    .foregroundColor(.primary)
            }
            
            // Completion message
            if timerViewModel.isCompleted {
                Text("Session Complete 🎉")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                    .transition(.scale.combined(with: .opacity))
            }
            
            Spacer()
            
            // Controls
            TimerControls(
                isRunning: timerViewModel.isRunning,
                isCompleted: timerViewModel.isCompleted,
                onStart: { timerViewModel.startTimer() },
                onPause: { timerViewModel.pauseTimer() },
                onReset: { timerViewModel.resetTimer() }
            )
            
            // Save session button
            if timerViewModel.isCompleted {
                Button {
                    let newSession = timerViewModel.buildSession(title: session.title)
                    sessionViewModel.saveSession(newSession)
                    homeViewModel.load()
                    dismiss()
                } label: {
                    Text("Save & Close")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(Constants.UI.cornerRadius)
                }
                .padding(.horizontal)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            Spacer(minLength: 32)
        }
        .padding()
        .animation(.easeInOut, value: timerViewModel.isCompleted)
    }
}
