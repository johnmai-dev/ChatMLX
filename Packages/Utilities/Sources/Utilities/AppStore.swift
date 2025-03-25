//
//  AppStore.swift
//  Utilities
//
//  Created by John Mai on 2025/2/27.
//

import Defaults
import Foundation
import Intelligence

@MainActor
@Observable
public final class AppStore {
    public var models: [Provider: [Model]] = [:]
    public var activeModels: [Model] = []

    let huggingfaceHubService: HuggingfaceHubService = .init()

    public init() {}

    public func loadModels() throws {
        models[.mlx] = try huggingfaceHubService.scanMLXModels()

        let disabledModels = Defaults[.disabledModels]

        activeModels = models.flatMap { $0.value }.filter { model in
            !disabledModels.contains(model.id)
        }
    }
}
