//
//  Model.swift
//  Models
//
//  Created by John Mai on 2025/2/22.
//

import Foundation

public enum Provider {
    case mlx
    case openAI
}

public enum ModelType: Equatable, Hashable, CustomStringConvertible {
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

public struct Model: Hashable, CustomStringConvertible {
    public let provider: Provider
    public let name: String
    public let model: ModelType

    public init(provider: Provider, name: String, model: ModelType) {
        self.provider = provider
        self.name = name
        self.model = model
    }

    public var description: String {
        return name
    }
}
