//
//  BaseProvider.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/13.
//

import Foundation
import MLXLLM

struct ModelConfig {
    struct Model {
        var name: String
        var path: URL?
    }

    let model: Model
    let temperature: Double? = nil
    let useMaxTokens: Bool = false
    let maxTokens: Int? = nil
    let topP: Double? = nil
    let frequencyPenalty: Double? = nil
    let repetitionContextSize: Int? = nil
    let presencePenalty: Double? = nil
    let stop: [String]? = nil
}

extension GenerateParameters {
    init(from config: ModelConfig) {
        self.init(
            temperature: Float(config.temperature ?? 0.6),
            topP: Float(config.topP ?? 1.0),
            repetitionPenalty: config.frequencyPenalty.map(Float.init),
            repetitionContextSize: config.repetitionContextSize ?? 20
        )
    }
}

extension ModelConfig: Sendable {}

struct Usage {
    let promptTokens: Int?
    let promptTime: Double?
    let promptTokensPerSecond: Double?
    let completionTokens: Int?
    let completionTime: Double?
    let completionTokensPerSecond: Double?
    let totalTokens: Int?
}

struct ChatResult {
    let content: String
    let usage: Usage?
}

typealias ChatResultHandler = (Result<ChatResult, any Error>) -> Void

//enum ProviderModel {
//    case name(String)
//    case path(URL)
//}

protocol BaseProvider {
    func chat(
        messages: [[String: String]],
        config: ModelConfig,
        onResult: @escaping ChatResultHandler
    ) async

    static func fetchModels() throws -> [ProviderModel]
}
