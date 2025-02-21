//
//  EditorView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/11/10.
//

import Luminare
import SwiftUI

struct EditorView: View {
    let conversation: Conversation
    let displayStyle: DisplayStyle
    let isEditorFullScreen: Bool

    @State var message = ""

    var body: some View {
        ZStack(alignment: .bottom) {
            UltramanTextEditor(
                text: $message,
                placeholder: "Type your message…",
                onSubmit: send
            )
            .padding(.horizontal, 5)

            HStack(spacing: 16) {
                Spacer()
                Button("Clear") {
                    message = ""
                }
                .buttonStyle(.borderless)
                .disabled(message.isEmpty)

                Button(action: send) {
                    if conversation.inferring {
                        Label {
                            Text("Send")
                        } icon: {
                            ProgressView()
                                .controlSize(.small)
                                .padding(.trailing, 2)
                                .colorInvert()
                                .brightness(1)
                        }
                    } else {
                        Label("Send", systemImage: "paperplane")
                    }
                }
                .buttonStyle(LuminareCompactButtonStyle())
                .fixedSize()
                .disabled(
                    message.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    ).isEmpty || conversation.inferring)
            }
            .padding()
        }
        .frame(maxHeight: isEditorFullScreen ? .infinity : 150)
    }

    private func send() {
        guard let model = ModelStore.shared.model(conversation.model) else {
            return
        }

        let message = message.trimmingCharacters(in: .whitespacesAndNewlines)
        Message(context: PersistenceController.shared.viewContext).user(content: message, conversation: conversation)
        self.message = ""
        Task {
            await ConversationStore.shared.send(
                conversation: conversation,
                model: model,
                content: message
            )
        }
    }
}
