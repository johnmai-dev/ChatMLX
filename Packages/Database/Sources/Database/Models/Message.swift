//
//  Message.swift
//  Database
//
//  Created by John Mai on 2025/3/8.
//

import Foundation
import GRDB
import Intelligence

public struct Message: Codable, FetchableRecord, Identifiable, Hashable, Equatable, Sendable,
    PersistableRecord
{
    public static func databaseUUIDEncodingStrategy(
        for column: String
    ) -> DatabaseUUIDEncodingStrategy {
        .uppercaseString
    }

    public var id: UUID
    public var role: Role
    public var content: String
    public var reasoning: String?
    public var model: Model
    public var conversationId: UUID
    public var createdAt: Date
    public var updatedAt: Date

    public init(
        id: UUID = UUID(),
        role: Role,
        content: String,
        model: Model,
        conversationId: UUID,
        reasoning: String? = nil,
        createdAt: Date = .init(),
        updatedAt: Date = .init()
    ) {
        self.id = id
        self.role = role
        self.content = content
        self.model = model
        self.conversationId = conversationId
        self.reasoning = reasoning
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension Message: TableRecord {
    static let messageAssets = hasMany(MessageAsset.self)
    static let assets = hasMany(Asset.self, through: messageAssets, using: MessageAsset.asset)
}
