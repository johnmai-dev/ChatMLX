//
//  UltramanMinimalistWindowModifier.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/10.
//
import AppKit
import Defaults
import SwiftUI
import SwiftUIIntrospect

struct UltramanMinimalistWindowModifier: ViewModifier {
    @Default(.backgroundBlurRadius) var blurRadius
    @Default(.backgroundColor) var backgroundColor

    func body(content: Content) -> some View {
        content
            .ignoresSafeArea()
            .introspect(.window, on: .macOS(.v14, .v15)) { window in
                configureWindow(window)
                setupFullScreenObservers(for: window)
            }
    }
    
    private func configureWindow(_ window: NSWindow) {
        window.setBackgroundBlur(radius: Int(blurRadius), color: NSColor(backgroundColor))
        window.toolbarStyle = .unified
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        
        let toolbar = NSToolbar()
        toolbar.showsBaselineSeparator = false
        window.toolbar = toolbar
    }
    
    private func setupFullScreenObservers(for window: NSWindow) {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(forName: NSWindow.didEnterFullScreenNotification, object: window, queue: .main) { _ in
            Task { @MainActor in
                handleFullScreenEnter(window)
            }
        }
        
        notificationCenter.addObserver(forName: NSWindow.didExitFullScreenNotification, object: window, queue: .main) { _ in
            Task { @MainActor in
                handleFullScreenExit(window)
            }
        }
    }
    
    private func handleFullScreenEnter(_ window: NSWindow) {
        window.toolbar?.isVisible = false
        NSApp.presentationOptions = [.autoHideToolbar, .autoHideMenuBar]
    }
    
    private func handleFullScreenExit(_ window: NSWindow) {
        window.toolbar?.isVisible = true
        NSApp.presentationOptions = []
    }
}

extension View {
    func ultramanMinimalistWindowStyle() -> some View {
        modifier(UltramanMinimalistWindowModifier())
    }
}
