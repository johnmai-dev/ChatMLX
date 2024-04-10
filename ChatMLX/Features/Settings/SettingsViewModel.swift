//
//  SettingsViewModel.swift
//
//
//  Created by John Mai on 2024/3/16.
//
import Hub
import SwiftUI

@Observable
public class SettingsViewModel {
    var backButtonVisible: Bool = false
    var scrolledToTop: Bool = false

    var models: [MLXModel] = [
        MLXModel(name: "mlx-community/quantized-gemma-7b-it", recommended: true),
        MLXModel(name: "mlx-community/Mistral-7B-Instruct-v0.2-4bit-mlx", recommended: true),
        MLXModel(name: "mlx-community/Qwen1.5-0.5B-Chat-4bit", recommended: true),
        MLXModel(name: "mlx-community/phi-2-hf-4bit-mlx", recommended: true),
        MLXModel(name: "mlx-community/starcoder2-3b-4bit", recommended: true),
    ]

    public init() {
        loadFromModelDirectory()
    }

    func loadFromModelDirectory() {
        let models = ModelUtility.loadFromModelDirectory()

        var hasActiveModel = false

        for model in models {
            if model == UserDefaults.standard.string(forKey: Preferences.activeModel.rawValue) {
                hasActiveModel = true
            }

            let index = self.models.firstIndex(where: { $0.name == model })
            if index != nil {
                self.models[index!].state = .availabled
            } else {
                var model = MLXModel(name: model)
                model.state = .availabled
                self.models.append(model)
            }
        }

        if !hasActiveModel {
            UserDefaults.standard.removeObject(forKey: Preferences.activeModel.rawValue)
        }
    }

    func download(model: MLXModel) async {
        await MainActor.run {
            let index = models.firstIndex(where: { $0.name == model.name })
            self.models[index!].state = .downloading(progress: 0, totalFileCount: 0, completedFileCount: 0)
        }
        do {
            let repo = Hub.Repo(id: model.name)

            var token: String?
            if let hfToken = UserDefaults.standard.string(
                forKey: Preferences.huggingfaceToken.rawValue), !hfToken.isEmpty
            {
                token = hfToken
            }

            let endpointType =
                UserDefaults.standard.string(
                    forKey: Preferences.huggingfaceEdpointType.rawValue) ?? ""
            var endpoint = endpointType
            if endpoint.isEmpty {
                endpoint =
                    UserDefaults.standard.string(
                        forKey: Preferences.huggingfaceEdpoint.rawValue)
                    ?? HuggingfaceEndpoint.official.rawValue
            }

            let hub = HubApi(hfToken: token, endpoint: endpoint)
            let modelFiles = ["config.json", "*.safetensors"]
            try await hub.snapshot(
                from: repo, matching: modelFiles)
            { progress in
                Task { @MainActor in
                    let index = self.models.firstIndex(where: { $0.name == model.name })
                    self.models[index!].state = .downloading(progress: progress.fractionCompleted, totalFileCount: progress.totalUnitCount, completedFileCount: progress.completedUnitCount)
                }
            }

            await MainActor.run {
                let index = models.firstIndex(where: { $0.name == model.name })
                self.models[index!].state = .availabled
            }
            DispatchQueue.main.async {
                let index = self.models.firstIndex(where: { $0.name == model.name })
                self.models[index!].state = .availabled
            }
        } catch {
        }
        await MainActor.run {
            let index = models.firstIndex(where: { $0.name == model.name })
            self.models[index!].state = .availabled
        }
    }

    func remove(model: MLXModel) {
        let fileManager = FileManager.default

        let modelDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appending(component: "huggingface")
            .appending(component: "models")
            .appending(components: model.name)

        do {
            try fileManager.removeItem(at: modelDirectory)

            let index = models.firstIndex(where: { $0.name == model.name })
            if model.recommended {
                models[index!].state = .unavailable
            } else {
                models.remove(at: index!)
            }
        } catch {
        }
    }

    func add(model: String) {
        let model = MLXModel(name: model)
        models.append(model)
//        download(model: model)
    }
}
