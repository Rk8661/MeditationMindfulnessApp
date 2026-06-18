import SwiftUI

struct SessionHistoryView: View {
    
    // MARK: - Environment
    @EnvironmentObject var sessionViewModel: SessionViewModel
    
    // MARK: - State
    @State private var showDeleteConfirm: Bool = false
    @State private var animateIn: Bool = false
    
    var body: some View {
        ZStack {
            Color(hex: "FDF6F0")
                .ignoresSafeArea()
            
            Circle()
                .fill(Color(hex: "F2C4B0").opacity(0.3))
                .frame(width: 260, height: 260)
                .blur(radius: 70)
                .offset(x: 110, y: -160)
            
            Group {
                if sessionViewModel.sessionHistory.isEmpty {
                    emptyState
                } else {
                    historyList
                }
            }
        }
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            if !sessionViewModel.sessionHistory.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showDeleteConfirm = true
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "FFFAF7"))
                                .frame(width: 36, height: 36)
                                .shadow(color: Color(hex: "E8A598").opacity(0.2), radius: 6, x: 0, y: 3)
                            Image(systemName: "trash")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(hex: "C97B6A"))
                        }
                    }
                }
            }
        }
        .confirmationDialog(
            "Clear all history?",
            isPresented: $showDeleteConfirm,
            titleVisibility: .visible
        ) {
            Button("Clear All", role: .destructive) {
                withAnimation {
                    sessionViewModel.clearHistory()
                }
            }
            Button("Cancel", role: .cancel) {}
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                animateIn = true
            }
        }
    }
    
    // MARK: - History List
    private var historyList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                summaryCard
                    .offset(y: animateIn ? 0 : 20)
                    .opacity(animateIn ? 1 : 0)
                
                VStack(spacing: 12) {
                    ForEach(Array(sessionViewModel.sessionHistory.enumerated()), id: \.element.id) { index, session in
                        sessionRow(session)
                            .offset(y: animateIn ? 0 : 20)
                            .opacity(animateIn ? 1 : 0)
                            .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(Double(index) * 0.04), value: animateIn)
                    }
                }
            }
            .padding()
        }
    }
    
    // MARK: - Summary Card
    private var summaryCard: some View {
        HStack(spacing: 0) {
            summaryItem(value: "\(sessionViewModel.sessionHistory.count)", label: "Sessions", icon: "calendar")
            
            Rectangle()
                .fill(Color(hex: "E8A598").opacity(0.2))
                .frame(width: 1, height: 40)
            
            summaryItem(value: "\(sessionViewModel.totalMinutesMeditated)", label: "Total Min", icon: "clock.fill")
        }
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "FDDCB5").opacity(0.5), Color(hex: "F2C4B0").opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                        .stroke(Color(hex: "E8A598").opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private func summaryItem(value: String, label: String, icon: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(Color(hex: "E8A598"))
            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "2D2320"))
            Text(label)
                .font(.caption)
                .foregroundColor(Color(hex: "9E7B74"))
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Session Row
    private func sessionRow(_ session: MeditationSession) -> some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(typeColor(session.type).opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: typeIcon(session.type))
                    .foregroundColor(typeColor(session.type))
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(session.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "2D2320"))
                HStack(spacing: 6) {
                    Text(DateFormatterHelper.format(session.date, using: DateFormatterHelper.displayDate))
                        .font(.caption)
                        .foregroundColor(Color(hex: "9E7B74"))
                    Text("•")
                        .foregroundColor(Color(hex: "9E7B74"))
                    Text(DateFormatterHelper.durationString(session.duration))
                        .font(.caption)
                        .foregroundColor(Color(hex: "9E7B74"))
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 6) {
                Text(DateFormatterHelper.relativeString(from: session.date))
                    .font(.caption2)
                    .foregroundColor(Color(hex: "9E7B74"))
                
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        sessionViewModel.deleteSession(id: session.id)
                    }
                    Haptics.impact(.light)
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "9E7B74").opacity(0.4))
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(hex: "FFFAF7"))
                .shadow(color: Color(hex: "E8A598").opacity(0.1), radius: 6, x: 0, y: 3)
        )
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color(hex: "F2C4B0").opacity(0.3))
                    .frame(width: 90, height: 90)
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 36))
                    .foregroundColor(Color(hex: "E8A598"))
            }
            Text("No History Yet")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(Color(hex: "2D2320"))
            Text("Your completed sessions will appear here.")
                .font(.subheadline)
                .foregroundColor(Color(hex: "9E7B74"))
                .multilineTextAlignment(.center)
        }
        .padding()
        .offset(y: animateIn ? 0 : 16)
        .opacity(animateIn ? 1 : 0)
    }
    
    // MARK: - Helpers
    private func typeIcon(_ type: String) -> String {
        switch type {
        case "Guided":    return "play.circle.fill"
        case "Timer":     return "timer"
        case "Breathing": return "wind"
        default:          return "moon.fill"
        }
    }
    
    private func typeColor(_ type: String) -> Color {
        switch type {
        case "Guided":    return Color(hex: "9B8FC4")
        case "Timer":     return Color(hex: "E8A598")
        case "Breathing": return Color(hex: "8DB596")
        default:          return Color(hex: "9E7B74")
        }
    }
}
