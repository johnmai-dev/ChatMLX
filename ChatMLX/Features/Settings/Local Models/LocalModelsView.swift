//
//  LocalModelsView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/10.
//

import HuggingfaceHub
import SwiftUI

struct LocalModelsView: View {

    @State private var groupedModels: [String: [CachedRepoInfo]] = [:]
    private var service: HuggingfaceHubService = .init()

    var body: some View {
        List {
            ForEach(groupedModels.keys.sorted(), id: \.self) { key in
                Section(
                    header: Text(key).font(
                        .title2.bold())
                ) {
                    EmptyView()
                    ForEach(groupedModels[key]!, id: \.id) { model in
                        LocalModelItemView(name: model.repoId.deletingPrefix("\(key)/"),onDelete: {
                        })
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .listStyle(SidebarListStyle())
        .ultramanNavigationTitle("Models")
        .ultramanToolbar {
            Button(action: openModelsDirectory) {
                Image(systemName: "folder")
            }
            .buttonStyle(.plain)
        }.task {
            do {
                groupedModels = try service.scanMLXModels()
            } catch {
                print(error)
            }
        }

    }

    private func deleteModel(at offsets: IndexSet, from group: Int) {
        //        let fileManager = FileManager.default
        //
        //        for index in offsets {
        //            let model = modelGroups[group].models[index]
        //            do {
        //                try fileManager.removeItem(at: model.url)
        //                modelGroups[group].models.remove(at: index)
        //                if defaultModel == model.origin {
        //                    defaultModel = ""
        //                }
        //            } catch {
        //                vm.throwError(error, title: "Delete Model Failed")
        //            }
        //        }
    }

    private func openModelsDirectory() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(
            for: .documentDirectory, in: .userDomainMask)[0]
        let modelsURL = documentsURL.appendingPathComponent(
            "huggingface/models")

        NSWorkspace.shared.open(modelsURL)
    }
}
