//
//  MessageAsset.swift
//  Database
//
//  Created by John Mai on 2025/3/8.
//

import Foundation
import GRDB

struct MessageAsset:TableRecord {
    static let message = belongsTo(Message.self)
    static let asset = belongsTo(Asset.self)
}
