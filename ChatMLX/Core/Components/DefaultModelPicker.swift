//
//  DefaultModelPicker.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/20.
//

import CoreData
import Defaults
import SwiftUI

struct DefaultModelPicker: View {
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \ModelInfo.name, ascending: true)],
//        animation: .default
//    )
//    private var models: FetchedResults<ModelInfo>

    @Binding var provider: Provider
    @Environment(\.managedObjectContext) private var viewContext

    @Default(.defaultModel) var defaultModel

    var models: [ProviderModel] {
        switch provider {
        case .mlx:
            try! MLXProvider.fetchModels()
        case .openAI:
            OpenAIProvider.fetchModels()
        }
    }

    var body: some View {
        Picker(
            selection: $defaultModel,
            label: Image(systemName: "brain")
        ) {
            Text("Not selected").tag(nil as String?)
            Divider()
            ForEach(models, id: \.self) { model in
                Text(model.name ?? model.id).tag(model.id)
            }
        }
        .pickerStyle(.menu)
        .labelsHidden()
        .tint(.white)
    }
}
