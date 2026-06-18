import SwiftUI

struct SessionsView: View {
    
    // MARK: - Environment
    @EnvironmentObject var sessionViewModel: SessionViewModel
    
    var body: some View {
        ZStack {
            Color(hex: "FDF6F0")
                .ignoresSafeArea()
            
            Circle()
                .fill(Color(hex: "F2C4B0").opacity(0.3))
                .frame(width: 260, height: 260)
                .blur(radius: 70)
                .offset(x: -100, y: -150)
            
            VStack(spacing: 0) {
                categoryFilter
                
                if sessionViewModel.isLoading {
                    Spacer()
                    loadingView
                    Spacer()
                } else if let error = sessionViewModel.errorMessage {
                    Spacer()
                    errorView(message: error)
                    Spacer()
                } else if sessionViewModel.filteredSessions.isEmpty {
                    Spacer()
                    emptyView
                    Spacer()
                } else {
                    sessionList
                }
            }
        }
        .navigationTitle("Sessions")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $sessionViewModel.searchText, prompt: "Search sessions...")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    SessionHistoryView()
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "FFFAF7"))
                            .frame(width: 36, height: 36)
                            .shadow(color: Color(hex: "E8A598").opacity(0.2), radius: 6, x: 0, y: 3)
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color(hex: "E8A598"))
                    }
                }
            }
        }
        .task {
            await sessionViewModel.fetchSessions()
        }
    }
    
    // MARK: - Category Filter
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(sessionViewModel.categories, id: \.self) { category in
                    categoryChip(category)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
    }
    
    private func categoryChip(_ category: String) -> some View {
        let isSelected = sessionViewModel.selectedCategory == category
        return Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                sessionViewModel.selectedCategory = category
            }
            Haptics.impact(.light)
        } label: {
            Text(category)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 18)
                .padding(.vertical, 9)
                .background(
                    Capsule()
                        .fill(
                            isSelected
                            ? LinearGradient(colors: [Color(hex: "E8A598"), Color(hex: "F2A07B")], startPoint: .leading, endPoint: .trailing)
                            : LinearGradient(colors: [Color(hex: "FFFAF7"), Color(hex: "FFFAF7")], startPoint: .leading, endPoint: .trailing)
                        )
                        .shadow(color: isSelected ? Color(hex: "E8A598").opacity(0.35) : Color(hex: "E8A598").opacity(0.1), radius: isSelected ? 8 : 4, x: 0, y: 3)
                )
                .foregroundColor(isSelected ? .white : Color(hex: "2D2320"))
        }
    }
    
    // MARK: - Session List
    private var sessionList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 12) {
                ForEach(Array(sessionViewModel.filteredSessions.enumerated()), id: \.element.id) { index, session in
                    NavigationLink {
                        SessionDetailView(session: session)
                    } label: {
                        SessionCard(session: session)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
    
    // MARK: - Loading
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .tint(Color(hex: "E8A598"))
                .scaleEffect(1.3)
            Text("Loading sessions...")
                .font(.subheadline)
                .foregroundColor(Color(hex: "9E7B74"))
        }
    }
    
    // MARK: - Empty View
    private var emptyView: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color(hex: "F2C4B0").opacity(0.3))
                    .frame(width: 80, height: 80)
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 32))
                    .foregroundColor(Color(hex: "E8A598"))
            }
            Text("No sessions found")
                .font(.headline)
                .foregroundColor(Color(hex: "2D2320"))
            Text("Try a different search or category")
                .font(.subheadline)
                .foregroundColor(Color(hex: "9E7B74"))
        }
    }
    
    // MARK: - Error View
    private func errorView(message: String) -> some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color(hex: "F2C4B0").opacity(0.3))
                    .frame(width: 80, height: 80)
                Image(systemName: "wifi.slash")
                    .font(.system(size: 32))
                    .foregroundColor(Color(hex: "E8A598"))
            }
            Text("Something went wrong")
                .font(.headline)
                .foregroundColor(Color(hex: "2D2320"))
            Text(message)
                .font(.subheadline)
                .foregroundColor(Color(hex: "9E7B74"))
                .multilineTextAlignment(.center)
            Button {
                Task { await sessionViewModel.fetchSessions() }
            } label: {
                Text("Try Again")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(LinearGradient(colors: [Color(hex: "E8A598"), Color(hex: "F2A07B")], startPoint: .leading, endPoint: .trailing))
                    )
                    .foregroundColor(.white)
            }
            .padding(.top, 4)
        }
        .padding()
    }
}
