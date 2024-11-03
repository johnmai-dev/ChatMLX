//
//  AppleIntelligenceEffectView.swift
//  test
//
//  Created by John Mai on 2024/10/6.
//

import SwiftUI

struct AppleIntelligenceEffectView: View {
    private let shader = ShaderLibrary.colorWheel(.boundingRect)
    private let angles = [1, -1]
    private let maxBlurRadiusBase: CGFloat = 18
    private let minBlurRadiusBase: CGFloat = 6
    private let startTime = Date.now

    var useRoundedRectangle: Bool = true

    var body: some View {
        TimelineView(.animation) { timeline in
            ZStack {
                ForEach(angles, id: \.self) { angle in
                    colorWheelRectangle(for: timeline.date, angle: angle)
                }
            }
        }
    }

    private func colorWheelRectangle(for date: Date, angle: Int) -> some View {
        let elapsed = startTime.distance(to: date)

        let blurRadius =
            angle > 0
                ? maxBlurRadiusBase + 6 * sin(elapsed * 2)
                : minBlurRadiusBase + 3 * sin(elapsed * 4)

        return Rectangle()
            .visualEffect { content, proxy in
                content
                    .colorEffect(
                        ShaderLibrary.animatedGradientFill(
                            .float2(proxy.size),
                            .float(elapsed)
                        )
                    )
            }
            .mask(alignment: .center) {
                if useRoundedRectangle {
                    UnevenRoundedRectangle(
                        cornerRadii: .init(
                            topLeading: 20,
                            bottomLeading: 0,
                            bottomTrailing: 0,
                            topTrailing: 20
                        )
                    )
                    .stroke(lineWidth: maxBlurRadiusBase)
                    .blur(radius: blurRadius)
                } else {
                    Rectangle()
                        .stroke(lineWidth: maxBlurRadiusBase)
                        .blur(radius: blurRadius)
                }
            }
    }
}
