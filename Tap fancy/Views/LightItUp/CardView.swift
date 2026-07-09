import Foundation
import SwiftUI

struct CardView: View {
    let isLit: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(isLit ? Color.yellow : Color.white.opacity(0.3))
            .frame(height: 120)
            .shadow(color: isLit ? Color.yellow.opacity(0.6) : Color.clear, radius: 10)
            .scaleEffect(isLit ? 1.1 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isLit)
    }
}
