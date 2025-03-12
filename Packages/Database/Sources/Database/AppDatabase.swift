//
//  AppDatabase.swift
//  Database
//
//  Created by John Mai on 2025/3/9.
//

import Foundation
import GRDB
import SwiftUI

public final class AppDatabase: Sendable {

    public static let shared = makeShared()

    let dbWriter: any DatabaseWriter

    public var reader: any DatabaseReader {
        dbWriter
    }

    init(_ dbWriter: any GRDB.DatabaseWriter) throws {
        self.dbWriter = dbWriter
    }

    public static func makeShared(inMemory: Bool = false) -> Self {
        do {
            let database = try createDatabase(
                configuration: createConfiguration(),
                inMemory: inMemory
            )

            try configureMigrations().migrate(database)

            return try Self(database)
        } catch {
            fatalError("Failed to create database: \(error)")
        }
    }

    private static func createDatabase(
        configuration: Configuration,
        inMemory: Bool = false
    ) throws -> any DatabaseWriter {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == nil && !inMemory {
            let path = URL.documentsDirectory.appending(component: "db.sqlite").path()

            #if DEBUG
                print("Database Path: \(path)")
            #endif

            return try DatabasePool(path: path, configuration: configuration)
        } else {
            return try DatabaseQueue(configuration: configuration)
        }
    }
}

extension EnvironmentValues {
    @Entry public var appDatabase: AppDatabase = .makeShared(inMemory: true)
}

extension View {
    public func appDatabase(_ appDatabase: AppDatabase) -> some View {
        self.environment(\.appDatabase, appDatabase)
    }
}
