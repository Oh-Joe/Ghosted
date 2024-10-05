import SwiftUI

struct OrderSymbolView: View {
    var size: CGFloat

    var body: some View {
        ZStack {
            Image(systemName: "clipboard")
                .font(.system(size: size))
            Image(systemName: "dollarsign")
                .font(.system(size: size * 0.5))
                .fontWeight(.bold)
                .offset(y: size * 0.05)
            
            .overlay {
                Image(systemName: "circle.fill")
                    .font(.system(size: size * 0.55))
                    .offset(x: size * 0.33, y: size * 0.5)
                Image(systemName: "plus")
                    .foregroundStyle(.greenTint)
                    .font(.system(size: size * 0.4))
                    .fontWeight(.bold)
                    .offset(x: size * 0.33, y: size * 0.5)
            }
        }
        .offset(y: -2)
    }
}

#Preview {
    OrderSymbolView(size: 48)
}
