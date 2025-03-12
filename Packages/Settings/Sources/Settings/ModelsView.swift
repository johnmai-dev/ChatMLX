//
//  ModelsView.swift
//  Settings
//
//  Created by John Mai on 2025/2/27.
//

import Utilities
import Defaults
import SwiftUI
import UltraUI

struct ModelsView: View {

    @Environment(AppStore.self) var store
    @Default(.disabledModels) var disabledModels

    var body: some View {
        VStack {
            ForEach(store.models.keys.sorted(by: { $0.rawValue < $1.rawValue }), id: \.self) {
                key in
                UltraSection {
                    ForEach(store.models[key] ?? [], id: \.self) { model in
                        LabeledContent(model.name) {
                            Toggle(
                                "",
                                isOn: Binding(
                                    get: {
                                        !disabledModels.contains(model.id)
                                    },
                                    set: { value in
                                        if value {
                                            disabledModels.removeAll(where: { $0 == model.id })
                                        } else {
                                            disabledModels.append(model.id)
                                        }
                                    })
                            ).toggleStyle(.switch)
                        }
                    }
                } header: {
                    Text("\(key)")
                        .fontWeight(.medium)
                }

            }

            Spacer()
        }
        .padding()
        .task {
            do {
                try store.loadModels()
            } catch {
                print(error)
            }
        }
    }
}
