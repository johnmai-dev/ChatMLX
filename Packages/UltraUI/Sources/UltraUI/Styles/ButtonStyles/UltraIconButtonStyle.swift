//
//  UltraIconButtonStyle.swift
//  UltraUI
//
//  Created by John Mai on 2025/2/23.
//

import SwiftUI

extension ButtonStyle where Self == UltraIconButtonStyle {
    public static var ultraIcon: some ButtonStyle {
        UltraIconButtonStyle()
    }
}

public struct UltraIconButtonStyle: ButtonStyle {
    @Environment(\.utlraSecondaryViewBackground) var utlraSecondaryViewBackground

    @State private var isHovered = false

    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .font(.title2)
                .foregroundColor(.white)
                .padding(8)
        }
        .background {
            if isHovered {
                ZStack {
                    Circle()
                        .fill(utlraSecondaryViewBackground)
                        .overlay {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            .white.opacity(0.2),
                                            .clear,
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .opacity(0.5)
                        }
                        .shadow(
                            color: .white.opacity(0.3),
                            radius: 2,
                            x: -1,
                            y: -1
                        )
                        .shadow(
                            color: .black.opacity(0.3),
                            radius: 2,
                            x: 1,
                            y: 1
                        )
                        .shadow(
                            color: .white.opacity(0.15),
                            radius: 8,
                            x: 0,
                            y: 0
                        )

                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.6),
                                    .clear,
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.5
                        )
                }
                .shadow(
                    color: .white.opacity(0.2),
                    radius: 4,
                    x: -1,
                    y: -1
                )
                .shadow(
                    color: .black.opacity(0.2),
                    radius: 4,
                    x: 1,
                    y: 1
                )
                .shadow(
                    color: .white.opacity(0.1),
                    radius: 8,
                    x: 0,
                    y: 0
                )
            }
        }
        .opacity(configuration.isPressed ? 0.8 : 1.0)
        .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
        .animation(
            .spring(duration: 0.2, bounce: 0.3), value: configuration.isPressed
        )
        .animation(.easeOut(duration: 0.2), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

#Preview {
    VStack {
        Button("Hello") {}
            .buttonStyle(.ultraIcon)

        Button {

        } label: {
            Image(systemName: "paperclip")
        }.buttonStyle(.ultraIcon)

    }
    .frame(width: 200, height: 200)
    .background(Color.gray)

}
