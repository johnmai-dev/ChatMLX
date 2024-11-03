//
//  Persistence.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/2.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        return controller
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ChatMLX")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        container.viewContext.automaticallyMergesChangesFromParent = true

        if let description = container.persistentStoreDescriptions.first {
            description.shouldMigrateStoreAutomatically = true
            description.shouldInferMappingModelAutomatically = false
        }

        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }

    func newBackgroundContext() -> NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        return context
    }

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

//    func exisits<T: NSManagedObject>(
//        _ model: T,
//        in context: NSManagedObjectContext
//    ) -> T? {
//        try? context.existingObject(with: model.objectID) as? T
//    }
//
//    func delete(_ model: some NSManagedObject) throws {
//        if let existingContact = exisits(model, in: container.viewContext) {
//            container.viewContext.delete(existingContact)
//            Task(priority: .background) {
//                try await container.viewContext.perform {
//                    try container.viewContext.save()
//                }
//            }
//        }
//    }
//
//    func clear(_ entityName: String) throws -> [NSManagedObjectID] {
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(
//            entityName: entityName)
//        let batchDeteleRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        batchDeteleRequest.resultType = .resultTypeObjectIDs
//
//        if let fetchResult = try container.viewContext.execute(batchDeteleRequest)
//            as? NSBatchDeleteResult,
//            let deletedManagedObjectIds = fetchResult.result as? [NSManagedObjectID],
//            !deletedManagedObjectIds.isEmpty
//        {
//            return deletedManagedObjectIds
//        }
//
//        return []
//    }
//
    func save() throws {
        Task.detached(priority: .background) {
            try await viewContext.saveIfNeeded()
        }
    }

    func executeAndMergeChanges(using request: NSBatchDeleteRequest, in context: NSManagedObjectContext) throws {
        try executeAndMergeChanges(using: [request], in: context)
    }

    func executeAndMergeChanges(using requests: [NSBatchDeleteRequest], in context: NSManagedObjectContext) throws {
        let changes = try requests.flatMap { try execute(request: $0, in: context) }
        mergeChanges(changes)
    }

    private func execute(request: NSBatchDeleteRequest, in context: NSManagedObjectContext) throws -> [NSManagedObjectID] {
        request.resultType = .resultTypeObjectIDs
        let result = try context.execute(request) as? NSBatchDeleteResult
        return result?.result as? [NSManagedObjectID] ?? []
    }

    private func mergeChanges(
        _ changes: [NSManagedObjectID],
        in context: NSManagedObjectContext? = nil
    ) {
        guard !changes.isEmpty else { return }

        NSManagedObjectContext.mergeChanges(
            fromRemoteContextSave: [NSDeletedObjectsKey: changes],
            into: [context ?? viewContext]
        )
    }

    func delete(
        _ id: NSManagedObjectID,
        in context: NSManagedObjectContext,
        saveImmediately: Bool = true
    ) throws {
        let object = try context.existingObject(with: id)
        context.delete(object)
        if saveImmediately {
            try save()
        }
    }
}
