//
//  ModelPicker.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/20.
//

import Defaults
import SwiftUI

struct ModelPicker: View {
    @Binding var selection: ModelInfo?
    @Default(.enableOpenAI) private var enableOpenAI
    @State var models: [ProviderModel] = []

    var groupedModels: [String: [ProviderModel]] {
        var models: [ProviderModel] = []
        do {
            models = try MLXProvider.fetchModels()
        } catch {
            print("Error fetching models")
        }

        if enableOpenAI {
            models = models + OpenAIProvider.fetchModels()
        }

        return Dictionary(grouping: models) { $0.provider.rawValue }
    }

    var body: some View {
        Picker(
            selection: $selection,
            label: Image(systemName: "brain")
        ) {
            Text("Not selected").tag(nil as ModelInfo?)
            ForEach(groupedModels.keys.sorted(), id: \.self) { provider in
                Section(header: Text(provider)) {
                    ForEach(groupedModels[provider]!, id: \.self) { model in
                        Text(model.name ?? model.id).tag(model)
                    }
                }
            }
        }
        .pickerStyle(.menu)
        .labelsHidden()
        .tint(.white)
        .task {
            await fetchModels()
        }
    }

    private func fetchModels() async {
        var models: [ProviderModel] = []
        do {
            models = try MLXProvider.fetchModels()
        } catch {
            print("Error fetching models")
        }

        if enableOpenAI {
            models = models + OpenAIProvider.fetchModels()
        }

        await MainActor.run {
            self.models = models
        }
    }
}
