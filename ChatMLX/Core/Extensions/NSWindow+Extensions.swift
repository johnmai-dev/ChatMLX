//
//  NSWindow+Extensions.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/3.
//

import SwiftUI

extension NSWindow {
    /// Sets the background blur of the window with a specified radius and color.
    ///
    /// - Parameters:
    ///   - radius: The blur radius to apply. Defaults to 0 if an error occurs.
    ///   - color: The background color. Defaults to semi-transparent black.
    func setBackgroundBlur(radius: Int, color: NSColor = .black.withAlphaComponent(0.4)) {
        guard let connection = CGSDefaultConnectionForThread() else {
            NSLog("Failed to get CGS connection")
            return
        }

        let status = CGSSetWindowBackgroundBlurRadius(connection, windowNumber, radius)
        if status != noErr {
            NSLog("Error setting blur radius: \(status)")
        }

        backgroundColor = .white.withAlphaComponent(0.001)
        ignoresMouseEvents = false
    }
}

// MARK: - Private APIs and Helper Functions

@_silgen_name("CGSDefaultConnectionForThread")
func CGSDefaultConnectionForThread() -> UInt32?

@_silgen_name("CGSSetWindowBackgroundBlurRadius")
@discardableResult
func CGSSetWindowBackgroundBlurRadius(
    _ connection: UInt32,
    _ windowNum: NSInteger,
    _ radius: Int
) -> OSStatus
