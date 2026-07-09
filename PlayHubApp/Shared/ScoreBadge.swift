
import Foundation
import SwiftUI

struct ScoreBadge: View {
    let label: String
    let value: Int
    var fontSize: CGFloat = 50
    
    var body: some View {
        VStack(spacing: 5) {
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            Text("\(value)")
                .font(.system(size: fontSize, weight: .bold))
                .foregroundColor(.white)
        }
    }
}

//streak 
struct ScoreBadgeWithIcon: View {
    let label: String
    let value: Int
    let icon: String
    var fontSize: CGFloat = 24
    var highlightColor: Color = .yellow
    var isHighlighted: Bool = false
    
    var body: some View {
        VStack(spacing: 5) {
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            HStack(spacing: 4) {
                if isHighlighted {
                    Image(systemName: icon)
                        .foregroundColor(highlightColor)
                }
                Text("\(value)")
                    .font(.system(size: fontSize, weight: .bold))
                    .foregroundColor(isHighlighted ? highlightColor : .white)
            }
        }
    }
}

