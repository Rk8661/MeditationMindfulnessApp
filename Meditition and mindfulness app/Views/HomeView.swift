import SwiftUI

struct HomeView: View {
    
    // MARK: - Environment
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @EnvironmentObject var timerViewModel: TimerViewModel
    
    // MARK: - State
    @State private var navigateToTimer: Bool = false
    @State private var selectedQuickStartMinutes: Int = 5
    @State private var animateHeader: Bool = false
    @State private var animateCards: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - Background
                Color(hex: "FDF6F0")
                    .ignoresSafeArea()
                
                // Soft ambient blobs
                Circle()
                    .fill(Color(hex: "F2C4B0").opacity(0.4))
                    .frame(width: 280, height: 280)
                    .blur(radius: 70)
                    .offset(x: 120, y: -180)
                
                Circle()
                    .fill(Color(hex: "E8A598").opacity(0.25))
                    .frame(width: 220, height: 220)
                    .blur(radius: 60)
                    .offset(x: -100, y: 200)
                
                // MARK: - Content
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        headerSection
                        quoteSection
                        progressSection
                        streakSection
                        quickStartSection
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                homeViewModel.load()
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    animateHeader = true
                }
                withAnimation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.15)) {
                    animateCards = true
                }
            }
        }
    }
    
    // MARK: - Header
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(homeViewModel.greeting)
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "9E7B74"))
                Text(homeViewModel.profile.username)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "2D2320"))
            }
            .offset(y: animateHeader ? 0 : -16)
            .opacity(animateHeader ? 1 : 0)
            
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "E8A598"), Color(hex: "F2C4B0")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                    .shadow(color: Color(hex: "E8A598").opacity(0.4), radius: 8, x: 0, y: 4)
                
                Text(String(homeViewModel.profile.username.prefix(1)).uppercased())
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .offset(y: animateHeader ? 0 : -16)
            .opacity(animateHeader ? 1 : 0)
        }
        .padding(.top, 8)
    }
    
    // MARK: - Quote Section
    private var quoteSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("Daily Inspiration", icon: "sparkles")
            
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading, spacing: 10) {
                    Image(systemName: "quote.opening")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color(hex: "E8A598").opacity(0.5))
                    
                    Text(homeViewModel.dailyQuote)
                        .font(.system(size: 16, weight: .medium, design: .serif))
                        .foregroundColor(Color(hex: "2D2320").opacity(0.85))
                        .italic()
                        .lineSpacing(7)
                    
                    HStack {
                        Spacer()
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "E8A598"), Color(hex: "F2A07B")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 36, height: 3)
                            .cornerRadius(2)
                    }
                }
                .padding(20)
                
                Image(systemName: "sparkle")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "F2A07B").opacity(0.4))
                    .padding(16)
            }
            .background(
                RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "FFFAF7"), Color(hex: "FDF0E8")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Color(hex: "E8A598").opacity(0.15), radius: 10, x: 0, y: 4)
            )
        }
        .offset(y: animateCards ? 0 : 24)
        .opacity(animateCards ? 1 : 0)
    }
    // MARK: - Progress Section
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("Today's Progress", icon: "chart.bar.fill")
            
            HStack(spacing: 20) {
                ZStack {
                    ProgressRing(
                        progress: homeViewModel.progressValue,
                        size: 110,
                        lineWidth: 10,
                        color: Color(hex: "E8A598"),
                        showLabel: false
                    )
                    VStack(spacing: 2) {
                        Text("\(Int(homeViewModel.progressValue * 100))%")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "2D2320"))
                        Text("done")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(Color(hex: "9E7B74"))
                    }
                }
                
                VStack(alignment: .leading, spacing: 14) {
                    statRow(
                        icon: "clock.fill",
                        color: Color(hex: "E8A598"),
                        value: "\(homeViewModel.todayMinutes) min",
                        label: "Meditated today"
                    )
                    statRow(
                        icon: "target",
                        color: Color(hex: "F2A07B"),
                        value: "\(homeViewModel.profile.meditationGoal) min",
                        label: "Daily goal"
                    )
                    statRow(
                        icon: "checkmark.seal.fill",
                        color: Color(hex: "8DB596"),
                        value: "\(homeViewModel.todaySessions.count) sessions",
                        label: "Completed"
                    )
                }
            }
            .padding(Constants.UI.cardPadding)
            .background(blushCard)
        }
        .offset(y: animateCards ? 0 : 24)
        .opacity(animateCards ? 1 : 0)
        .animation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.1), value: animateCards)
    }
    
    // MARK: - Streak Section
    private var streakSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("Streak", icon: "flame.fill")
            
            HStack(spacing: 10) {
                streakTile(emoji: "🔥", value: "\(homeViewModel.profile.currentStreak)", label: "Current", tint: Color(hex: "FDDCB5"))
                streakTile(emoji: "🏆", value: "\(homeViewModel.profile.longestStreak)", label: "Longest", tint: Color(hex: "FCE4B0"))
                
                let badge = Badge.current(for: homeViewModel.profile.currentStreak)
                VStack(spacing: 6) {
                    Image(systemName: badge.icon)
                        .font(.title2)
                        .foregroundColor(badge.color)
                    Text(badge.tier == .none ? "No Badge" : badge.title)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "9E7B74"))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(hex: "FDF0E8"))
                        .shadow(color: Color(hex: "E8A598").opacity(0.1), radius: 6, x: 0, y: 3)
                )
            }
        }
        .offset(y: animateCards ? 0 : 24)
        .opacity(animateCards ? 1 : 0)
        .animation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.2), value: animateCards)
    }
    
    // MARK: - Quick Start Section
    private var quickStartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("Quick Start", icon: "bolt.fill")
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(timerViewModel.presets, id: \.self) { minutes in
                    quickStartButton(minutes: minutes)
                }
            }
            
            NavigationLink(
                destination: QuickStartTimerView()
                    .environmentObject(timerViewModel)
                    .environmentObject(sessionViewModel)
                    .environmentObject(homeViewModel),
                isActive: $navigateToTimer
            ) {
                EmptyView()
            }
        }
        .offset(y: animateCards ? 0 : 24)
        .opacity(animateCards ? 1 : 0)
        .animation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.3), value: animateCards)
    }
    
    // MARK: - Quick Start Button
    private func quickStartButton(minutes: Int) -> some View {
        Button {
            selectedQuickStartMinutes = minutes
            timerViewModel.selectDuration(minutes)
            Haptics.impact(.medium)
            navigateToTimer = true
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "E8A598").opacity(0.2))
                        .frame(width: 38, height: 38)
                    Image(systemName: "timer")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color(hex: "E8A598"))
                }
                VStack(alignment: .leading, spacing: 1) {
                    Text("\(minutes) min")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "2D2320"))
                    Text("meditation")
                        .font(.caption2)
                        .foregroundColor(Color(hex: "9E7B74"))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(Color(hex: "9E7B74").opacity(0.6))
            }
            .padding(14)
            .background(blushCard)
        }
    }
    
    // MARK: - Helpers
    private var blushCard: some View {
        RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
            .fill(Color(hex: "FFFAF7"))
            .shadow(color: Color(hex: "E8A598").opacity(0.15), radius: 10, x: 0, y: 4)
    }
    
    private func sectionLabel(_ text: String, icon: String) -> some View {
        Label(text, systemImage: icon)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(Color(hex: "9E7B74"))
            .textCase(.uppercase)
            .tracking(1)
    }
    
    private func statRow(icon: String, color: Color, value: String, label: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)
            VStack(alignment: .leading, spacing: 1) {
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "2D2320"))
                Text(label)
                    .font(.caption2)
                    .foregroundColor(Color(hex: "9E7B74"))
            }
        }
    }
    
    private func streakTile(emoji: String, value: String, label: String, tint: Color) -> some View {
        VStack(spacing: 6) {
            Text(emoji)
                .font(.title2)
            Text(value)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "2D2320"))
            Text(label)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(Color(hex: "9E7B74"))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(tint.opacity(0.4))
                .shadow(color: tint.opacity(0.3), radius: 6, x: 0, y: 3)
        )
    }
}

// MARK: - Quick Start Timer View
struct QuickStartTimerView: View {
    
    @EnvironmentObject var timerViewModel: TimerViewModel
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var animatePulse: Bool = false
    
    var body: some View {
        ZStack {
            Color(hex: "FDF6F0")
                .ignoresSafeArea()
            
            Circle()
                .fill(Color(hex: "F2C4B0").opacity(0.35))
                .frame(width: 320, height: 320)
                .blur(radius: 60)
                .scaleEffect(animatePulse ? 1.15 : 1.0)
                .animation(
                    timerViewModel.isRunning
                    ? .easeInOut(duration: 2.5).repeatForever(autoreverses: true)
                    : .easeInOut(duration: 0.4),
                    value: animatePulse
                )
            
            VStack(spacing: 48) {
                Spacer()
                
                ZStack {
                    ProgressRing(
                        progress: timerViewModel.progress,
                        size: 240,
                        lineWidth: 14,
                        color: Color(hex: "E8A598"),
                        showLabel: false
                    )
                    VStack(spacing: 6) {
                        Text(timerViewModel.timeString)
                            .font(.system(size: 52, weight: .thin, design: .rounded))
                            .foregroundColor(Color(hex: "2D2320"))
                        Text(timerViewModel.isCompleted ? "Complete!" : timerViewModel.isRunning ? "Focus..." : "Ready")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "9E7B74"))
                    }
                }
                
                if timerViewModel.isCompleted {
                    Text("Session Complete 🎉")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "8DB596"))
                        .transition(.scale.combined(with: .opacity))
                }
                
                Spacer()
                
                TimerControls(
                    isRunning: timerViewModel.isRunning,
                    isCompleted: timerViewModel.isCompleted,
                    onStart: {
                        timerViewModel.startTimer()
                        animatePulse = true
                    },
                    onPause: {
                        timerViewModel.pauseTimer()
                        animatePulse = false
                    },
                    onReset: {
                        timerViewModel.resetTimer()
                        animatePulse = false
                    }
                )
                
                if timerViewModel.isCompleted {
                    Button {
                        let newSession = timerViewModel.buildSession(title: "Quick Start Session")
                        sessionViewModel.saveSession(newSession)
                        homeViewModel.load()
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Save & Close")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "8DB596"), Color(hex: "6A9E75")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(Constants.UI.cornerRadius)
                        .shadow(color: Color(hex: "8DB596").opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                
                Spacer(minLength: 32)
            }
            .padding()
        }
        .navigationTitle("Quick Start")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.easeInOut, value: timerViewModel.isCompleted)
        .onDisappear {
            timerViewModel.resetTimer()
            animatePulse = false
        }
    }
}

// MARK: - Color Hex Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
