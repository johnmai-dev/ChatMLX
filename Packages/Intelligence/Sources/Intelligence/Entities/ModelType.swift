//
//  ModelType.swift
//  Intelligence
//
//  Created by John Mai on 2025/3/8.
//

import Foundation

public enum ModelType: Equatable, Hashable, CustomStringConvertible, Codable, Sendable {
    case local(URL)
    case id(String)

    public var description: String {
        switch self {
        case .local(let url):
            return url.lastPathComponent
        case .id(let id):
            return id
        }
    }
}
