//
//  NSWindow+Extensions.swift
//  UltraUI
//
//  Created by John Mai on 2025/2/21.
//

import SwiftUI

@_silgen_name("CGSDefaultConnectionForThread")
func CGSDefaultConnectionForThread() -> CGSConnection?

@_silgen_name("CGSSetWindowBackgroundBlurRadius")
@discardableResult
func CGSSetWindowBackgroundBlurRadius(
    _ connection: CGSConnection, _ windowNumber: CGWindowID, _ radius: Int
) -> CGError

typealias CGSConnection = UInt32
typealias CGWindowID = Int
typealias CGError = Int32

extension NSWindow {
    func setWindowBackgroundBlurRadius(_ radius: Int = 50) {
        let status = CGSSetWindowBackgroundBlurRadius(
            CGSDefaultConnectionForThread()!,
            windowNumber,
            radius
        )

        if status != noErr {
            NSLog("Error setting window background blur radius: \(status)")
        }
    }
}
