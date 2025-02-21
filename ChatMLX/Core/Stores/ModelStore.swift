//
//  ModelStore.swift
//  ChatMLX
//
//  Created by John Mai on 2024/11/9.
//

import Defaults
import SwiftUI

@MainActor
@Observable
final class ModelStore {
    static let shared = ModelStore()

    var models: [ProviderModel] = []

    // Fetch Models
    nonisolated func fetchModels() async {
        do {
            async let mlxModels = try await fetchMLXModels()
            async let openAIModels = await fetchOpenAIModels()

            let (mlxModelsResult, openAIModelsResult) = try await (mlxModels, openAIModels)

            await MainActor.run {
                self.models = mlxModelsResult + openAIModelsResult
            }
        } catch {
            // TODO: Handle error
            print("Error: \(error)")
        }
    }

    // Fetch MLX Models
    private func fetchMLXModels() async throws -> [ProviderModel] {
        try await MLXService.shared.fetchModels()
    }

    // Fetch OpenAI Models
    private func fetchOpenAIModels() async -> [ProviderModel] {
        do {
            guard Defaults[.enableOpenAI] else { return [] }

            let openAIService = OpenAIService(
                apiKey: Defaults[.openAIApiKey],
                baseURL: Defaults[.openAIBaseURL]
            )

            return try await openAIService.fetchModels()
        } catch {
            // TODO: Handle error
            print("Error: \(error)")
        }
        return []
    }

    func model(_ model: ProviderModel.Identifier?) -> ProviderModel? {
        models.first(where: { $0.id == model })
    }
}
