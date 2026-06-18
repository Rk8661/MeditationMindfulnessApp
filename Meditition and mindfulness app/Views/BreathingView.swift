import SwiftUI

struct BreathingView: View {
    
    // MARK: - Environment
    @EnvironmentObject var sessionViewModel: SessionViewModel
    
    // MARK: - State
    @State private var phase: BreathingPhase = .idle
    @State private var isActive: Bool = false
    @State private var countdown: Int = 0
    @State private var cycleCount: Int = 0
    @State private var totalCycles: Int = 3
    @State private var isCompleted: Bool = false
    @State private var animateIn: Bool = false
    
    @State private var timer: Timer? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "FDF6F0")
                    .ignoresSafeArea()
                
                Circle()
                    .fill(Color(hex: "F2C4B0").opacity(0.3))
                    .frame(width: 280, height: 280)
                    .blur(radius: 70)
                    .offset(x: -100, y: -180)
                
                Circle()
                    .fill(Color(hex: "E8A598").opacity(0.2))
                    .frame(width: 220, height: 220)
                    .blur(radius: 60)
                    .offset(x: 110, y: 220)
                
                VStack(spacing: 40) {
                    
                    Spacer()
                    
                    if isActive || isCompleted {
                        Text(isCompleted ? "Session Complete 🎉" : "Cycle \(cycleCount + 1) of \(totalCycles)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(Color(hex: "9E7B74"))
                            .transition(.opacity)
                    }
                    
                    BreathingCircle(phase: phase)
                    
                    if isActive {
                        Text("\(countdown)")
                            .font(.system(size: 36, weight: .thin, design: .rounded))
                            .foregroundColor(Color(hex: "9E7B74"))
                            .contentTransition(.numericText())
                            .animation(.easeInOut, value: countdown)
                    }
                    
                    Spacer()
                    
                    if !isActive && !isCompleted {
                        cyclePicker
                    }
                    
                    controlButtons
                    
                    Spacer(minLength: 32)
                }
                .offset(y: animateIn ? 0 : 20)
                .opacity(animateIn ? 1 : 0)
            }
            .navigationTitle("Breathing")
            .navigationBarTitleDisplayMode(.large)
            .animation(.easeInOut(duration: 0.3), value: isActive)
            .animation(.easeInOut(duration: 0.3), value: isCompleted)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    animateIn = true
                }
            }
        }
    }
    
    // MARK: - Cycle Picker
    private var cyclePicker: some View {
        VStack(spacing: 10) {
            Text("Number of cycles")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(Color(hex: "9E7B74"))
            HStack(spacing: 12) {
                ForEach([3, 5, 7], id: \.self) { count in
                    Button {
                        totalCycles = count
                        Haptics.impact(.light)
                    } label: {
                        Text("\(count)")
                            .fontWeight(.semibold)
                            .frame(width: 54, height: 42)
                            .background(
                                Group {
                                    if totalCycles == count {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(LinearGradient(
                                                colors: [Color(hex: "E8A598"), Color(hex: "F2A07B")],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ))
                                            .shadow(color: Color(hex: "E8A598").opacity(0.35), radius: 8, x: 0, y: 4)
                                    } else {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(hex: "FFFAF7"))
                                            .shadow(color: Color(hex: "E8A598").opacity(0.1), radius: 4, x: 0, y: 2)
                                    }
                                }
                            )
                            .foregroundColor(totalCycles == count ? .white : Color(hex: "2D2320"))
                    }
                }
            }
        }
    }
    
    // MARK: - Control Buttons
    private var controlButtons: some View {
        HStack(spacing: 20) {
            if isActive || isCompleted {
                Button {
                    stopSession()
                } label: {
                    Text("Stop")
                        .fontWeight(.semibold)
                        .frame(width: 120)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                                .fill(Color(hex: "FFFAF7"))
                                .shadow(color: Color(hex: "E8A598").opacity(0.12), radius: 6, x: 0, y: 3)
                        )
                        .foregroundColor(Color(hex: "2D2320"))
                }
            }
            
            if !isActive {
                Button {
                    isCompleted ? resetSession() : startSession()
                } label: {
                    Text(isCompleted ? "Again" : "Start")
                        .fontWeight(.semibold)
                        .frame(width: 120)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                                .fill(LinearGradient(
                                    colors: [Color(hex: "8DB596"), Color(hex: "6A9E75")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ))
                                .shadow(color: Color(hex: "8DB596").opacity(0.35), radius: 10, x: 0, y: 5)
                        )
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    // MARK: - Session Control
    private func startSession() {
        isCompleted = false
        cycleCount = 0
        isActive = true
        Haptics.impact(.medium)
        runCycle()
    }
    
    private func stopSession() {
        timer?.invalidate()
        timer = nil
        isActive = false
        phase = .idle
        Haptics.impact(.light)
    }
    
    private func resetSession() {
        stopSession()
        isCompleted = false
        cycleCount = 0
    }
    
    // MARK: - Breathing Cycle
    private func runCycle() {
        guard isActive && cycleCount < totalCycles else {
            completeSession()
            return
        }
        
        phase = .inhale
        countdown = Int(Constants.Breathing.inhaleDuration)
        startCountdown(duration: Constants.Breathing.inhaleDuration) {
            
            self.phase = .hold
            self.countdown = Int(Constants.Breathing.holdDuration)
            self.startCountdown(duration: Constants.Breathing.holdDuration) {
                
                self.phase = .exhale
                self.countdown = Int(Constants.Breathing.exhaleDuration)
                self.startCountdown(duration: Constants.Breathing.exhaleDuration) {
                    self.cycleCount += 1
                    self.runCycle()
                }
            }
        }
    }
    
    private func startCountdown(duration: Double, completion: @escaping () -> Void) {
        var remaining = Int(duration)
        countdown = remaining
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
            remaining -= 1
            self.countdown = remaining
            if remaining <= 0 {
                t.invalidate()
                completion()
            }
        }
    }
    
    // MARK: - Completion
    private func completeSession() {
        isActive = false
        isCompleted = true
        phase = .idle
        Haptics.notification(.success)
        
        let session = MeditationSession(
            id: UUID(),
            title: "Breathing Exercise",
            duration: Int(Constants.Breathing.cycleDuration * Double(totalCycles) / 60),
            date: Date(),
            type: "Breathing"
        )
        sessionViewModel.saveSession(session)
    }
}
