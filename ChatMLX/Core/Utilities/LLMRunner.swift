//
//  LLMRunner.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/24.
//

import Defaults
import Metal
import MLX
import MLXLLM
import MLXRandom
import SwiftUI
import Tokenizers
import os

@Observable
@MainActor
class LLMRunner {
    var running = false
    var model: ModelInfo?
    
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "LLMRunner")

    enum LoadState {
        case idle
        case loaded(ModelContainer)
    }

    @ObservationIgnored
    var loadState: LoadState = .idle

    @ObservationIgnored
    var modelConfiguration: ModelConfiguration?

    var gpuActiveMemory: Int = 0

    let displayEveryNTokens = 4

    init() {}

    private func load() async throws -> ModelContainer? {
        guard let modelConfiguration else {
            throw LLMRunnerError.modelConfigurationNotSet
        }

        switch loadState {
        case .idle:

            let enableGPUMemorySettings = Defaults[.enableGPUMemorySettings]
            if enableGPUMemorySettings {
                let cacheLimit = Defaults[.gpuCacheLimit] * 1024 * 1024
                MLX.GPU.set(cacheLimit: cacheLimit)

                let memoryLimit = Defaults[.gpuMemoryLimit] * 1024 * 1024
                MLX.GPU.set(memoryLimit: memoryLimit)
            }

//            let modelContainer = try await MLXLLM.loadModelContainer(
//                configuration: modelConfiguration
//            )

            let modelContainer = try await MLXLLM.ModelContainer(
                hub: .init(), modelDirectory: URL(fileURLWithPath: "/Users/john/Downloads/Llama-3.2-1B-Instruct-4bit"), configuration: modelConfiguration
            )

            withAnimation {
                gpuActiveMemory = MLX.GPU.activeMemory / 1024 / 1024
            }

            loadState = .loaded(modelContainer)
            return modelContainer

        case .loaded(let modelContainer):
            return modelContainer
        }
    }

    private func switchModel(_ conversation: Conversation) {
//        if conversation.model != modelConfiguration?.name {
//            loadState = .idle
//            modelConfiguration = ModelConfiguration.configuration(
//                id: conversation.model)
//        }
    }

    func prepare(_ conversation: Conversation) -> [[String: String]] {
        var messages = conversation.messages
        if conversation.useMaxMessagesLimit {
            let maxCount = conversation.maxMessagesLimit + 1
            if messages.count > maxCount {
                messages = Array(messages.suffix(Int(maxCount)))
                if messages.first?.role != .user {
                    messages = Array(messages.dropFirst())
                }
            }
        }

        var dictionary = messages[..<(messages.count - 1)].map {
            message -> [String: String] in
            message.format()
        }

//        if conversation.useSystemPrompt, !conversation.systemPrompt.isEmpty {
//            dictionary.insert(
//                formatMessage(
//                    role: .system,
//                    content: conversation.systemPrompt
//                ),
//                at: 0
//            )
//        }

        return dictionary
    }

    func formatMessage(role: Role, content: String) -> [String: String] {
        [
            "role": role.rawValue,
            "content": content,
        ]
    }

//    func generate2(
//        conversation: Conversation,
//        in context: NSManagedObjectContext,
//        progressing: @escaping () -> Void = {},
//        completion: (() -> Void)?
//    ) {
//        let service = ChatService()
//
//        Task{
//            await service.chat(
//                model: .init(
//                    name: "Llama-3.2mo-1B-Instruct-4bit",
//                    path: URL(fileURLWithPath: "Llama-3.2-1B-Instruct-4bit"),
//                ),
//                conversation: conversation,
//                context: context
//            )
//
//        }
//    }

    func generate(
        conversation: Conversation,
        in context: NSManagedObjectContext,
        progressing: @escaping () -> Void = {},
        completion: (() -> Void)?
    ) {
        guard !running else { return }
        withAnimation {
            running = true
        }

        let assistantMessage: Message = if let message = conversation.messages.last, message.role == .assistant {
            message
        } else {
            Message(context: context).assistant(conversation: conversation)
        }

        let parameters = GenerateParameters(
            temperature: conversation.temperature,
            topP: conversation.topP,
            repetitionPenalty: conversation.useRepetitionPenalty
                ? conversation.repetitionPenalty : nil,
            repetitionContextSize: Int(conversation.repetitionContextSize)
        )

        let useMaxLength = conversation.useMaxLength
        let maxLength = conversation.maxLength

        Task {
            do {
                switchModel(conversation)

                if let modelConfiguration {
                    guard let modelContainer = try await load() else {
                        throw LLMRunnerError.failedToLoadModel
                    }

                    let messages = prepare(conversation)

                    logger.info("prepare messages -> \(messages)")

                    let tokens = try await modelContainer.perform { _, tokenizer in
                        try tokenizer.applyChatTemplate(messages: messages)
                    }

                    MLXRandom.seed(UInt64(Date.timeIntervalSinceReferenceDate * 1000))

                    let result = await modelContainer.perform { model, tokenizer in
                        MLXLLM.generate(
                            promptTokens: tokens,
                            parameters: parameters,
                            model: model,
                            tokenizer: tokenizer,
                            extraEOSTokens: modelConfiguration.extraEOSTokens.union([
                                "<|im_end|>", "<|end|>",
                            ])
                        ) { tokens in
                            if tokens.count % displayEveryNTokens == 0 {
                                let text = tokenizer.decode(tokens: tokens)
                                Task { @MainActor in
                                    assistantMessage.content = text
                                    progressing()
                                }
                            }

                            if useMaxLength, tokens.count >= maxLength {
                                return .stop
                            }

                            return .more
                        }
                    }

                    conversation.promptTime = result.promptTime
                    conversation.generateTime = result.generateTime
                    conversation.promptTokensPerSecond = result.promptTokensPerSecond
                    conversation.tokensPerSecond = result.tokensPerSecond

                    await MainActor.run {
                        if result.output != assistantMessage.content {
                            assistantMessage.content = result.output
                        }

                        assistantMessage.inferring = false
                        running = false
                    }
                }
            } catch {
                logger.error("LLM Generate Failed: \(error)")
                await MainActor.run {
                    assistantMessage.inferring = false
                    assistantMessage.error = error.localizedDescription
                    withAnimation {
                        running = false
                    }
                }
            }

            Task(priority: .background) {
                await context.perform {
                    if context.hasChanges {
                        try? context.save()
                    }
                }
            }

            completion?()
        }
    }
}

enum LLMRunnerError: Error {
    case modelConfigurationNotSet
    case failedToLoadModel
}
