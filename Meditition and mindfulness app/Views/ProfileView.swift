import SwiftUI

struct ProfileView: View {
    
    // MARK: - Environment
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    // MARK: - State
    @State private var editingName: Bool = false
    @State private var nameInput: String = ""
    @State private var showResetConfirm: Bool = false
    @State private var animateIn: Bool = false
    
    var body: some View {
        ZStack {
            Color(hex: "FDF6F0")
                .ignoresSafeArea()
            
            Circle()
                .fill(Color(hex: "F2C4B0").opacity(0.3))
                .frame(width: 260, height: 260)
                .blur(radius: 70)
                .offset(x: 120, y: -150)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    profileHeader
                    goalSection
                    streakSection
                    themeSection
                    appInfoSection
                    resetSection
                    Spacer(minLength: 32)
                }
                .padding()
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            profileViewModel.load()
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                animateIn = true
            }
        }
    }
    
    // MARK: - Profile Header
    private var profileHeader: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "E8A598"), Color(hex: "F2C4B0")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 64, height: 64)
                    .shadow(color: Color(hex: "E8A598").opacity(0.35), radius: 8, x: 0, y: 4)
                Text(String(profileViewModel.profile.username.prefix(1)).uppercased())
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                if editingName {
                    TextField("Your name", text: $nameInput)
                        .textFieldStyle(.plain)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "2D2320"))
                        .onSubmit {
                            profileViewModel.saveUsername(nameInput)
                            editingName = false
                        }
                } else {
                    Text(profileViewModel.profile.username)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "2D2320"))
                }
                Text("\(profileViewModel.totalSessions) sessions · \(profileViewModel.totalMinutes) min total")
                    .font(.caption)
                    .foregroundColor(Color(hex: "9E7B74"))
            }
            
            Spacer()
            
            Button {
                if editingName {
                    profileViewModel.saveUsername(nameInput)
                } else {
                    nameInput = profileViewModel.profile.username
                }
                editingName.toggle()
            } label: {
                Text(editingName ? "Save" : "Edit")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "E8A598"))
            }
        }
        .padding()
        .background(card)
        .offset(y: animateIn ? 0 : 20)
        .opacity(animateIn ? 1 : 0)
    }
    
    // MARK: - Goal Section
    private var goalSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("Daily Goal", icon: "target")
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Meditation Goal")
                        .foregroundColor(Color(hex: "2D2320"))
                    Spacer()
                    Text("\(profileViewModel.profile.meditationGoal) min")
                        .foregroundColor(Color(hex: "E8A598"))
                        .fontWeight(.semibold)
                }
                Slider(
                    value: Binding(
                        get: { Double(profileViewModel.profile.meditationGoal) },
                        set: { profileViewModel.saveMeditationGoal(Int($0)) }
                    ),
                    in: 5...60,
                    step: 5
                )
                .tint(Color(hex: "E8A598"))
                HStack {
                    Text("5 min")
                        .font(.caption2)
                        .foregroundColor(Color(hex: "9E7B74"))
                    Spacer()
                    Text("60 min")
                        .font(.caption2)
                        .foregroundColor(Color(hex: "9E7B74"))
                }
            }
            .padding()
            .background(card)
        }
        .offset(y: animateIn ? 0 : 20)
        .opacity(animateIn ? 1 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.05), value: animateIn)
    }
    
    // MARK: - Streak Section
    private var streakSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("Streak & Badges", icon: "flame.fill")
            
            VStack(spacing: 16) {
                HStack(spacing: 0) {
                    streakStat(emoji: "🔥", value: profileViewModel.profile.currentStreak, label: "Current Streak")
                    Rectangle()
                        .fill(Color(hex: "E8A598").opacity(0.2))
                        .frame(width: 1, height: 40)
                    streakStat(emoji: "🏆", value: profileViewModel.profile.longestStreak, label: "Longest Streak")
                }
                
                Rectangle()
                    .fill(Color(hex: "E8A598").opacity(0.15))
                    .frame(height: 1)
                
                let badge = Badge.current(for: profileViewModel.profile.currentStreak)
                HStack(spacing: 12) {
                    Image(systemName: badge.icon)
                        .font(.title2)
                        .foregroundColor(badge.color)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(badge.tier == .none ? "No Badge Yet" : "\(badge.title) Badge")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(hex: "2D2320"))
                        Text(badge.tier == .none ? "Meditate 7 days to earn Bronze" : "Keep the streak going!")
                            .font(.caption)
                            .foregroundColor(Color(hex: "9E7B74"))
                    }
                    Spacer()
                }
                
                if let days = profileViewModel.daysToNextBadge,
                   let next = profileViewModel.nextBadge {
                    HStack(spacing: 8) {
                        Image(systemName: next.icon)
                            .font(.caption)
                            .foregroundColor(next.color)
                        Text("\(days) more days to \(next.title) Badge")
                            .font(.caption)
                            .foregroundColor(Color(hex: "9E7B74"))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color(hex: "F2C4B0").opacity(0.3))
                    )
                }
            }
            .padding()
            .background(card)
        }
        .offset(y: animateIn ? 0 : 20)
        .opacity(animateIn ? 1 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateIn)
    }
    
    private func streakStat(emoji: String, value: Int, label: String) -> some View {
        VStack(spacing: 6) {
            HStack(spacing: 4) {
                Text(emoji)
                    .font(.title3)
                Text("\(value)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "2D2320"))
            }
            Text(label)
                .font(.caption)
                .foregroundColor(Color(hex: "9E7B74"))
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Theme Section
    private var themeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("Appearance", icon: "paintbrush.fill")
            
            VStack(spacing: 4) {
                ForEach(AppTheme.allCases, id: \.self) { theme in
                    Button {
                        themeManager.setTheme(theme)
                        Haptics.impact(.light)
                    } label: {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: "F2C4B0").opacity(0.3))
                                    .frame(width: 32, height: 32)
                                Image(systemName: theme.icon)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "E8A598"))
                            }
                            Text(theme.rawValue)
                                .foregroundColor(Color(hex: "2D2320"))
                            Spacer()
                            if themeManager.currentTheme == theme {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color(hex: "E8A598"))
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    
                    if theme != AppTheme.allCases.last {
                        Divider()
                            .background(Color(hex: "E8A598").opacity(0.1))
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
            .background(card)
        }
        .offset(y: animateIn ? 0 : 20)
        .opacity(animateIn ? 1 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.15), value: animateIn)
    }
    
    // MARK: - App Info Section
    private var appInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("About", icon: "info.circle.fill")
            
            VStack(spacing: 4) {
                infoRow(icon: "info.circle", label: "Version", value: "1.0.0")
                Divider().background(Color(hex: "E8A598").opacity(0.1))
                infoRow(icon: "person.2", label: "Developer", value: "Rohan")
                Divider().background(Color(hex: "E8A598").opacity(0.1))
                infoRow(icon: "heart.fill", label: "Built with", value: "SwiftUI")
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
            .background(card)
        }
        .offset(y: animateIn ? 0 : 20)
        .opacity(animateIn ? 1 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateIn)
    }
    
    // MARK: - Reset Section
    private var resetSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(role: .destructive) {
                showResetConfirm = true
            } label: {
                HStack {
                    Image(systemName: "arrow.counterclockwise")
                    Text("Reset All Data")
                        .fontWeight(.medium)
                    Spacer()
                }
                .foregroundColor(Color(hex: "C97B6A"))
                .padding()
                .background(card)
            }
            .confirmationDialog(
                "Reset all data?",
                isPresented: $showResetConfirm,
                titleVisibility: .visible
            ) {
                Button("Reset", role: .destructive) {
                    profileViewModel.resetProfile()
                }
                Button("Cancel", role: .cancel) {}
            }
            
            Text("This will permanently delete your session history, streak, and profile data.")
                .font(.caption)
                .foregroundColor(Color(hex: "9E7B74"))
                .padding(.horizontal, 4)
        }
        .offset(y: animateIn ? 0 : 20)
        .opacity(animateIn ? 1 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.25), value: animateIn)
    }
    
    // MARK: - Helpers
    private var card: some View {
        RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
            .fill(Color(hex: "FFFAF7"))
            .shadow(color: Color(hex: "E8A598").opacity(0.12), radius: 8, x: 0, y: 4)
    }
    
    private func sectionLabel(_ text: String, icon: String) -> some View {
        Label(text, systemImage: icon)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(Color(hex: "9E7B74"))
            .textCase(.uppercase)
            .tracking(1)
    }
    
    private func infoRow(icon: String, label: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "E8A598"))
                .frame(width: 24)
            Text(label)
                .foregroundColor(Color(hex: "2D2320"))
            Spacer()
            Text(value)
                .foregroundColor(Color(hex: "9E7B74"))
        }
        .padding(.vertical, 10)
    }
}
