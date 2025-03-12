//
//  DatabaseMigrations.swift
//  Database
//
//  Created by John Mai on 2025/3/9.
//

import Foundation
import GRDB
import Intelligence

extension Database {
    func createMockData() throws {
        let model = Model(
            provider: .mlx,
            name: "mlx-community/Qwen2.5-VL-7B-Instruct-8bit",
            model: .id("Qwen2.5-VL-7B-Instruct-8bit")
        )

        let conversation = Conversation(title: "What is your name", model: model)
        try conversation.insert(self)

        try Message(
            role: .user,
            content: "What is your name?",
            model: model,
            conversationId: conversation.id
        ).insert(self)

        try Message(
            role: .assistant,
            content:
                "Are you asking about my name? You can call me ChatGPT! 😊Or are you asking for name suggestions for something specific?",
            model: model,
            conversationId: conversation.id
        ).insert(self)

        let conversation2 = Conversation(title: "What can you help with?")
        try conversation2.insert(self)

        try Message(
            role: .user,
            content: "What can you help with?",
            model: model,
            conversationId: conversation2.id
        ).insert(self)

        try Message(
            role: .assistant,
            content:
                "I can help with a variety of topics! I can provide information, answer questions, or just chat with you. What would you like to do?",
            model: model,
            conversationId: conversation2.id
        ).insert(self)
    }
}
