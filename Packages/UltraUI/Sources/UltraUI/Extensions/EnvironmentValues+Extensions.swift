//
//  EnvironmentValues+Extensions.swift
//  UltraUI
//
//  Created by John Mai on 2025/2/28.
//

import SwiftUI

extension EnvironmentValues {
    @Entry public var utlraRadius: CGFloat = 10

    @Entry public var utlraWindowBlur: Int = 50
    @Entry public var utlraWindowBackgroundColor: Color = .black.opacity(0.6)

    @Entry public var ultraViewBackground: Color = .black.opacity(0.28)
    @Entry public var utlraSecondaryViewBackground: Color = .white.opacity(0.12)

    @Entry public var utlraTint: Color = .init(red: 21 / 255, green: 146 / 255, blue: 250 / 255)

    @Entry public var utlraTitle: Color = .white
    @Entry public var utlraSubtitle: Color = .white.opacity(0.7)
    @Entry public var utlraText: Color = .white
    @Entry public var utlraPlaceholder: Color = .white.opacity(0.7)
}
