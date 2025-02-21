//
//  ConversationStore.swift
//  ChatMLX
//
//  Created by John Mai on 2024/11/9.
//

import SwiftUI

@MainActor
@Observable
final class ConversationStore {
    static let shared = ConversationStore()

    var selectedConversation: Conversation?

    private let viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    private let repository: Repository = .init(container: PersistenceController.shared.container)

    // Create a new conversation
    nonisolated func createConversation() {
        Task {
            do {
                let objectID = try await repository.createConversation()

                try await MainActor.run {
                    if let conversation = try viewContext.existingObject(with: objectID) as? Conversation {
                        selectConversation(conversation)
                    }
                }
            } catch {
                // TODO: Handle error
            }
        }
    }

    // Select a conversation
    func selectConversation(_ conversation: Conversation) {
        selectedConversation = conversation
    }

    // Delete a conversation
    nonisolated func deleteConversation(_ conversation: Conversation) {
        Task {
            do {
                try await repository.deleteConversation(conversation.objectID)

                await MainActor.run {
                    if selectedConversation == conversation {
                        selectedConversation = nil
                    }
                }
            } catch {
                // TODO: Handle error
            }
        }
    }

    // Delete messages
    nonisolated func deleteMessages(_ messages: [Message]) {
        Task {
            do {
                try await repository.deleteMessages(messages)
            } catch {
                // TODO: Handle error
            }
        }
    }

    // Clear Conversations
    nonisolated func clearConversations() {
        Task {
            let messageObjectIDs = try await repository.clearMessages()
            let conversationObjectIDs = try await repository.clearConversations()

            await MainActor.run {
                selectedConversation = nil
            }

            await repository.mergeChanges([NSDeletedObjectsKey: messageObjectIDs + conversationObjectIDs])
        }
    }

    // Send a message
    func send(conversation: Conversation, model: ProviderModel, content: String = "") async {
        guard !conversation.inferring else { return }
        conversation.inferring = true

        do {
            let service = ChatService(model)

            let assistantMessage: Message =
                if let message = conversation.messages.last, message.role == .assistant {
                    message
                } else {
                    Message(context: viewContext).assistant(conversation: conversation)
                }

            assistantMessage.inferring = true

            let messages = prepare(conversation)

            let responseStream = try await service.send(
                messages: messages,
                parameters: .init(
                    temperature: conversation.temperature,
                    topP: conversation.topP,
                    repetitionPenalty: conversation.useRepetitionPenalty ? conversation.repetitionPenalty : nil,
                    repetitionContextSize: conversation.repetitionContextSize,
                    extraEOSTokens: nil,
                    maxTokens: conversation.maxLength
                )
            )

            assistantMessage.content = ""
            for await response in responseStream {
                assistantMessage.content = response
                print(response)
            }

            assistantMessage.inferring = false
            conversation.inferring = false
            try viewContext.saveChanges()
        } catch {
            // TODO: Handle error
            print("Error: \(error)")
        }
    }

    private func prepare(_ conversation: Conversation) -> [[String: String]] {
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

        let dictionary = messages[..<(messages.count - 1)].map {
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

    private func formatMessage(role: Role, content: String) -> [String: String] {
        [
            "role": role.rawValue,
            "content": content,
        ]
    }
}
