//
//  Message.swift
//  Models
//
//  Created by John Mai on 2025/2/22.
//

import Foundation

public struct Message: Identifiable, Equatable, Hashable {
    public static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }

    public var id = UUID()
    public var role: String
    public var content: String
    public var reasoning: String
    public var model: Model
    public var provider: String
    public var error: String
    public var tools: [String]
    public var parent: Message.ID?
    public var children: [Message.ID]
    public var createdTime: Date
    public var updatedTime: Date
}
