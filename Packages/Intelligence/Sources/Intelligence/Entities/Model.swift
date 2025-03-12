//
//  Model.swift
//  Intelligence
//
//  Created by John Mai on 2025/3/8.
//

import Foundation

public struct Model: Hashable, Codable, Sendable {
    public let provider: Provider
    public let name: String
    public let model: ModelType

    public init(provider: Provider, name: String, model: ModelType) {
        self.provider = provider
        self.name = name
        self.model = model
    }
}

extension Model: CustomStringConvertible {
    public var description: String {
        return name
    }
}

extension Model: Identifiable {
    public var id: String {
        return "\(provider)-\(name)"
    }
}
