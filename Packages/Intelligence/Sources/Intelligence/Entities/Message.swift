//
//  ChatCompletionMessage.swift
//  Intelligence
//
//  Created by John Mai on 2025/3/9.
//

public struct ChatCompletionMessage: Sendable {
    public var role: Role
    public var content: String
    public var reasoning: String?
    
    public init(role: Role, content: String, reasoning: String? = nil) {
        self.role = role
        self.content = content
        self.reasoning = reasoning
    }
}
