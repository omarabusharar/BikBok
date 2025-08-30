//
//  AdTimer.swift
//  BikBok
//
//  Created by Omar Abu Sharar on 8/30/25.
//

import SwiftUI
import Combine

struct AdTimer: View {
    @State private var lengthPassed: Int = 0
    @State var length: Int
    var color: Color
    var onComplete: () -> Void
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack {
            Circle()
                .fill(.clear)
                .frame(width: 50, height: 50)
                .glassEffect(.clear, in: Circle())
            Text(length == lengthPassed ? "Done" : "\(Int(length - lengthPassed))s")
                .fontWeight(.bold)
                .foregroundStyle(color)
                .minimumScaleFactor(0.5)
        }
        .onReceive(timer) { _ in
            if lengthPassed < length {
                lengthPassed += 1
            } else {
                timer.upstream.connect().cancel()
                onComplete()
            }
        }
    }
}

#Preview {
    AdTimer(length: 5, color: .pink, onComplete: {})
}
