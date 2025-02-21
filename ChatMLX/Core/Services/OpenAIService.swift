//
//  OpenAIService.swift
//  ChatMLX
//
//  Created by John Mai on 2024/11/9.
//

import Defaults
import Foundation
import OpenAI

struct OpenAIService {
    var client: OpenAI

    init(apiKey: String, baseURL: String? = nil) {
        if let baseURL, let url = URL(string: baseURL), let host = url.host {
            self.client = OpenAI(
                configuration: .init(
                    token: apiKey,
                    host: host,
                    port: url.port ?? 443,
                    scheme: url.scheme ?? "https"
                )
            )
        } else {
            self.client = OpenAI(configuration: .init(token: apiKey))
        }
    }

    func fetchModels() async throws -> [ProviderModel] {
        let models = try await client.models()

        return models.data.map { model in
            .init(id: .id(model.id, .openAI))
        }
    }
}
