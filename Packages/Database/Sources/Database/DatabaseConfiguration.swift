//
//  DatabaseConfiguration.swift
//  Database
//
//  Created by John Mai on 2025/3/9.
//

import Foundation
import GRDB

extension AppDatabase {
    static func createConfiguration() -> Configuration {
        var configuration = Configuration()
        configuration.foreignKeysEnabled = true

//        #if DEBUG
//            configuration.prepareDatabase { db in
//                db.trace(options: .profile) { print($0.expandedDescription) }
//            }
//        #endif

        return configuration
    }
}
