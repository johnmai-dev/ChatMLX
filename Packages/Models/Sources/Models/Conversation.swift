//
//  Conversation.swift
//  Models
//
//  Created by John Mai on 2025/2/22.
//

import Foundation

public struct Conversation: Identifiable {
    public var id = UUID()

    public var title: String

    public var description: String?

    public var model: Model

    public var messages: [Message] = []

    public var current_node: Message.ID?

    public var createdTime: Date

    public var updatedTime: Date

    public init(
        id: UUID = UUID(),
        title: String,
        description: String? = nil,
        model: Model,
        messages: [Message] = [],
        current_node: Message.ID? = nil,
        createdTime: Date = Date(),
        updatedTime: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.model = model
        self.messages = messages
        self.current_node = current_node
        self.createdTime = createdTime
        self.updatedTime = updatedTime
    }
}

extension Conversation: Equatable, Hashable {
    public static func == (lhs: Conversation, rhs: Conversation) -> Bool {
        return lhs.id == rhs.id
    }
}
