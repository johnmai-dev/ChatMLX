//
//  MLXProvider.swift
//  Intelligence
//
//  Created by John Mai on 2025/3/1.
//

import Foundation
import MLX
import MLXLLM
import MLXLMCommon
import MLXVLM

actor MLXProvider: ProviderProtocol {
    let cacheDir = FileManager.default.homeDirectoryForCurrentUser
        .appendingPathComponent(
            ".cache",
            isDirectory: true
        )
        .appendingPathComponent(
            "huggingface",
            isDirectory: true
        )
        .appendingPathComponent(
            "hub",
            isDirectory: true
        )

    var running = false

    enum LoadState {
        case idle
        case loaded(ModelContainer)
    }

    var loadState = LoadState.idle

    private let supportedVLM = [
        "paligemma",
        "qwen2_vl",
        "idefics3",
    ]

    private let supportedLLM = [
        "mistral",
        "llama",
        "phi",
        "phi3",
        "phimoe",
        "gemma",
        "gemma2",
        "qwen2",
        "starcoder2",
        "cohere",
        "openelm",
        "internlm2",
    ]

    func load(model: Model) async throws -> ModelContainer {
        switch loadState {
        case .idle:
            GPU.set(cacheLimit: 20 * 1024 * 1024)
            
            guard case .local(let modelDirectory) = model.model else {
                fatalError("Model is not local")
            }
                
            let modelConfiguration = ModelConfiguration(directory: modelDirectory)

            let baseConfig = try JSONDecoder().decode(
                BaseConfiguration.self,
                from: Data(
                    contentsOf: modelDirectory.appending(
                        component: "config.json"
                    )
                )
            )

            if supportedVLM.contains(baseConfig.modelType) {
                let modelContainer = try await VLMModelFactory.shared.loadContainer(
                    configuration: modelConfiguration
                )

                loadState = .loaded(modelContainer)
                return modelContainer
            }

            if supportedLLM.contains(baseConfig.modelType) {
                let modelContainer = try await LLMModelFactory.shared.loadContainer(
                    configuration: modelConfiguration
                )

                loadState = .loaded(modelContainer)
                return modelContainer
            }

            fatalError("Revision file not found")
        case .loaded(let modelContainer):
            return modelContainer
        }
    }

    func streamingChatCompletion(
        model: Model,
        messages: [ChatCompletionMessage],
        options: ChatCompletionOptions?
    ) async -> AsyncThrowingStream<ChatCompletionStreamChunk, any Error> {
        return AsyncThrowingStream<ChatCompletionStreamChunk, any Error> { continuation in
            Task {
                do {
                    let modelContainer = try await load(model: model)
                    
                    let result = try await modelContainer.perform { context in
                        
                        var _messages:[Message] = []
                        for message in messages {
                            _messages.append(["role": message.role.rawValue, "content": message.content])
                        }
                            
                        print("messages -> \(_messages)")
                        
                        let input = try await context.processor.prepare(
                            input: .init(messages: _messages, tools: nil))
                        return try MLXLMCommon.generate(
                            input: input,
                            parameters: GenerateParameters(temperature: 0.6),
                            context: context
                        ) { tokens in
                            let text = context.tokenizer.decode(tokens: tokens)

                            let chunk = ChatCompletionStreamChunk(content: text, finishReason: nil)

                            continuation.yield(chunk)

                            if tokens.count >= 8000 {
                                return .stop
                            } else {
                                return .more
                            }
                        }
                    }

                    let chunk = ChatCompletionStreamChunk(content: result.output, finishReason: nil)

                    continuation.yield(chunk)
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }

    func cancel() async {
    }
}
