//
//  ChatStrategy.swift
//  ChatMLX
//
//  Created by John Mai on 2024/11/10.
//

struct ChatParameters: Sendable {
    var temperature: Float = 0.6
    var topP: Float = 1.0
    var repetitionPenalty: Float?
    var repetitionContextSize: Int = 20
    var extraEOSTokens: Set<String>?
    var maxTokens: Int = 1024

    init(
        temperature: Float = 0.6,
        topP: Float = 1.0,
        repetitionPenalty: Float? = nil,
        repetitionContextSize: Int = 20,
        extraEOSTokens: Set<String>? = nil,
        maxTokens: Int = 1024
    ) {
        self.temperature = temperature
        self.topP = topP
        self.repetitionPenalty = repetitionPenalty
        self.repetitionContextSize = repetitionContextSize
        self.extraEOSTokens = extraEOSTokens
        self.maxTokens = maxTokens
    }
}

protocol ChatStrategy {
    func send(
        model: ProviderModel,
        messages: [[String: String]],
        parameters: ChatParameters?
    ) async throws -> AsyncStream<String>
}
