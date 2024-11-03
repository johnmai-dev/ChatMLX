//
//  Conversation+CoreDataProperties.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/14.
//
//

import CoreData
import Foundation

extension Conversation {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Conversation> {
        NSFetchRequest<Conversation>(entityName: "Conversation")
    }

    @NSManaged var createdAt: Date?
    @NSManaged var generateTime: Double
    @NSManaged var inferring: Bool
    @NSManaged var maxLength: Int64
    @NSManaged var maxMessagesLimit: Int32
    @NSManaged var promptTime: Double
    @NSManaged var promptTokensPerSecond: Double
    @NSManaged var repetitionContextSize: Int64
    @NSManaged var repetitionPenalty: Float
    @NSManaged var systemPrompt: String?
    @NSManaged var temperature: Float
    @NSManaged var title: String
    @NSManaged var tokensPerSecond: Double
    @NSManaged var topP: Float
    @NSManaged var updatedAt: Date?
    @NSManaged var useMaxLength: Bool
    @NSManaged var useMaxMessagesLimit: Bool
    @NSManaged var useRepetitionPenalty: Bool
    @NSManaged var useSystemPrompt: Bool
    @NSManaged var messages: [Message]
    @NSManaged var model: ModelInfo?
}

// MARK: Generated accessors for messages

extension Conversation {
    @objc(insertObject:inMessagesAtIndex:)
    @NSManaged func insertIntoMessages(_ value: Message, at idx: Int)

    @objc(removeObjectFromMessagesAtIndex:)
    @NSManaged func removeFromMessages(at idx: Int)

    @objc(insertMessages:atIndexes:)
    @NSManaged func insertIntoMessages(_ values: [Message], at indexes: NSIndexSet)

    @objc(removeMessagesAtIndexes:)
    @NSManaged func removeFromMessages(at indexes: NSIndexSet)

    @objc(replaceObjectInMessagesAtIndex:withObject:)
    @NSManaged func replaceMessages(at idx: Int, with value: Message)

    @objc(replaceMessagesAtIndexes:withMessages:)
    @NSManaged func replaceMessages(at indexes: NSIndexSet, with values: [Message])

    @objc(addMessagesObject:)
    @NSManaged func addToMessages(_ value: Message)

    @objc(removeMessagesObject:)
    @NSManaged func removeFromMessages(_ value: Message)

    @objc(addMessages:)
    @NSManaged func addToMessages(_ values: NSOrderedSet)

    @objc(removeMessages:)
    @NSManaged func removeFromMessages(_ values: NSOrderedSet)
}

extension Conversation: Identifiable {}
