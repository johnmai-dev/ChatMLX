//
//  OpenAIChatStrategy.swift
//  ChatMLX
//
//  Created by John Mai on 2024/11/10.
//

class OpenAIChatStrategy: ChatStrategy {
    func send(
        model: ProviderModel,
        messages: [[String: String]],
        parameters: ChatParameters?
    ) async throws -> AsyncStream<String> {
        AsyncStream { continuation in
            continuation.yield("OpenAI: \(messages)")
            continuation.finish()
        }
    }
}
