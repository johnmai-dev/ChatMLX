//
//  MLXProvider.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/13.
//

import Defaults
import Metal
import MLX
import MLXLLM
import MLXRandom
import os
import SwiftUI
import Tokenizers

struct MLXProvider: BaseProvider {
    // MARK: - Properties

    private let displayEveryNTokens = 4
    private let maxTokens = 240
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "MLXProvider")
    private let fileManager = FileManager.default

    // MARK: - Chat

    func chat(
        messages: [[String: String]],
        config: ModelConfig,
        onResult: @escaping ChatResultHandler
    ) async {
        do {
            guard let modelPath = config.model.path else {
                throw LLMRunnerError.modelConfigurationNotSet
            }

            let modelContainer = try await MLXLLM.ModelContainer(
                hub: .init(),
                modelDirectory: modelPath,
                configuration: ModelConfiguration(directory: modelPath)
            )

            let tokens = try await modelContainer.perform { _, tokenizer in
                try tokenizer.applyChatTemplate(messages: messages)
            }

            MLXRandom.seed(UInt64(Date.timeIntervalSinceReferenceDate * 1000))

            let result = await modelContainer.perform {
                model, tokenizer in
                MLXLLM.generate(
                    promptTokens: tokens,
                    parameters: GenerateParameters(from: config),
                    model: model,
                    tokenizer: tokenizer,
                    extraEOSTokens: Set(config.stop ?? [
                        "<|im_end|>",
                        "<|end|>",
                    ])
                ) { tokens in
                    if tokens.count % displayEveryNTokens == 0 {
                        let content = tokenizer.decode(tokens: tokens)
                        onResult(
                            .success(
                                .init(
                                    content: content,
                                    usage: nil
                                )
                            )
                        )
                    }

                    if config.useMaxTokens, tokens.count >= config.maxTokens ?? maxTokens {
                        return .stop
                    } else {
                        return .more
                    }
                }
            }

            onResult(
                .success(
                    .init(
                        content: result.output,
                        usage: .init(
                            promptTokens: result.promptTokens.count,
                            promptTime: result.promptTime,
                            promptTokensPerSecond: result.promptTokensPerSecond,
                            completionTokens: result.tokens.count,
                            completionTime: result.generateTime,
                            completionTokensPerSecond: result.tokensPerSecond,
                            totalTokens: result.tokens.count + result.promptTokens.count
                        )
                    )
                )
            )
        } catch {
            onResult(.failure(error))
        }
    }

    // MARK: - Fetch Models

    static func fetchModels() throws -> [ProviderModel] {
        let fileManager = FileManager.default

        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return []
        }

        let organizations = try fileManager.contentsOfDirectory(
            at: documentsURL.appendingPathComponent("huggingface/models"),
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        )

        guard !organizations.isEmpty else {
            return []
        }

        return try organizations.flatMap { organization -> [ProviderModel] in
            guard organization.hasDirectoryPath else {
                return []
            }

            let huggingfaceModels = try fileManager.contentsOfDirectory(
                at: organization,
                includingPropertiesForKeys: nil,
                options: [.skipsHiddenFiles]
            )

            return try huggingfaceModels.compactMap { model -> ProviderModel? in
                guard model.hasDirectoryPath else {
                    return nil
                }

                let data = try Data(contentsOf: model.appendingPathComponent("tokenizer_config.json"))
                let tokenizerConfig = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                let modelMaxLength = tokenizerConfig?["model_max_length"] as? Int
                let toolCall = (tokenizerConfig?["chat_template"] as? String)?.contains("tool_calls") ?? false
                let vision = false

                return .init(
                    id: model.absoluteString,
                    provider: .mlx,
                    name: model.lastPathComponent,
                    path: model,
                    maxInputLength: modelMaxLength,
                    maxOutputLength: modelMaxLength,
                    toolCall: toolCall,
                    vision: false
                )
            }
        }
    }
}
