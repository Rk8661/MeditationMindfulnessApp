import SwiftUI

struct ProgressRing: View {
    
    let progress: Double
    let size: CGFloat
    let lineWidth: CGFloat
    let color: Color
    var showLabel: Bool = true        // add this
    
    init(progress: Double, size: CGFloat = 120, lineWidth: CGFloat = 12, color: Color = .purple, showLabel: Bool = true) {
        self.progress = progress
        self.size = size
        self.lineWidth = lineWidth
        self.color = color
        self.showLabel = showLabel
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: Constants.UI.animationDuration), value: progress)
            
            // Only show label when showLabel is true
            if showLabel {
                VStack(spacing: 2) {
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: size * 0.22, weight: .bold, design: .rounded))
                        .foregroundColor(color)
                    Text("done")
                        .font(.system(size: size * 0.12, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(width: size, height: size)
    }
}
