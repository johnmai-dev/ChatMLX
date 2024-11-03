//
//  GPUMemorySettingsView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/26.
//

import CompactSlider
import Defaults
import SwiftUI

struct GPUMemorySettingsView: View {
    @Default(.enableGPUMemorySettings) var enableGPUMemorySettings
    @Default(.gpuCacheLimit) var gpuCacheLimit
    @Default(.gpuMemoryLimit) var gpuMemoryLimit

    let maxRAM = ProcessInfo.processInfo.physicalMemory / (1024 * 1024)

    var body: some View {
        if enableGPUMemorySettings {
            LabeledContent("GPU Cache Limit") {
                CompactSlider(
                    value: $gpuCacheLimit.asDouble(), in: 0 ... Double(maxRAM), step: 128
                ) {
                    Text("\(Int(gpuCacheLimit))MB")
                        .foregroundStyle(.white)
                }
                .frame(width: 200)
            }

            LabeledContent("GPU Memory Limit") {
                CompactSlider(
                    value: $gpuMemoryLimit.asDouble(), in: 0 ... Double(maxRAM), step: 128
                ) {
                    Text("\(Int(gpuMemoryLimit))MB")
                        .foregroundStyle(.white)
                }
                .frame(width: 200)
            }
        }
    }
}
