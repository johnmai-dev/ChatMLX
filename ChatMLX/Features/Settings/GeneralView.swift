//
//  GeneralView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/18.
//

import CompactSlider
import CoreData
import Defaults
import Luminare
import SwiftUI

struct GeneralView: View {
    @Default(.backgroundBlurRadius) var blurRadius
    @Default(.backgroundColor) var backgroundColor
    @Default(.language) var language
    @Default(.gpuCacheLimit) var gpuCacheLimit

    @Environment(ConversationStore.self) private var conversationStore

    let maxRAM = ProcessInfo.processInfo.physicalMemory / (1024 * 1024)

    var body: some View {
        VStack(spacing: 18) {
            LuminareSection("Language") {
                LabeledContent("Language") {
                    Picker(
                        "Language",
                        selection: $language
                    ) {
                        ForEach(Language.allCases) { language in
                            Text(language.displayName).tag(language)
                        }
                    }
                    .buttonStyle(.borderless)
                    .foregroundStyle(.white)
                    .tint(.white)
                }
            }

            LuminareSection("Window Appearance") {
                LabeledContent("Blur") {
                    CompactSlider(value: $blurRadius, in: 0 ... 100) {
                        Text("\(Int(blurRadius))")
                            .foregroundStyle(.white)
                    }
                    .frame(width: 200)
                    .compactSliderSecondaryColor(.white)
                }

                LabeledContent("Color") {
                    ColorPicker("", selection: $backgroundColor)
                }
            }

            LuminareSection("System Settings") {
                Button("Clear All Conversations", action: conversationStore.clearConversations)
                    .frame(height: 35)
                Button("Reset All Settings", action: resetAllSettings)
                    .frame(height: 35)
            }
            .buttonStyle(LuminareDestructiveButtonStyle())

            Spacer()
        }
        .labeledContentStyle(.horizontal)
        .ultramanNavigationTitle("General")
        .padding()
        .labelsHidden()
    }

    private func resetAllSettings() {
        Defaults.removeAll()
    }
}

#Preview {
    GeneralView()
}
