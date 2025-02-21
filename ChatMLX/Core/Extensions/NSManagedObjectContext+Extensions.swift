//
//  NSManagedObjectContext+Extensions.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/19.
//

import CoreData

extension NSManagedObjectContext {
    func saveChanges() throws {
        if hasChanges {
            try save()
        }
    }
}
