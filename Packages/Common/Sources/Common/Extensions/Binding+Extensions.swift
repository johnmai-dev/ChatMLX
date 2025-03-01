//
//  Binding+Extensions.swift
//  Common
//
//  Created by John Mai on 2025/3/1.
//

import SwiftUI

extension Binding {
    public func toUnwrapped<T: Sendable>(defaultValue: T) -> Binding<T> where Value == T? {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}
