//
//  UltraDynamicButtonStyle.swift
//  UltraUI
//
//  Created by John Mai on 2025/2/23.
//

import SwiftUI

extension ButtonStyle where Self == UltraDynamicButtonStyle {
    static var ultraDynamic: some ButtonStyle {
        UltraDynamicButtonStyle()
    }
}

struct UltraDynamicButtonStyle: ButtonStyle {
    @Environment(\.utlraSecondaryViewBackground) var utlraSecondaryViewBackground

    @State private var mouseLocation: CGPoint = .zero
    @State private var buttonFrame: CGRect = .zero

    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            configuration.label
                .padding(.horizontal, 20)
                .padding(.vertical, 12)

                .background {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(utlraSecondaryViewBackground)

                        RadialGradient(
                            colors: [
                                .white.opacity(0.3),
                                .clear,
                            ],
                            center: calculateGradientCenter(),
                            startRadius: 0,
                            endRadius: 100
                        )
                        .opacity(mouseLocation == .zero ? 0 : 0.5)
                        .clipShape(RoundedRectangle(cornerRadius: 25))

                        RoundedRectangle(cornerRadius: 25)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.5),
                                        .white.opacity(0.2),
                                    ],
                                    startPoint: calculateGradientCenter(),
                                    endPoint: calculateOppositePoint()
                                ),
                                lineWidth: 0.5
                            )
                    }
                }

                .shadow(
                    color: .white.opacity(0.2),
                    radius: calculateShadowRadius(),
                    x: calculateShadowOffset().width,
                    y: calculateShadowOffset().height
                )
                .shadow(
                    color: .black.opacity(0.2),
                    radius: calculateShadowRadius(),
                    x: -calculateShadowOffset().width,
                    y: -calculateShadowOffset().height
                )

                .shadow(
                    color: .white.opacity(0.1),
                    radius: 8,
                    x: 0,
                    y: 0
                )

                .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
                .opacity(configuration.isPressed ? 0.8 : 1.0)
                .animation(
                    .spring(duration: 0.2, bounce: 0.3),
                    value: configuration.isPressed
                )
                .animation(.easeOut(duration: 0.2), value: mouseLocation)

                .modifier(
                    MouseLocationTracker(
                        mouseLocation: .init(
                            get: { mouseLocation }, set: { mouseLocation = $0 })
                    )
                )

                .onAppear {
                    buttonFrame = geometry.frame(in: .local)
                }
        }
    }

    private func calculateGradientCenter() -> UnitPoint {
        guard mouseLocation != .zero else {
            return .topLeading
        }

        let x = mouseLocation.x / buttonFrame.width
        let y = mouseLocation.y / buttonFrame.height
        return UnitPoint(x: x, y: y)
    }

    private func calculateOppositePoint() -> UnitPoint {
        let center = calculateGradientCenter()
        return UnitPoint(x: 1 - center.x, y: 1 - center.y)
    }

    private func calculateShadowRadius() -> CGFloat {
        guard mouseLocation != .zero else { return 4 }

        let distance = hypot(
            mouseLocation.x - buttonFrame.midX,
            mouseLocation.y - buttonFrame.midY
        )

        return max(2, min(6, 6 - (distance / 100)))
    }

    private func calculateShadowOffset() -> CGSize {
        guard mouseLocation != .zero else {
            return CGSize(width: 0, height: 2)
        }

        let deltaX = mouseLocation.x - buttonFrame.midX
        let deltaY = mouseLocation.y - buttonFrame.midY

        let maxOffset: CGFloat = 2

        return CGSize(
            width: deltaX * maxOffset / buttonFrame.width,
            height: deltaY * maxOffset / buttonFrame.height
        )
    }
}

struct MouseLocationTracker: ViewModifier {
    @Binding var mouseLocation: CGPoint

    func body(content: Content) -> some View {
        content
            .onContinuousHover { phase in
                switch phase {
                case .active(let location):
                    mouseLocation = location
                case .ended:
                    mouseLocation = .zero
                }
            }
    }
}

#Preview {
    VStack {
        Button("Hello") {}
            .buttonStyle(UltraDynamicButtonStyle())
    }
    .frame(width: 200, height: 200)
    .background(Color.gray)

}
