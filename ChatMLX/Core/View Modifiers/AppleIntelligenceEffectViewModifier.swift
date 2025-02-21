//
//  AppleIntelligenceEffectViewModifier.swift
//  ChatMLX
//
//  Created by John Mai on 2024/11/9.
//

import Defaults
import SwiftUI

struct AppleIntelligenceEffectViewModifier: ViewModifier {
    @Default(.enableAppleIntelligenceEffect) var enableAppleIntelligenceEffect
    @Default(.appleIntelligenceEffectDisplay) var appleIntelligenceEffectDisplay

    @Binding var isPresented: Bool

    func body(content: Content) -> some View {
        content.overlay {
            if self.enableAppleIntelligenceEffect, self.appleIntelligenceEffectDisplay == .appInternal, self.isPresented
            {
                AppleIntelligenceEffectView(useRoundedRectangle: false)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }
        }
    }
}

extension View {
    func appleIntelligenceEffect(isPresented: Binding<Bool>) -> some View {
        self.modifier(AppleIntelligenceEffectViewModifier(isPresented: isPresented))
    }
}
