//
//  ChatService.swift
//  ChatMLX
//
//  Created by John Mai on 2024/11/10.
//

class ChatService {
    private var strategy: ChatStrategy
    private var model: ProviderModel

    init(_ model: ProviderModel) {
        self.model = model

        let provider: Provider =
            switch model.id {
            case .id(_, let provider):
                provider
            case .directory(_, let provider):
                provider
            }

        switch provider {
        case .mlx:
            strategy = MLXChatStrategy()
        case .openAI:
            strategy = OpenAIChatStrategy()
        }
    }

    func setStrategy(_ strategy: ChatStrategy) {
        self.strategy = strategy
    }

    func send(messages: [[String: String]], parameters: ChatParameters) async throws -> AsyncStream<String> {
        try await strategy.send(
            model: model,
            messages: messages,
            parameters: parameters
        )
    }
}
