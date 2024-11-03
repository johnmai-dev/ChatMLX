//
//  ModelInfo.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/14.
//

extension ModelInfo {
    var provider: Provider {
        get { Provider(rawValue: providerRaw) ?? .mlx }
        set { providerRaw = newValue.rawValue }
    }
}

extension ModelInfo: @unchecked Sendable {}
