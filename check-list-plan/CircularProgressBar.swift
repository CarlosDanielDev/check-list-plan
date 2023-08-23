import SwiftUI

struct CircularProgressBar: View {
    var progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4)
                .opacity(0.1)
                .foregroundColor(Color.black)

            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.green)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)

            Text("\(Int(progress * 100))%")
                .font(.system(size: 8))
                .bold()
                .foregroundColor(progress > 0 ? Color.green : Color.gray)
        }
        .frame(width: 28, height: 28)
    }
}
