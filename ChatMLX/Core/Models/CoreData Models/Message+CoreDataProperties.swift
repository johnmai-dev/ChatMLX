//
//  Message+CoreDataProperties.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/14.
//
//

import CoreData
import Foundation

extension Message {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Message> {
        NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged var content: String
    @NSManaged var createdAt: Date?
    @NSManaged var error: String?
    @NSManaged var inferring: Bool
    @NSManaged var roleRaw: String
    @NSManaged var updatedAt: Date?
    @NSManaged var conversation: Conversation
}

extension Message: Identifiable {}
