//
//  TimerViewModel.swift
//  Meditition and mindfulness app
//
//  Created by Rohan Kumbhar on 16/06/26.
//

import Foundation
import Combine
import UIKit


final class TimerViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var selectedDuration: Int = Constants.Meditation.defaultTimerDuration   // minutes
    @Published var timeRemaining: Int = Constants.Meditation.defaultTimerDuration * 60 // seconds
    @Published var isRunning: Bool = false
    @Published var isCompleted: Bool = false
    
    // MARK: - Computed Properties
    var progress: Double {
        let total = Double(selectedDuration * 60)
        guard total > 0 else { return 0 }
        return 1.0 - (Double(timeRemaining) / total)
    }
    
    var timeString: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var presets: [Int] {
        Constants.Meditation.timerPresets
    }
    
    // MARK: - Private
    private var timer: AnyCancellable?
    
    // MARK: - Timer Controls
    func startTimer() {
        guard !isRunning else { return }
        isRunning = true
        isCompleted = false
        
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.completeSession()
                }
            }
    }
    
    func pauseTimer() {
        isRunning = false
        timer?.cancel()
        timer = nil
    }
    
    func resetTimer() {
        pauseTimer()
        isCompleted = false
        timeRemaining = selectedDuration * 60
    }
    
    func selectDuration(_ minutes: Int) {
        selectedDuration = minutes
        resetTimer()
    }
    
    // MARK: - Completion
    private func completeSession() {
        pauseTimer()
        isCompleted = true
        Haptics.notification(.success)
    }
    
    // MARK: - Session Builder
    func buildSession(title: String = "Timer Session") -> MeditationSession {
        MeditationSession(
            id: UUID(),
            title: title,
            duration: selectedDuration,
            date: Date(),
            type: "Timer"
        )
    }
    
    // MARK: - Cleanup
    deinit {
        timer?.cancel()
    }
}
