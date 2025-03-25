//
//  ProviderFactory.swift
//  Intelligence
//
//  Created by John Mai on 2025/3/2.
//

import Foundation

public final class ProviderFactory {
    public static func createProvider(provider: Provider) -> ProviderProtocol {
        switch provider {
        case .openAI:
            fatalError("OpenAI is not supported yet")
        case .mlx:
            return MLXProvider()
        }
    }
}
