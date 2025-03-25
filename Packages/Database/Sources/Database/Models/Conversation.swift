//
//  Conversation.swift
//  Database
//
//  Created by John Mai on 2025/3/8.
//

import Foundation
import GRDB
import Intelligence

public struct Conversation: Codable, Equatable, Hashable, FetchableRecord, Sendable,
    PersistableRecord
{
    public static func databaseUUIDEncodingStrategy(
        for column: String
    ) -> DatabaseUUIDEncodingStrategy {
        .uppercaseString
    }

    public var id: UUID
    public var title: String?
    public var description: String?
    public var model: Model?
    public var isInferring: Bool
    public var createdAt: Date
    public var updatedAt: Date

    public var titleUnwrapped: String {
        title ?? String(localized: "Untitled")
    }

    enum CodingKeys: String, CodingKey {
        case id, title, description, model, isInferring, createdAt, updatedAt
    }

    public init(
        id: UUID = UUID(),
        title: String? = nil,
        model: Model? = nil,
        isInferring: Bool = false,
        createdAt: Date = .init(),
        updatedAt: Date = .init()
    ) {
        self.id = id
        self.title = title
        self.model = model
        self.isInferring = isInferring
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension Conversation: TableRecord {
    static let messages = hasMany(Message.self)
}
