//
//  Provider.swift
//  Intelligence
//
//  Created by John Mai on 2025/3/8.
//

import Foundation

public enum Provider: String, Codable, Sendable {
    case mlx = "MLX"
    case openAI = "OpenAI"
}

extension Provider: CustomStringConvertible {
    public var description: String {
        return rawValue
    }
}
