//
//  MLXChatService.swift
//  ChatMLX
//
//  Created by John Mai on 2024/11/10.
//

import Defaults
import MLX
import MLXLLM
import MLXRandom
import Metal
import SwiftUI
import Tokenizers
import os

actor MLXModelManager {
    enum LoadState {
        case idle
        case loaded(ProviderModel, ModelContainer)
    }

    var state: LoadState = .idle
    var running: Bool = false

    func load(model: ProviderModel) async throws -> ModelContainer? {
        switch state {
        case .idle:
            MLX.GPU.set(cacheLimit: 20 * 1024 * 1024)

            guard case .directory(let modelURL, _) = model.id else {
                return nil
            }

            let modelConfiguration = ModelConfiguration(directory: modelURL)
            let modelContainer = try await MLXLLM.loadModelContainer(configuration: modelConfiguration)

            state = .loaded(model, modelContainer)

            return modelContainer
        case .loaded(let m, let modelContainer):
            if model != m {
                state = .idle
                return try await load(model: model)
            }

            return modelContainer
        }
    }
}

class MLXChatStrategy: ChatStrategy {
    func send(
        model: ProviderModel,
        messages: [[String: String]],
        parameters: ChatParameters? = nil
    ) async throws -> AsyncStream<String> {
        AsyncStream { continuation in
            Task {
                let manager = MLXModelManager()

                guard let modelContainer = try await manager.load(model: model) else {
                    continuation.finish()
                    return
                }

                let promptTokens = try await modelContainer.perform { _, tokenizer in
                    try tokenizer.applyChatTemplate(messages: messages)
                }

                let result = await modelContainer.perform { model, tokenizer in
                    var generateParameters = GenerateParameters()

                    if let parameters {
                        generateParameters.temperature = parameters.temperature
                        generateParameters.topP = parameters.topP
                        generateParameters.repetitionContextSize = parameters.repetitionContextSize
                        generateParameters.repetitionPenalty = parameters.repetitionPenalty
                    }

                    return MLXLLM.generate(
                        promptTokens: promptTokens,
                        parameters: generateParameters,
                        model: model,
                        tokenizer: tokenizer,
                        extraEOSTokens: []
                    ) { tokens in
                        if tokens.count % 4 == 0 {
                            let text = tokenizer.decode(tokens: tokens)
                            continuation.yield(text)
                        }

                        if tokens.count >= parameters?.maxTokens ?? 1024 {
                            return .stop
                        } else {
                            return .more
                        }
                    }
                }

                continuation.yield(result.output)
                continuation.finish()
            }
        }
    }
}
