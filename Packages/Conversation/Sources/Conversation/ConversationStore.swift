//
//  ConversationStore.swift
//  Conversation
//
//  Created by John Mai on 2025/2/22.
//

import Database
import Foundation
import GRDB
import Intelligence
import SwiftUI

@MainActor
@Observable
public final class ConversationStore {

    public var conversations: [Conversation] = []

    public var currentMessages: [Message] = []

    public var selectedConversation: Conversation? = nil

    public var prompt: AttributedString = ""

    public var model: Model?

    public var isLoadMessages: Bool = false
    public var hasReachedTop: Bool = false

    private var database: AppDatabase = .shared

    public init() {}

    func loadConversations() async throws {
        let conversations = try await database.reader.read { db in
            try Conversation
                .order(Column("updatedAt"))
                .fetchAll(db)
        }
        withAnimation {
            self.conversations = conversations
        }
    }

    private func fetchMessages() async throws -> [Message] {
        let messages = try await database.reader.read {
            [selectedConversation] db in
            try Message
                .filter(Column("conversationId") == selectedConversation?.id.uuidString)
                .order(Column("createdAt"))
//                .order(Column("createdAt").desc)
//                .limit(10)
                .fetchAll(db)
        }

        return Array(messages.reversed())
    }

//    func loadMessagesIfNeeded() async throws {
//        guard !hasReachedTop, !isLoadMessages else {
//            return
//        }
//
//        guard let selectedConversation = selectedConversation else {
//            return
//        }
//
//        isLoadMessages = true
//
//        defer {
//            isLoadMessages = false
//        }
//
//        if currentMessages.isEmpty {
//            let messages = try await fetchMessages()
//            withAnimation {
//                self.currentMessages = messages
//            }
//            return
//        }
//
//        let pageSize = 10
//
//        let earliestDate = currentMessages.first?.createdAt
//
//        let olderMessages = try await database.reader.read { [selectedConversation] db in
//            try Message
//                .filter(Column("conversationId") == selectedConversation.id.uuidString)
//                .filter(earliestDate == nil || Column("createdAt") < earliestDate!)
//                .order(Column("createdAt").desc)
//                .limit(pageSize)
//                .fetchAll(db)
//                .sorted(by: { $0.createdAt < $1.createdAt })  // 确保按时间正序排列
//        }
//
//        if olderMessages.isEmpty {
//            hasReachedTop = true
//            return
//        }
//
//        withAnimation {
//            self.currentMessages.insert(contentsOf: olderMessages, at: 0)
//        }
//    }

    func createConversation() async throws {
        let conversation = Conversation()
        withAnimation {
            self.selectedConversation = conversation
            self.currentMessages = []
            self.conversations.insert(conversation, at: 0)
            hasReachedTop = false  // 重置标志
        }

        Task {
            try await database.insert(conversation)
        }
    }

    func switchToConversation(_ conversation: Conversation) async throws {
        withAnimation {
            currentMessages = []
            selectedConversation = selectedConversation != conversation ? conversation : nil
            hasReachedTop = false
        }

        if selectedConversation != nil {
            let messages = try await fetchMessages()

            withAnimation {
                self.currentMessages = messages
            }
        }
    }

    func send() async throws {
        guard !(selectedConversation?.isInferring ?? false), let model, !prompt.characters.isEmpty
        else {
            return
        }

        let prompt: String = String(self.prompt.characters)

        self.prompt = ""

        var conversation = selectedConversation ?? Conversation()
        conversation.model = self.model
        conversation.isInferring = true

        withAnimation {
            selectedConversation = conversation
        }

        Task {
            try await self.database.update(conversation)
        }

        defer {
            conversation.isInferring = false
            selectedConversation = conversation
            Task {
                try await self.database.update(conversation)
            }
        }

        let userMessage = Message(
            role: .user,
            content: prompt,
            model: conversation.model!,
            conversationId: conversation.id
        )
        currentMessages.append(userMessage)

        Task {
            try await self.database.insert(userMessage)
        }

        let provider = ProviderFactory.createProvider(provider: model.provider)

        var messages: [ChatCompletionMessage] = []

        for message in self.currentMessages {
            messages.append(
                ChatCompletionMessage(
                    role: message.role,
                    content: message.content
                )
            )
        }

        let stream = await provider.streamingChatCompletion(
            model: model,
            messages: messages,
            options: .none
        )

        var assistantMessage = Message(
            role: .assistant,
            content: "",
            model: conversation.model!,
            conversationId: conversation.id
        )
        currentMessages.append(assistantMessage)

        Task {
            try await self.database.insert(assistantMessage)
        }

        var lastUpdate = Date()

        for try await chunk in stream {
            guard let content = chunk.content else {
                continue
            }

            if lastUpdate.timeIntervalSinceNow < -0.2 || chunk.finishReason != nil {
                assistantMessage.content = content

                if let index = currentMessages.firstIndex(where: { $0.id == assistantMessage.id }) {
                    currentMessages[index] = assistantMessage
                }

                if selectedConversation?.id != assistantMessage.conversationId {
                    Task {
                        try await self.database.update(assistantMessage)
                    }
                }

                lastUpdate = Date()
            }
        }

        Task {
            try await self.database.update(assistantMessage)
        }
    }
}
