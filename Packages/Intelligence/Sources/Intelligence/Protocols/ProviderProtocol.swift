//
//  Provider.swift
//  Intelligence
//
//  Created by John Mai on 2025/3/2.
//

public protocol ProviderProtocol: Sendable {
    func streamingChatCompletion(
        model: Model,
        messages: [ChatCompletionMessage],
        options: ChatCompletionOptions?
    ) async -> AsyncThrowingStream<ChatCompletionStreamChunk, Error>

    func cancel() async
}
