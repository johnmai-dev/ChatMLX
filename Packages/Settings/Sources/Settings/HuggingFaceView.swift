//
//  HuggingFaceView.swift
//  Settings
//
//  Created by John Mai on 2025/2/27.
//

import Utilities
import Defaults
import SwiftUI
import UltraUI

struct HuggingFaceView: View {

    @Default(.huggingFaceToken) var token
    @Default(.huggingFaceEndpoint) var endpoint
    @Default(.huggingFaceCachePath) var cachePath

    @State private var isShowingFilePicker = false
    @State private var isShowingResetConfirmation = false

    var body: some View {
        VStack {
            UltraSection {
                UltraSecureTextField(
                    text: $token.toUnwrapped(defaultValue: ""),
                    placeholder: "Enter your Hugging Face token"
                )
            } header: {
                Text("Hugging Face Token")
            }

            UltraSection {
                LabeledContent("Endpoint") {
                    Picker(
                        "Endpoint",
                        selection: $endpoint
                    ) {
                        ForEach(HuggingFaceEndpoint.allCases) { endpoint in
                            Text(endpoint.rawValue).tag(endpoint)
                        }
                    }
                    .buttonStyle(.borderless)
                    .tint(.white)
                    .labelsHidden()
                }
            } header: {
                Text("Hugging Face Endpoint")
            }

            UltraSection {
                VStack(alignment: .leading, spacing: 8) {
                    LabeledContent("Cache Path") {
                        HStack {
                            Button {
                                isShowingFilePicker = true
                            } label: {
                                Image(systemName: "folder.badge.gearshape")
                                    .foregroundStyle(.white)
                            }
                            .buttonStyle(.plain)

                            if cachePath != nil {
                                Button {
                                    isShowingResetConfirmation = true
                                } label: {
                                    Image(systemName: "arrow.uturn.backward")
                                        .foregroundStyle(.red)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    Text(
                        cachePath?.path
                            ?? FileManager.default.homeDirectoryForCurrentUser
                            .appendingPathComponent(".cache", isDirectory: true)
                            .appendingPathComponent("huggingface", isDirectory: true).path()
                    )
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .foregroundStyle(.secondary)
                }
            } header: {
                Text("Hugging Face Cache Management")
            }

            Spacer()
        }
        .padding()
        .fileImporter(
            isPresented: $isShowingFilePicker,
            allowedContentTypes: [.folder],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let selectedURL = urls.first {
                    cachePath = selectedURL
                }
            case .failure(let error):
                print("Error selecting directory: \(error.localizedDescription)")
            }
        }
        .confirmationDialog(
            "Reset Cache Path",
            isPresented: $isShowingResetConfirmation,
            titleVisibility: .visible
        ) {
            Button("Reset", role: .destructive) {
                cachePath = nil
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to reset to the default cache path?")
        }
    }
}

#Preview {
    VStack {
        HuggingFaceView()
            .labeledContentStyle(.horizontal)
            .foregroundStyle(.white)
    }.background(Color.black.opacity(0.5))
}
