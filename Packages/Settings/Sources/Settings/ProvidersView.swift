//
//  ProvidersView.swift
//  Settings
//
//  Created by John Mai on 2025/2/27.
//

import CompactSlider
import Utilities
import Defaults
import SwiftUI
import UltraUI

struct ProvidersView: View {

    @State private var value = 0.5

    @Default(.gpuCacheLimit) var gpuCacheLimit
    @Default(.gpuMemoryLimit) var gpuMemoryLimit

    let defaultSize: CGFloat = 20

    let physicalMemory = ProcessInfo.processInfo.physicalMemory / (1024 * 1024)

    var body: some View {
        VStack {
            UltraSection {
                LabeledContent {
                    CompactSlider(
                        value: $gpuCacheLimit.asFloat(),
                        in: 0 ... Float(physicalMemory),
                        step: 512
                    )
                    .frame(maxHeight: defaultSize)
                    Spacer()
                    Text("\(gpuCacheLimit) MB")
                        .font(.body)
                        .foregroundColor(.secondary)
                } label: {
                    Text("GPU Cache Limit")
                }

                LabeledContent {
                    CompactSlider(
                        value: $gpuMemoryLimit.asFloatOrNil(),
                        in: 0 ... Float(physicalMemory),
                        step: 512
                    )
                    .frame(maxHeight: defaultSize)
                    Spacer()
                    if let gpuMemoryLimit {
                        Text("\(gpuMemoryLimit) MB")
                            .font(.body)
                    } else {
                        Text("Unlimited")
                            .font(.body)
                    }
                    
                } label: {
                    Text("GPU Memory Limit")
                }
            } header: {
                Text("MLX")
                    .fontWeight(.medium)
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    VStack {
        ProvidersView()
            .labeledContentStyle(.horizontal)
            .foregroundStyle(.white)
    }.background(Color.black.opacity(0.5))
}
