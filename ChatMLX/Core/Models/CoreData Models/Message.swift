//
//  Message.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/14.
//

import Foundation

extension Message {
    var role: Role {
        get { Role(rawValue: roleRaw) ?? .user }
        set { roleRaw = newValue.rawValue }
    }

    override func awakeFromInsert() {
        setPrimitiveValue(Date.now, forKey: #keyPath(Message.createdAt))
        setPrimitiveValue(Date.now, forKey: #keyPath(Message.updatedAt))
    }

    override func willSave() {
        super.willSave()
        setPrimitiveValue(Date.now, forKey: #keyPath(Message.updatedAt))
    }

    @discardableResult
    func user(content: String, conversation: Conversation?) -> Self {
        self.role = .user
        self.content = content
        if let conversation {
            self.conversation = conversation
        }
        return self
    }

    @discardableResult
    func assistant(conversation: Conversation?) -> Self {
        self.role = .assistant
        self.inferring = true
        self.content = ""
        if let conversation {
            self.conversation = conversation
        }
        return self
    }

    func format() -> [String: String] {
        [
            "role": self.roleRaw,
            "content": self.content,
        ]
    }

    func suffixMessages() -> [Message] {
        let conversation = self.conversation
        let messages = conversation.messages

        guard let index = messages.firstIndex(of: self) else {
            return []
        }

        return Array(messages[index...])
    }
}

extension Message: @unchecked Sendable {}
