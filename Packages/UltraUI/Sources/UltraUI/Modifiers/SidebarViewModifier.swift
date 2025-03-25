//
//  SidebarViewModifier.swift
//  UltraUI
//
//  Created by John Mai on 2025/2/27.
//

import SwiftUI

struct SidebarViewModifier: ViewModifier {

    @Environment(\.utlraSecondaryViewBackground) var utlraSecondaryViewBackground

    @State private var isHovered = false
    private let cornerRadius: CGFloat
    private let isSelected: Bool
    private let disableHoverEffect: Bool

    var highlighted: Bool {
        isHovered || isSelected
    }

    init(
        isSelected: Bool = true,
        disableScaleEffect: Bool = false,
        cornerRadius: CGFloat = 10
    ) {
        self.isSelected = isSelected
        self.disableHoverEffect = disableScaleEffect
        self.cornerRadius = cornerRadius
    }

    init(_ isSelected: Bool) {
        self.init(
            isSelected: isSelected,
            disableScaleEffect: true
        )
    }

    func body(content: Content) -> some View {
        content
            .foregroundStyle(.white)
            .background {
                if highlighted {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(utlraSecondaryViewBackground)
                        .overlay {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            .white.opacity(isHovered ? 0.1 : 0.05),
                                            .clear,

                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                        .shadow()
                        .shadow(
                            color: .white.opacity(isHovered ? 0.3 : 0.2), radius: 2,
                            x: -1, y: -1
                        )
                        .shadow(
                            color: .black.opacity(isHovered ? 0.3 : 0.2), radius: 2,
                            x: 1, y: 1
                        )
                        .shadow(
                            color: .white.opacity(isHovered ? 0.15 : 0.1),
                            radius: 8, x: 0, y: 0)

                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    .white.opacity(isHovered ? 0.6 : 0.5),
                                    .clear,
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.5
                        )
                }
            }

            .scaleEffect(isHovered && !disableHoverEffect ? 1.02 : 1.0)
            .shadow(
                color: .black.opacity(
                    isHovered ? 0.25 : 0.2
                ),
                radius: isHovered ? 5 : 4,
                x: 0,
                y: isHovered ? 3 : 2
            )

            .animation(
                .spring(
                    duration: 0.2,
                    bounce: 0.3
                ),
                value: isHovered
            )
            .onHover { hovering in
                isHovered = hovering
            }

    }
}
