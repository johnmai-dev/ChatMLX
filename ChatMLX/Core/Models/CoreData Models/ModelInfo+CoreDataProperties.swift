//
//  ModelInfo+CoreDataProperties.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/14.
//
//

import CoreData
import Foundation

extension ModelInfo {
    @nonobjc class func fetchRequest() -> NSFetchRequest<ModelInfo> {
        NSFetchRequest<ModelInfo>(entityName: "ModelInfo")
    }

    @NSManaged var id: String
    @NSManaged var providerRaw: String
    @NSManaged var name: String?
    @NSManaged var path: URL?
    @NSManaged var maxInputLength: Int
    @NSManaged var maxOutputLength: Int
    @NSManaged var toolCall: Bool
    @NSManaged var vision: Bool
}

// MARK: Generated accessors for conversation

extension ModelInfo {
    @objc(addConversationObject:)
    @NSManaged func addToConversation(_ value: Conversation)

    @objc(removeConversationObject:)
    @NSManaged func removeFromConversation(_ value: Conversation)

    @objc(addConversation:)
    @NSManaged func addToConversation(_ values: NSSet)

    @objc(removeConversation:)
    @NSManaged func removeFromConversation(_ values: NSSet)
}

extension ModelInfo: Identifiable {}
