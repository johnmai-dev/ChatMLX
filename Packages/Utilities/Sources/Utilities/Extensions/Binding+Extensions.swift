//
//  Binding+Extensions.swift
//  Utilities
//
//  Created by John Mai on 2025/3/1.
//

import SwiftUI

extension Binding {
    public func toUnwrapped<T: Sendable>(defaultValue: T) -> Binding<T> where Value == T? {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}

extension Binding where Value: Sendable {
    public func asDouble() -> Binding<Double> where Value: BinaryInteger {
        Binding<Double>(
            get: { Double(self.wrappedValue) },
            set: { self.wrappedValue = Value($0) }
        )
    }
    
    public func asFloat() -> Binding<Float> where Value: BinaryInteger {
        Binding<Float>(
            get: { Float(self.wrappedValue) },
            set: { self.wrappedValue = Value($0) }
        )
    }
    
    
    public func asFloatOrNil<T: BinaryInteger>() -> Binding<Float> where Value == Optional<T> {
        return Binding<Float>(
            get: { self.wrappedValue.map(Float.init) ?? 0 },
            set: { value in
                if value == 0 {
                    self.wrappedValue = nil
                } else {
                    self.wrappedValue = T(value)
                }
            }
        )
    }
  
}
