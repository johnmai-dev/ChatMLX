//
//  Errors.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/27.
//

import Foundation

enum Errors: Error, LocalizedError {
    case documentDirectoryNotFound

    var errorDescription: String? {
        switch self {
        case .documentDirectoryNotFound:
            "Document directory not found."
        }
    }
}
