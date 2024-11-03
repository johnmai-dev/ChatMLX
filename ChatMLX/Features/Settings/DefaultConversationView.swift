//
//  DefaultChatView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/27.
//

import CompactSlider
import Defaults
import Luminare
import SwiftUI

struct DefaultConversationView: View {
    @Default(.defaultTitle) var defaultTitle
//    @Default(.defaultModel) var defaultModel
    @State var defaultModel: ModelInfo?
    @Default(.defaultTemperature) var defaultTemperature
    @Default(.defaultTopP) var defaultTopP
    @Default(.defaultMaxLength) var defaultMaxLength
    @Default(.defaultRepetitionContextSize) var defaultRepetitionContextSize
    @Default(.defaultMaxMessagesLimit) var defaultMaxMessagesLimit
    @Default(.defaultUseMaxMessagesLimit) var defaultUseMaxMessagesLimit
    @Default(.defaultRepetitionPenalty) var defaultRepetitionPenalty
    @Default(.defaultUseRepetitionPenalty) var defaultUseRepetitionPenalty
    @Default(.defaultUseMaxLength) var defaultUseMaxLength
    @Default(.defaultUseSystemPrompt) var defaultUseSystemPrompt
    @Default(.defaultSystemPrompt) var defaultSystemPrompt

    @Default(.defaultProvider) var defaultProvider

    @State private var localModels: [LocalModel] = []

    @Environment(SettingsViewModel.self) var vm

    private let padding: CGFloat = 6

    var body: some View {
        ScrollView {
            VStack {
                LuminareSection("Title") {
                    UltramanTextField(
                        $defaultTitle,
                        placeholder: Text("Default conversation title")
                    )
                    .frame(minHeight: 35)
                }

                LuminareSection("Model Settings") {
                    LabeledContent("Provider") {
                        DefaultProviderPicker(provider: $defaultProvider)
                    }

                    LabeledContent("Model") {
                        DefaultModelPicker(provider: $defaultProvider)
                    }

                    LabeledContent("Temperature") {
                        CompactSlider(
                            value: $defaultTemperature, in: 0 ... 2, step: 0.01
                        ) {
                            Text("\(defaultTemperature, specifier: "%.2f")")
                                .foregroundStyle(.white)
                        }
                        .frame(width: 200)
                    }

                    LabeledContent("Top P") {
                        CompactSlider(
                            value: $defaultTopP, in: 0 ... 1, step: 0.01
                        ) {
                            Text("\(defaultTopP, specifier: "%.2f")")
                                .foregroundStyle(.white)
                        }
                        .frame(width: 200)
                    }

                    LabeledContent("Use Max Length") {
                        Toggle("", isOn: $defaultUseMaxLength)
                    }

                    if defaultUseMaxLength {
                        LabeledContent("Max Length") {
                            CompactSlider(
                                value: $defaultMaxLength.asDouble(), in: 0 ... 8192, step: 1
                            ) {
                                Text("\(defaultMaxLength)")
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 200)
                        }
                    }

                    LabeledContent("Repetition Context Size") {
                        CompactSlider(
                            value: $defaultRepetitionContextSize.asDouble(), in: 0 ... 100, step: 1
                        ) {
                            Text("\(defaultRepetitionContextSize)")
                                .foregroundStyle(.white)
                        }
                        .frame(width: 200)
                    }

                    LabeledContent("Use Repetition Penalty") {
                        Toggle("", isOn: $defaultUseRepetitionPenalty)
                    }

                    if defaultUseRepetitionPenalty {
                        LabeledContent("Repetition Penalty") {
                            CompactSlider(
                                value: $defaultRepetitionPenalty, in: 1 ... 2,
                                step: 0.01
                            ) {
                                Text(
                                    "\(defaultRepetitionPenalty, specifier: "%.2f")"
                                )
                                .foregroundStyle(.white)
                            }
                            .frame(width: 200)
                        }
                    }
                }

                LuminareSection("Message Control") {
                    LabeledContent("Use Max Messages Limit") {
                        Toggle("", isOn: $defaultUseMaxMessagesLimit)
                    }

                    if defaultUseMaxMessagesLimit {
                        LabeledContent("Max Messages Limit") {
                            CompactSlider(
                                value: $defaultMaxMessagesLimit.asDouble(), in: 1 ... 50, step: 1
                            ) {
                                Text("\(defaultMaxMessagesLimit)")
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 200)
                        }
                    }
                }

                LuminareSection("System Prompt") {
                    LabeledContent("Use System Prompt") {
                        Toggle("", isOn: $defaultUseSystemPrompt)
                    }

                    if defaultUseSystemPrompt {
                        UltramanTextEditor(
                            text: $defaultSystemPrompt,
                            placeholder: "System prompt",
                            onSubmit: {}
                        )
                        .frame(height: 100)
                    }
                }

                Spacer()
            }
            .padding()
        }
        .labeledContentStyle(.horizontal)
        .compactSliderSecondaryColor(.white)
        .scrollContentBackground(.hidden)
        .onAppear(perform: loadModels)
        .ultramanNavigationTitle("Default Conversation")
        .labelsHidden()
        .buttonStyle(.borderless)
        .foregroundStyle(.white)
        .toggleStyle(.switch)
    }

    private func loadModels() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(
            for: .documentDirectory, in: .userDomainMask
        )[0]
        let modelsURL = documentsURL.appendingPathComponent(
            "huggingface/models")

        do {
            let contents = try fileManager.contentsOfDirectory(
                at: modelsURL, includingPropertiesForKeys: nil,
                options: [.skipsHiddenFiles]
            )
            var models: [LocalModel] = []

            for groupURL in contents {
                if groupURL.hasDirectoryPath {
                    let modelContents = try fileManager.contentsOfDirectory(
                        at: groupURL, includingPropertiesForKeys: nil,
                        options: [.skipsHiddenFiles]
                    )

                    for modelURL in modelContents {
                        if modelURL.hasDirectoryPath {
                            models.append(
                                LocalModel(
                                    group: groupURL.lastPathComponent,
                                    name: modelURL.lastPathComponent,
                                    url: modelURL
                                )
                            )
                        }
                    }
                }
            }
//
//            if !models.contains(where: { $0.origin == defaultModel }) {
//                defaultModel = ""
//            }

            Task { @MainActor in
                localModels = models
            }
        } catch {
            vm.throwError(error, title: "Load Models Failed")
        }
    }
}
