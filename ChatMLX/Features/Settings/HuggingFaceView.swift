//
//  HuggingFaceView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/27.
//

import Defaults
import Luminare
import SwiftUI

struct HuggingFaceView: View {
    @Default(.huggingFaceEndpoint) var endpoint
    @Default(.customHuggingFaceEndpoints) var customEndpoints
    @Default(.useCustomHuggingFaceEndpoint) var useCustomEndpoint

    @Default(.huggingFaceToken) var token

    @State private var newCustomEndpoint: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack(spacing: 18) {
            LuminareSection("Hugging Face Token") {
                LabeledContent("Token") {
                    UltramanSecureField(
                        $token,
                        placeholder: Text("Enter your Hugging Face token"),
                        alignment: .trailing
                    )
                    .frame(height: 25)
                }
                .padding(5)
            }

            LuminareSection("Hugging Face Endpoint") {
                LabeledContent("Endpoint") {
                    Picker("", selection: $endpoint) {
                        if useCustomEndpoint {
                            ForEach(customEndpoints, id: \.self) {
                                customEndpoint in
                                Text(customEndpoint).tag(customEndpoint)
                            }
                        }
                        Text("https://huggingface.co").tag(
                            "https://huggingface.co")
                        Text("https://hf-mirror.com").tag(
                            "https://hf-mirror.com")
                    }
                }
                .padding(8)

                LabeledContent("Use Custom Endpoint") {
                    Toggle("", isOn: $useCustomEndpoint)
                }
                .padding(8)

                if useCustomEndpoint {
                    LabeledContent("Custom Endpoint") {
                        UltramanTextField(
                            $newCustomEndpoint,
                            placeholder: Text("Custom Hugging Face Endpoint"),
                            alignment: .trailing
                        )
                        .frame(height: 25)
                        .onSubmit {
                            addCustomEndpoint()
                        }
                    }
                    .padding(5)

                    if !customEndpoints.isEmpty {
                        List {
                            ForEach(customEndpoints, id: \.self) {
                                customEndpoint in
                                HStack {
                                    Text(customEndpoint)
                                    Spacer()

                                    Button {
                                        removeCustomEndpoint(customEndpoint)
                                    } label: {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .listStyle(.plain)
                    }
                }
            }

            Spacer()
        }
        .toggleStyle(.switch)
        .labeledContentStyle(.horizontal)
        .labelsHidden()
        .buttonStyle(.borderless)
        .foregroundStyle(.white)
        .tint(.white)
        .ultramanNavigationTitle("Hugging Face")
        .padding()
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Warning"), message: Text(alertMessage),
                dismissButton: .default(Text("Done"))
            )
        }
    }

    private func addCustomEndpoint() {
        guard !newCustomEndpoint.isEmpty else {
            alertMessage = "Please enter a valid endpoint."
            showingAlert = true
            return
        }

        guard URL(string: newCustomEndpoint) != nil else {
            alertMessage = "Please enter a valid endpoint url."
            showingAlert = true
            return
        }

        if !customEndpoints.contains(newCustomEndpoint) {
            customEndpoints.append(newCustomEndpoint)
            endpoint = newCustomEndpoint
            newCustomEndpoint = ""
        } else {
            alertMessage = "The endpoint already exists."
            showingAlert = true
        }
    }

    private func removeCustomEndpoint(_ endpoint: String) {
        customEndpoints.removeAll { $0 == endpoint }
        if self.endpoint == endpoint {
            self.endpoint = "https://huggingface.co"
        }
    }
}
