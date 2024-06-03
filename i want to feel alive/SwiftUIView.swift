import SwiftUI

struct StoreDetailView: View {
    
    @State private var rotationAngle: Double = 0.0
    
    var body: some View {
        Image("image121")
            .font(Font.system(size: 100.0))
            .rotationEffect(.degrees(rotationAngle))
            .shadow(radius: 10.0)
            .onAppear {
                withAnimation(Animation.linear(duration: 5.0).repeatForever(autoreverses: false)) {
                    rotationAngle = 360.0
                }
            }
    }
}

