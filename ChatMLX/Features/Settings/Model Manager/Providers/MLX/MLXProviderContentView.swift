//
//  MLXProviderContentView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/26.
//

import CompactSlider
import Defaults
import Luminare
import os
import SwiftUI

struct MLXProviderContentView: View {
    // MARK: - Properties

    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "MLXProviderContentView")
    let persistenceController = PersistenceController.shared

    // MARK: - State

    @State private var isPresentedImport = false
    @State var providerModels: [ProviderModel] = []

    // MARK: - Environment

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.appError) private var appError

    // MARK: - Fetch Request

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ModelInfo.name, ascending: true)],
        predicate: NSPredicate(format: "providerRaw == %@", Provider.mlx.rawValue),
        animation: .default
    ) var models: FetchedResults<ModelInfo>

    // MARK: - User Defaults

    @Default(.enableGPUMemorySettings) var enableGPUMemorySettings

    var body: some View {
        DividedVStack {
            LabeledToggle(title: "Enable GPU Memory Settings", isOn: $enableGPUMemorySettings)
            GPUMemorySettingsView()
            modelListView()
        }
        .labeledContentStyle(.horizontal)
    }
}

// MARK: - Views

extension MLXProviderContentView {
    // MARK: - Model List View

    @ViewBuilder
    private func modelListView() -> some View {
        LabeledContent {
            List {
                ForEach(providerModels, id: \.self) {
                    MLXProviderModelItemView(
                        model: $0,
                        onDelete: onDelete
                    )
                }
                .padding(.horizontal, -8)
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .frame(height: 200)
            .scrollContentBackground(.hidden)
        } label: {
            HStack {
                Text("Model List")
                Spacer()
                Button(action: {
                    isPresentedImport = true
                }) {
                    Label("Import", systemImage: "plus.circle")
                        .padding(5)
                }
                .buttonStyle(LuminareCompactButtonStyle(extraCompact: true))
                .fileImporter(
                    isPresented: $isPresentedImport,
                    allowedContentTypes: [.folder],
                    allowsMultipleSelection: false
                ) { result in
                    handleImport(result)
                }
            }
            .frame(height: 35)
            
        }
        .padding(.horizontal)
        .labeledContentStyle(.vertical)
        .compactSliderSecondaryColor(.white)
        .task {
            try! await loadProviderModels()
        }
    }
}

// MARK: - Private Methods

extension MLXProviderContentView {
    private func handleImport(_ result: Result<[URL], Error>) {
        Task {
            do {
                switch result {
                case .success(let urls):
                    for url in urls {
                        let model = ModelInfo(context: viewContext)
                        model.id = url.absoluteString
                        model.name = url.lastPathComponent
                        model.path = url
                        model.provider = .mlx
                    }
                    try viewContext.save()
                    try await loadProviderModels()
                case .failure(let error):
                    throw error
                }
            } catch {
                appError(error)
            }
        }
    }

    // MARK: - Delete

    private func onDelete(_ model: ProviderModel) {
        Task {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

            if let path = model.path {
                if path.standardized.path.hasPrefix(documentsURL.appendingPathComponent("huggingface/models").standardized.path) {
                    try? FileManager.default.removeItem(at: path)
                } else {
                    if let model = models.first(where: { $0.id == model.id }) {
                        viewContext.delete(model)
                        try? viewContext.save()
                    }
                }
                try? await loadProviderModels()
            }
        }
    }

    // MARK: - Open Directory

    private func openDirectory(_ path: URL?) {
        if let path {
            NSWorkspace.shared.open(path)
        }
    }

    // MARK: - Load Provider Models

    private func loadProviderModels() async throws {
        var models = try MLXProvider.fetchModels()

        for model in self.models {
            if let index = models.firstIndex(where: { $0.id == model.id }) {
                models[index] = ProviderModel(from: model)
            } else {
                models.append(ProviderModel(from: model))
            }
        }

        await MainActor.run {
            providerModels = models
        }
    }
}
