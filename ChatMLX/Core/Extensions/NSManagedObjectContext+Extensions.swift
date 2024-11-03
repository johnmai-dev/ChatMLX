//
//  NSManagedObjectContext+Extensions.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/19.
//

import CoreData

extension NSManagedObjectContext {
    @discardableResult
    func saveIfNeeded() throws -> Bool {
        guard hasChanges else { return false }
        try save()
        return true
    }
    
    func saveIfNeeded() async throws -> Bool {
        try await perform {
            try self.saveIfNeeded()
        }
    }
}
