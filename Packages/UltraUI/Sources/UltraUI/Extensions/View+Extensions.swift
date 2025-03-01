//
//  View+Extensions.swift
//  UltraUI
//
//  Created by John Mai on 2025/2/23.
//

import SwiftUI
import SwiftUIIntrospect

extension View {
    public func shadow() -> some View {
        self.shadow(radius: 6)
    }

    public func ultraWindowStyle() -> some View {
        self.modifier(UltraWindowStyleViewModifier())
    }
}
