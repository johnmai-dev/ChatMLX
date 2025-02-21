//
//  MLXService.swift
//  ChatMLX
//
//  Created by John Mai on 2024/11/9.
//

import Foundation

struct MLXService {
    static let shared = MLXService()

    func fetchModels() async throws -> [ProviderModel] {
        let fileManager = FileManager.default

        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else {
            return []
        }

        let organizations = try fileManager.contentsOfDirectory(
            at: documentDirectoryURL.appendingPathComponent("huggingface/models"),
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        )

        guard !organizations.isEmpty else {
            return []
        }

        return try organizations.flatMap { organization -> [ProviderModel] in
            guard organization.hasDirectoryPath else {
                return []
            }

            let huggingfaceModels = try fileManager.contentsOfDirectory(
                at: organization,
                includingPropertiesForKeys: nil,
                options: [.skipsHiddenFiles]
            )

            return try huggingfaceModels.compactMap { model -> ProviderModel? in
                guard model.hasDirectoryPath else {
                    return nil
                }

                let data = try Data(contentsOf: model.appendingPathComponent("tokenizer_config.json"))
                let tokenizerConfig = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                let modelMaxLength = tokenizerConfig?["model_max_length"] as? Int
                let toolCall = (tokenizerConfig?["chat_template"] as? String)?.contains("tool_calls") ?? false
                let vision = false

                return .init(
                    id: .directory(model, .mlx),
                    name: model.lastPathComponent,
                    path: model,
                    maxInputLength: modelMaxLength,
                    maxOutputLength: modelMaxLength,
                    toolCall: toolCall,
                    vision: vision
                )
            }
        }
    }
}
