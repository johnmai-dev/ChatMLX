//
//  DatabaseMigrations.swift
//  Database
//
//  Created by John Mai on 2025/3/9.
//

import Foundation
import GRDB

extension AppDatabase {
    static func configureMigrations() -> DatabaseMigrator {
        var migrator = DatabaseMigrator()

        #if DEBUG
            migrator.eraseDatabaseOnSchemaChange = true
        #endif

        migrator.registerMigration("v1") { db in
            try db.create(table: "conversation") { table in
                table.column("id", .text).primaryKey()
                table.column("title", .text)
                table.column("description", .text)
                table.column("model", .jsonb)
                table.column("isInferring", .boolean).notNull().defaults(to: false)
                table.column("createdAt", .datetime)
                table.column("updatedAt", .datetime)
            }

            try db.create(table: "message") { table in
                table.column("id", .text).primaryKey()
                table.column("role", .text).notNull()
                table.column("content", .text).notNull()
                table.column("reasoning", .text)
                table.column("model", .jsonb)
                table.belongsTo("conversation", onDelete: .cascade).notNull()
                table.column("createdAt", .datetime).notNull()
                table.column("updatedAt", .datetime).notNull()
            }

            try db.create(table: "asset") { table in
                table.column("id", .text).primaryKey()
                table.column("type", .text).notNull()
                table.column("name", .text).notNull()
                table.column("size", .integer).notNull()
                table.column("url", .text).notNull()
                table.column("hash", .text).notNull()
                table.column("metadata", .jsonb)
                table.column("createdAt", .datetime).notNull()
                table.column("updatedAt", .datetime).notNull()
            }

            try db.create(table: "messageAsset") { table in
                table.belongsTo("message", onDelete: .cascade).notNull()
                table.belongsTo("asset", onDelete: .setNull)
            }

        }

        #if DEBUG
            migrator.registerMigration("Add mock data") { db in
                try db.createMockData()
            }
        #endif

        return migrator
    }
}
