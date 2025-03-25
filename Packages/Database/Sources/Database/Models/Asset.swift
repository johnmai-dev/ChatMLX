//
//  Asset.swift
//  Database
//
//  Created by John Mai on 2025/3/8.
//

import Foundation
import GRDB

struct Asset: TableRecord {
    var id: UUID
    var type: String
    var name: String
    var size: Int
    var url: URL
    var hash: String
    var metadata: [String: String]
    var createdAt: Date
    var updatedAt: Date

    static let messageAssets = hasMany(MessageAsset.self)
    static let messages = hasMany(Message.self, through: messageAssets, using: MessageAsset.message)
}
