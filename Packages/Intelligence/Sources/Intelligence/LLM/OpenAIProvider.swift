//
//  OpenAIProvider.swift
//  Intelligence
//
//  Created by John Mai on 2025/3/2.
//

import Foundation
import OpenAI

final class OpenAIProvider: ProviderProtocol {
    func streamingChatCompletion(
        model: Model,
        messages: [ChatCompletionMessage],
        options: ChatCompletionOptions?
    ) async -> AsyncThrowingStream<ChatCompletionStreamChunk, any Error> {
        return AsyncThrowingStream<ChatCompletionStreamChunk, any Error> { continuation in
            Task {
                do {
                    let openAI = OpenAI(apiToken: "YOUR_TOKEN_HERE")

                    for try await result in openAI.chatsStream(
                        query: .init(
                            messages: [
                                .user(.init(content: .string("你好")))
                            ], model: .gpt4_o_mini))
                    {
                        result.choices.forEach { choice in
                            continuation.yield(
                                ChatCompletionStreamChunk(
                                    content: choice.delta.content, finishReason: nil))
                        }
                    }

                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }

    func cancel() async {
        // Not implemented
    }

}
