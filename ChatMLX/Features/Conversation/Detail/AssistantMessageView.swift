//
//  AssistantMessageView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/11/10.
//

import MarkdownUI
import SwiftUI

struct AssistantMessageView: View {
    let displayStyle: DisplayStyle

    @ObservedObject var message: Message

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image("AppLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(color: .black.opacity(0.25), radius: 5, x: -1, y: 5)

            VStack(alignment: .leading) {
                if displayStyle == .markdown {
                    Markdown(MarkdownContent(message.content))
                        .markdownCodeSyntaxHighlighter(
                            .splash(theme: .sunset(withFont: .init(size: 16)))
                        )
                        .markdownTextStyle {
                            ForegroundColor(.white)
                        }
                        .markdownTheme(.customGitHub)
                } else {
                    Text(message.content)
                }

                if let error = message.error, !error.isEmpty {
                    HStack {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundStyle(.yellow)
                        Text(error)
                    }
                    .padding(5)
                    .background(.red.opacity(0.3))
                    .foregroundColor(.white)
                    .cornerRadius(5)
                }

                HStack {
                    Button(action: copy) {
                        Image(systemName: "doc.on.doc")
                            .help("Copy")
                    }

                    Button(action: regenerate) {
                        Image(systemName: "arrow.clockwise")
                            .help("Regenerate")
                    }
                    .disabled(message.conversation?.inferring ?? false)

                    Text(message.updatedAt?.toTimeFormatted() ?? "")
                        .font(.caption)

                    if message.role == .assistant, message.inferring {
                        ProgressView()
                            .controlSize(.small)
                            .colorInvert()
                            .brightness(1)
                            .padding(.leading, 5)
                    }
                }
                .buttonStyle(.plain)
                .foregroundColor(.white.opacity(0.8))
                .padding(.top, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer()
        }
    }

    private func copy() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(message.content, forType: .string)
    }

    private func regenerate() {
        guard let conversation = message.conversation else { return }

        let conversationStore = ConversationStore.shared

        if conversation.messages.last != message {
            conversationStore.deleteMessages(message.suffixMessages())
        }

        guard let model = ModelStore.shared.model(conversation.model) else {
            return
        }

        Task {
            await conversationStore.send(
                conversation: conversation,
                model: model
            )
        }
    }
}
