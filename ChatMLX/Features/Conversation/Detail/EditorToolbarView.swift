//
//  EditorToolbarView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/11/10.
//

import SwiftUI

struct EditorToolbarView: View {
    @ObservedObject var conversation: Conversation
    @Binding var displayStyle: DisplayStyle
    @Binding var isEditorFullScreen: Bool
    @State var isPresented = false

    var body: some View {
        HStack {
            Button(action: switchDisplayStyle) {
                Image(displayStyle == .markdown ? "plaintext" : "markdown")
            }

            Button(action: clearMessages) {
                Image("clear")
            }

            Button(action: isEditorFullScreenToggle) {
                Image(
                    systemName: isEditorFullScreen
                        ? "arrow.down.right.and.arrow.up.left"
                        : "arrow.up.left.and.arrow.down.right")
            }
            .help(isEditorFullScreen ? "Exit Full Screen" : "Enter Full Screen")

            Spacer()

            Button(action: isPresentedToggle) {
                //                if conversation.gpuActiveMemory > 0 {
                //                    HStack {
                //                        Image(systemName: "info.circle")
                //                        Text("\(conversation.gpuActiveMemory)M")
                //                    }
                //                    .padding(4)
                //                    .background(Color.black.opacity(0.2))
                //                    .cornerRadius(20)
                //                } else {
                //                    Image(systemName: "info.circle")
                //                        .padding(4)
                //                }
            }
            .font(.subheadline)
            .popover(isPresented: $isPresented) {
                VStack(alignment: .leading) {
                    LabeledContent {
                        Text(conversation.promptTime.formatted())
                    } label: {
                        Text("Prompt Time")
                            .fontWeight(.bold)
                    }

                    LabeledContent {
                        Text("\(Int(conversation.promptTokensPerSecond))")
                    } label: {
                        Text("Prompt Tokens/second")
                            .fontWeight(.bold)
                    }

                    LabeledContent {
                        Text(conversation.generateTime.formatted())
                    } label: {
                        Text("Generate Time")
                            .fontWeight(.bold)
                    }

                    LabeledContent {
                        Text("\(Int(conversation.tokensPerSecond))")
                    } label: {
                        Text("Generate Tokens/second")
                            .fontWeight(.bold)
                    }
                }
                .padding()
                .background(.clear)
            }

            ModelPicker(
                selection: $conversation.model,
                models: ModelStore.shared.models
            )
        }
        .buttonStyle(.borderless)
        .foregroundStyle(.white)
        .tint(.white)
        .frame(height: 35)
        .padding(.horizontal, 10)
        .task {
            await ModelStore.shared.fetchModels()
        }
    }

    private func clearMessages() {
        conversation.messages = []
    }

    private func isPresentedToggle() {
        isPresented.toggle()
    }

    private func switchDisplayStyle() {
        withAnimation {
            displayStyle = (displayStyle == .markdown) ? .plain : .markdown
        }
    }

    private func isEditorFullScreenToggle() {
        withAnimation {
            isEditorFullScreen.toggle()
        }
    }
}
