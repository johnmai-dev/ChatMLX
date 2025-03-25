//
//  UltraBackgroundView.swift
//  UltraUI
//
//  Created by John Mai on 2025/2/23.
//

import SwiftUI

struct UltraSidebarBackgroundView: View {
    @Environment(\.ultraViewBackground) var utlraViewBackground

    var body: some View {
        ZStack {
            Rectangle()
                .fill(utlraViewBackground)
                .overlay {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    .black.opacity(0.2),
                                    .clear,
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .shadow(
                    color: .black.opacity(0.1),
                    radius: 2,
                    x: -1,
                    y: -1
                )
                .shadow(
                    color: .white.opacity(0.1),
                    radius: 2,
                    x: 1,
                    y: 1
                )
                .shadow(
                    color: .black.opacity(0.05),
                    radius: 8,
                    x: 0,
                    y: 0
                )
        }

    }
}
