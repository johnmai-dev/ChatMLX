//
//  UltraButtonStyle.swift
//  UltraUI
//
//  Created by John Mai on 2025/2/23.
//

import SwiftUI

extension ButtonStyle where Self == UltraSidebarButtonStyle {
    static var ultraSidebar: some ButtonStyle {
        UltraSidebarButtonStyle()
    }
}

public struct UltraSidebarButtonStyle: ButtonStyle {
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

    public init(_ isSelected: Bool) {
        self.init(
            isSelected: isSelected,
            disableScaleEffect: true
        )
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
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
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .scaleEffect(isHovered && !disableHoverEffect ? 1.02 : 1.0)
            .shadow(
                color: .black.opacity(
                    configuration.isPressed ? 0.1 : isHovered ? 0.25 : 0.2
                ),
                radius: configuration.isPressed ? 2 : isHovered ? 5 : 4,
                x: 0,
                y: configuration.isPressed ? 1 : isHovered ? 3 : 2
            )
            .animation(
                .spring(
                    duration: 0.2,
                    bounce: 0.3
                ),
                value: configuration.isPressed
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
            .shadow()
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listItemTint(.clear)
            .listRowInsets(
                EdgeInsets(
                    top: 2,
                    leading: 0,
                    bottom: 2,
                    trailing: 0
                )
            )
    }
}

#Preview {
    VStack {
        Button("Hello") {}
            .buttonStyle(.ultraSidebar)
    }
    .frame(width: 200, height: 200)
    .background(Color.gray)

}
