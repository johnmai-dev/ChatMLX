//
//  UltraWindowBackgroundView.swift
//  UltraUI
//
//  Created by John Mai on 2025/2/23.
//

import SwiftUI

public struct UltraWindowBackgroundView: View {

    @Environment(\.utlraRadius) var utlraRadius
    @Environment(\.utlraWindowBackgroundColor) var utlraWindowBackgroundColor

    public init() {}

    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: utlraRadius)
                .fill(utlraWindowBackgroundColor)
                .overlay {
                    RoundedRectangle(cornerRadius: utlraRadius)
                        .fill(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.24),
                                    .clear,
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .shadow(
                    color: .white.opacity(0.1),
                    radius: 2,
                    x: -1,
                    y: -1
                )
                .shadow(
                    color: .black.opacity(0.1),
                    radius: 2,
                    x: 1,
                    y: 1
                )
                .shadow(
                    color: .white.opacity(0.05),
                    radius: 8,
                    x: 0,
                    y: 0
                )

            RoundedRectangle(cornerRadius: utlraRadius)
                .stroke(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.5),
                            .clear,
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.5
                )
        }

    }
}
