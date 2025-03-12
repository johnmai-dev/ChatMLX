//
//  UltraOptionsWindowController.swift
//  UltraUI
//
//  Created by John Mai on 2025/2/26.
//

import AppKit
import SwiftUI

final class UltraOptionsWindowController: NSWindowController, Sendable {
    private var globalEventMonitor: Any?
    private var localEventMonitor: Any?

    let padding: CGFloat = 4

    convenience init(_ content: NSView) {
        let window = UltraOptionsPanel(
            contentRect: NSRect(x: 0, y: 0, width: 0, height: 0),
            styleMask: [.borderless, .resizable, .nonactivatingPanel],
            backing: .buffered,
            defer: true
        )

        window.contentView = content

        window.level = .floating
        window.isFloatingPanel = true
        window.hidesOnDeactivate = false
        window.collectionBehavior = .canJoinAllSpaces
        window.isOpaque = false
        window.backgroundColor = .clear
        window.hasShadow = true
        
        self.init(window: window)
    }

    deinit {
        Task { [self] in
            await stopEventMonitoring()
        }
    }

    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        window?.makeKeyAndOrderFront(nil)
        startEventMonitoring()
    }

    func showWindow() {
        self.sizeWindowToFitContent()
        self.showWindow(nil)
    }

    func sizeWindowToFitContent() {
        guard let window = self.window else { return }
        let contentSize = window.contentView?.fittingSize ?? .zero
        let windowSize = window.frame.size
        let newSize = NSSize(
            width: max(contentSize.width, windowSize.width),
            height: max(contentSize.height, windowSize.height)
        )
        window.setFrame(
            NSRect(origin: window.frame.origin, size: newSize),
            display: true
        )
    }

    func setWindowPosition(_ rect: CGRect) {
        guard let window = self.window,
            let sourceWindow = NSApplication.shared.windows.first
        else { return }

        let rectInScreen = NSRect(
            x: sourceWindow.frame.origin.x + rect.origin.x,
            y: sourceWindow.frame.origin.y + sourceWindow.frame.height - rect.origin.y
                - rect.size.height,
            width: rect.size.width,
            height: rect.size.height
        )

        guard
            let currentScreen = NSScreen.screens.first(where: {
                NSIntersectsRect(rectInScreen, $0.frame)
            }) ?? NSScreen.main
        else {
            window.setFrameOrigin(
                NSPoint(
                    x: rectInScreen.midX - window.frame.width / 2,
                    y: rectInScreen.origin.y - window.frame.size.height - padding))
            window.setWindowBackgroundBlurRadius()
            return
        }

        let safeMargin: CGFloat = 10.0

        var targetX = rectInScreen.midX - window.frame.width / 2
        let targetYBelow = rectInScreen.origin.y - window.frame.size.height - padding
        let targetYAbove = rectInScreen.origin.y + rectInScreen.size.height + padding

        let screenLeftX = currentScreen.visibleFrame.origin.x
        let screenRightX = screenLeftX + currentScreen.visibleFrame.width

        if targetX < (screenLeftX + safeMargin) {
            targetX = screenLeftX + safeMargin
        }

        let rightEdgePosition = targetX + window.frame.width
        if rightEdgePosition > (screenRightX - safeMargin) {
            targetX = screenRightX - window.frame.width - safeMargin
        }

        var targetY: CGFloat

        let screenBottomY = currentScreen.visibleFrame.origin.y

        if targetYBelow < (screenBottomY + safeMargin) {
            targetY = targetYAbove
        } else {
            targetY = targetYBelow
        }

        window.setFrameOrigin(NSPoint(x: targetX, y: targetY))
        window.setWindowBackgroundBlurRadius()
    }

    func closeWindow() {
        stopEventMonitoring()
        self.window?.close()
    }

    private func startEventMonitoring() {
        stopEventMonitoring()

        let mouseEvents: NSEvent.EventTypeMask = [.leftMouseDown, .rightMouseDown]

        globalEventMonitor = NSEvent.addGlobalMonitorForEvents(matching: mouseEvents) {
            [weak self] event in
            guard let self = self else { return }
            self.handleMouseEvent(event)
        }

        localEventMonitor = NSEvent.addLocalMonitorForEvents(matching: mouseEvents) {
            [weak self] event in
            guard let self = self else { return event }
            self.handleMouseEvent(event)
            return event
        }
    }

    private func handleMouseEvent(_ event: NSEvent) {
        guard let window = self.window else { return }

        let clickLocation = event.locationInWindow

        var clickLocationInScreen: NSPoint

        if let eventWindow = event.window {

            let windowLocation = eventWindow.convertPoint(
                toScreen: clickLocation)
            clickLocationInScreen = windowLocation
        } else {

            clickLocationInScreen = NSPoint(
                x: clickLocation.x + (event.window?.frame.origin.x ?? 0),
                y: clickLocation.y + (event.window?.frame.origin.y ?? 0)
            )
        }

        if !NSPointInRect(clickLocationInScreen, window.frame) {
            DispatchQueue.main.async { [weak self] in
                self?.closeWindow()
            }
        }
    }

    func stopEventMonitoring() {
        if let globalEventMonitor {
            NSEvent.removeMonitor(globalEventMonitor)
            self.globalEventMonitor = nil
        }

        if let localEventMonitor {
            NSEvent.removeMonitor(localEventMonitor)
            self.localEventMonitor = nil
        }
    }
}
