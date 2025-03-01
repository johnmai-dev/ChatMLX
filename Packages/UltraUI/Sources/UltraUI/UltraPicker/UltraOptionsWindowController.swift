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

        window.backgroundColor = NSColor.clear
        window.hasShadow = true
        window.isOpaque = false

        self.init(window: window)
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
        let targetX =
            sourceWindow.frame.origin.x + rect.origin.x
            - (window.frame.size.width - rect.size.width) / 2
        let targetY =
            sourceWindow.frame.origin.y + sourceWindow.frame.height
            - rect.origin.y - window.frame.size.height - rect.size.height
            - padding
        window.setFrameOrigin(NSPoint(x: targetX, y: targetY))
    }

    func closeWindow() {
        stopEventMonitoring()
        self.window?.close()
    }

    private func startEventMonitoring() {

        stopEventMonitoring()

        globalEventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [
            .leftMouseDown, .rightMouseDown,
        ]) { [weak self] event in
            guard let self = self else { return }
            self.handleMouseEvent(event)
        }

        localEventMonitor = NSEvent.addLocalMonitorForEvents(matching: [
            .leftMouseDown, .rightMouseDown,
        ]) { [weak self] event in
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

            DispatchQueue.main.async {
                self.closeWindow()
            }
        }
    }

    func stopEventMonitoring() {
        if let globalEventMonitor = globalEventMonitor {
            NSEvent.removeMonitor(globalEventMonitor)
            self.globalEventMonitor = nil
        }

        if let localEventMonitor = localEventMonitor {
            NSEvent.removeMonitor(localEventMonitor)
            self.localEventMonitor = nil
        }
    }
}
