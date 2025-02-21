//
//  MLXProviderModelItemView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/26.
//
import SwiftUI

struct MLXProviderModelItemView: View {
    let model: ProviderModel
    let onDelete: (ProviderModel) -> Void

    var body: some View {
        EmptyView()
        //        HStack {
        //            Text(model.name ?? model.id)
        //            Spacer()
        //            Button(action: {
        //                openDirectory(model.path)
        //            }) {
        //                Image(systemName: "folder")
        //            }
        //
        //            Button(action: {
        //                onDelete(model)
        //            }) {
        //                Image(systemName: "trash")
        //                    .renderingMode(.original)
        //            }
        //        }
        //        .buttonStyle(.plain)
        //        .padding()
        //        .background(.black.opacity(0.3))
        //        .listRowSeparator(.hidden)
        //        .clipShape(RoundedRectangle(cornerRadius: 10))
        //        .shadow(color: .black, radius: 2)
        //        .listRowInsets(EdgeInsets(top: 0, leading: -5, bottom: 10, trailing: -5))
    }

    private func openDirectory(_ path: URL?) {
        if let path {
            NSWorkspace.shared.open(path)
        }
    }
}
