//
//  Repository.swift
//  ChatMLX
//
//  Created by John Mai on 2024/11/3.
//

import CoreData
import CoreDataEvolution

@NSModelActor
actor Repository {
    @discardableResult
    func createConversation() throws -> NSManagedObjectID {
        let conversation = Conversation(context: modelContext)
        try modelContext.saveChanges()
        return conversation.objectID
    }

    private func deleteConversation(_ conversation: Conversation) throws {
        modelContext.delete(conversation)
        try modelContext.saveChanges()
    }

    func deleteConversation(_ objectID: NSManagedObjectID) throws {
        guard let conversation = self[objectID, as: Conversation.self] else {
            fatalError("Can't load Conversation by ID:\(objectID)")
        }
        try deleteConversation(conversation)
    }

    func deleteMessages(_ messages: [Message]) throws {
        try deleteMessages(messages.map(\.objectID))
    }

    func deleteMessages(_ objectIDs: [NSManagedObjectID]) throws {
        let request = NSBatchDeleteRequest(objectIDs: objectIDs)
        request.resultType = .resultTypeObjectIDs
        let result = try modelContext.execute(request) as? NSBatchDeleteResult
        let changes = result?.result as? [NSManagedObjectID] ?? []
        guard !changes.isEmpty else { return }

        mergeChanges([NSDeletedObjectIDsKey: changes])
    }

    func mergeChanges(_ fromRemoteContextSave: [AnyHashable: Any]) {
        NSManagedObjectContext.mergeChanges(
            fromRemoteContextSave: fromRemoteContextSave,
            into: [modelContainer.viewContext]
        )
    }

    func clearMessages() throws -> [NSManagedObjectID] {
        let request = NSBatchDeleteRequest(fetchRequest: Message.fetchRequest())
        request.resultType = .resultTypeObjectIDs

        let result = try modelContext.execute(request) as? NSBatchDeleteResult

        return result?.result as? [NSManagedObjectID] ?? []
    }

    func clearConversations() throws -> [NSManagedObjectID] {
        let request = NSBatchDeleteRequest(fetchRequest: Conversation.fetchRequest())
        request.resultType = .resultTypeObjectIDs

        let result = try modelContext.execute(request) as? NSBatchDeleteResult

        return result?.result as? [NSManagedObjectID] ?? []
    }

    @discardableResult
    func createMessage(in conversationObjectID: NSManagedObjectID, content: String, role: Role) throws
        -> NSManagedObjectID
    {
        try createMessage(in: conversationObjectID, content: content, role: role).objectID
    }

    @discardableResult
    func createMessage(in conversationObjectID: NSManagedObjectID, content: String, role: Role) throws -> Message {
        guard let conversation = self[conversationObjectID, as: Conversation.self] else {
            fatalError("Can't load Conversation by ID:\(conversationObjectID)")
        }

        let message = Message(context: modelContext)
        message.conversation = conversation
        message.content = content
        message.role = role
        try modelContext.saveChanges()
        return message
    }
}
