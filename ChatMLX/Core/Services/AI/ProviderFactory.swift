//
//  ProviderFactory.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/13.
//

import Defaults

actor ProviderFactory {
    static let shared = ProviderFactory()

    private init() {}

    private var providers: [Provider: BaseProvider] = [:]

    func provider(_ type: Provider) async -> BaseProvider {
        if let provider = providers[type] {
            return provider
        }

        let provider: BaseProvider = switch type {
        case .mlx:
            MLXProvider()
        case .openAI:
            OpenAIProvider()
        }

        providers[type] = provider

        return provider
    }
    
//    func fetchModels() -> [ProviderModel] {
//        var models: [ProviderModel] = []
//        
//        models = models + MLXProvider.fetchModels()
//        
//        if Defaults[.enableOpenAI] {
//            models = models + OpenAIProvider.fetchModels()
//        }
//        
//        return models
//    }
}
