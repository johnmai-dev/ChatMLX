//
//  UltraWindowStyleViewModifier.swift
//  UltraUI
//
//  Created by John Mai on 2025/2/28.
//

import SwiftUI

struct UltraWindowStyleViewModifier: ViewModifier {
    @Environment(\.utlraWindowBlur) var utlraWindowBlur
    @Environment(\.utlraWindowBackgroundColor) var utlraWindowBackgroundColor
    @Environment(\.utlraTint) var utlraTint

    func body(content: Content) -> some View {
        content.introspect(.window, on: .macOS(.v15, .v14)) { window in
            window.isOpaque = false

            window.setWindowBackgroundBlurRadius(utlraWindowBlur)
            window.backgroundColor = NSColor(utlraWindowBackgroundColor)
            window.toolbarStyle = .unified

            window.titlebarAppearsTransparent = true
            window.titleVisibility = .hidden

            let toolbar = NSToolbar()
            window.toolbar = toolbar
        }
        .background(UltraWindowBackgroundView())
        .foregroundStyle(.white, .white.opacity(0.7))
        .tint(utlraTint)
        .ignoresSafeArea()
    }
}
