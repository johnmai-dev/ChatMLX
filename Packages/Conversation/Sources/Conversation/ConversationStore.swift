//
//  ConversationStore.swift
//  Conversation
//
//  Created by John Mai on 2025/2/22.
//

import Foundation
import Models

@MainActor
@Observable
public final class ConversationStore {
    public var conversations: [Conversation]

    public var selectedConversation: Conversation?

    public init(
        conversations: [Conversation] = [],
        selectedConversation: Conversation? = nil
    ) {
        self.conversations = conversations
        self.selectedConversation = selectedConversation
    }
}
