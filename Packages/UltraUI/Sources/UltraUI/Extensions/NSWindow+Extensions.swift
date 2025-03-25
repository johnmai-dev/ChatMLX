//
//  NSWindow+Extensions.swift
//  UltraUI
//
//  Created by John Mai on 2025/2/21.
//

import SwiftUI

@_silgen_name("CGSDefaultConnectionForThread")
func CGSDefaultConnectionForThread() -> CGSConnection?

//@_silgen_name("CGSSetWindowBackgroundBlurRadiusStyle")
//func CGSSetWindowBackgroundBlurRadiusStyle(
//    _ connection: CGSConnection, _ windowNumber: CGWindowID, _ style: Int
//) -> OSStatus
//
//@_silgen_name("CGSSetWindowBackgroundBlurRadiusWithOpacityHint")
//func CGSSetWindowBackgroundBlurRadiusWithOpacityHint(
//    _ connection: CGSConnection, _ windowNumber: CGWindowID, _ radius: Int, _ hint: Int
//) -> OSStatus

@_silgen_name("CGSSetWindowBackgroundBlurRadius")
@discardableResult
func CGSSetWindowBackgroundBlurRadius(
    _ connection: CGSConnection, _ windowNumber: CGWindowID, _ radius: Int
) -> OSStatus

typealias CGSConnection = UInt32
typealias CGWindowID = Int

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
