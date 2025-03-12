//
//  Repository.swift
//  Database
//
//  Created by John Mai on 2025/3/11.
//

import GRDB

extension AppDatabase {
    public func insert<T: PersistableRecord & Sendable>(_ record: T) async throws {
        try await dbWriter.write { db in
            try record.insert(db)
        }
    }
    
    public func update<T: PersistableRecord & Sendable>(_ record: T) async throws {
        try await dbWriter.write { db in
            try record.update(db)
        }
    }
}
