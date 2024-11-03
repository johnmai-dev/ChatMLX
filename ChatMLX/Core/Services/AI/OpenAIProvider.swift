//
//  OpenAIProvider.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/17.
//

import Defaults
import Foundation
import OpenAI
import SwiftUI

struct OpenAIProvider: BaseProvider {
    static func fetchModels() -> [ProviderModel] {
        [
            // GPT-4o
            .init(
                id: "gpt-4o",
                provider: .openAI,
                name: "GPT-4o",
                maxInputLength: 128000,
                maxOutputLength: 16384,
                toolCall: true,
                vision: true
            ),
            // GPT-4o mini
            .init(
                id: "gpt-4o-mini",
                provider: .openAI,
                name: "GPT-4o Mini",
                maxInputLength: 128000,
                maxOutputLength: 16384,
                toolCall: true,
                vision: true
            ),
            // o1-preview and o1-mini
            .init(
                id: "o1-preview",
                provider: .openAI,
                name: "O1 Preview",
                maxInputLength: 128000,
                maxOutputLength: 32768
            ),
            .init(
                id: "o1-mini",
                provider: .openAI,
                name: "O1 Mini",
                maxInputLength: 128000,
                maxOutputLength: 65536
            ),
            // GPT-4 Turbo and GPT-4
            .init(
                id: "gpt-4-turbo",
                provider: .openAI,
                name: "GPT-4 Turbo",
                maxInputLength: 128000,
                maxOutputLength: 4096
            ),
            .init(
                id: "gpt-4",
                provider: .openAI,
                name: "GPT-4",
                maxInputLength: 8192,
                maxOutputLength: 8192
            ),
            // GPT-3.5 Turbo
            .init(
                id: "gpt-3.5-turbo",
                provider: .openAI,
                name: "GPT-3.5 Turbo",
                maxInputLength: 16385,
                maxOutputLength: 4096
            )
        ]
    }

    func chat(
        messages: [[String: String]],
        config: ModelConfig,
        onResult: @escaping ChatResultHandler
    ) async {
        let apiKey = Defaults[.openAIApiKey]
        let baseURL = Defaults[.openAIBaseURL]

        let client = OpenAI(configuration: .init(token: apiKey, host: baseURL))

        var chatMessages: [ChatQuery.ChatCompletionMessageParam] = []
        for message in messages {
            chatMessages.append(.init(role: message["role"] == "user" ? .user : .assistant, content: message["content"]!)!)
        }

        let query = ChatQuery(messages: chatMessages, model: config.model.name)

        do {
            var content = ""
            for try await result in client.chatsStream(query: query) {
                for choice in result.choices {
                    if let c = choice.delta.content {
                        content += c
                    }
                    onResult(.success(.init(content: content, usage: nil)))
                }
            }
        } catch {
            onResult(.failure(error))
        }
    }
}
