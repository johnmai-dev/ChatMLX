//
//  ModelPicker.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/20.
//

import Defaults
import SwiftUI

struct ModelPicker: View {
    @Binding var selection: ProviderModel.Identifier?
    let models: [ProviderModel]

    var groupedModels: [String: [ProviderModel]] {
        Dictionary(grouping: models) {
            switch $0.id {
            case .id(_, let provider), .directory(_, let provider):
                provider.rawValue
            }
        }
    }

    var body: some View {
        Picker(
            selection: $selection,
            label: Image(systemName: "brain")
        ) {
            Text("Not selected").tag(nil as ProviderModel.Identifier?)
            ForEach(groupedModels.keys.sorted(), id: \.self) { provider in
                Section(header: Text(provider)) {
                    ForEach(groupedModels[provider]!) { model in
                        if let name = model.name {
                            Text(name).tag(model.id)
                        } else if case .id(let id, _) = model.id {
                            Text(id).tag(model.id)
                        }
                    }
                }
            }
        }
        .pickerStyle(.menu)
        .labelsHidden()
        .tint(.white)
    }
}
