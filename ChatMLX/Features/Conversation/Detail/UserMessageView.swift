//
//  UserMessageView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/11/10.
//

import SwiftUI

struct UserMessageView: View {
    let message: Message

    var body: some View {
        Spacer()
        VStack(alignment: .trailing) {
            Text(message.content)
                .padding(10)
                .background(Color.black.opacity(0.1618))
                .foregroundColor(.white)
                .cornerRadius(8)

            HStack {
                Text(message.updatedAt?.toTimeFormatted() ?? "")
                    .font(.caption)

                Button(action: copy) {
                    Image(systemName: "doc.on.doc")
                        .help("Copy")
                }

                Button(action: delete) {
                    Image(systemName: "trash")
                }
            }
            .buttonStyle(.plain)
            .foregroundColor(.white.opacity(0.8))
            .padding(.top, 4)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    private func copy() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(message.content, forType: .string)
    }

    private func delete() {
        ConversationStore.shared.deleteMessages(message.suffixMessages())
    }
}
