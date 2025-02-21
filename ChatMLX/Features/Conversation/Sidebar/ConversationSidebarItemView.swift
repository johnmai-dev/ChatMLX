//
//  ConversationSidebarItem.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/4.
//

import SwiftUI

struct ConversationSidebarItemView: View {
    let conversation: Conversation
    @Binding var selectedConversation: Conversation?

    var isActive: Bool {
        selectedConversation == conversation
    }

    var body: some View {
        Button(action: selectConversation) {
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedStringKey(conversation.title))
                    .font(.headline)

                HStack {
                    Text(conversation.messages.first?.content ?? "")
                        .font(.subheadline)
                        .lineLimit(1)

                    Spacer()

                    if !(conversation.isFault || conversation.isDeleted) {
                        Text(conversation.updatedAt?.toFormatted() ?? "")
                            .font(.caption)
                    }
                }
                .foregroundStyle(.white.opacity(0.7))
            }
            .padding(6)
        }
        .buttonStyle(UltramanSidebarButtonStyle(isActive: .constant(isActive)))
        .contextMenu {
            Button(role: .destructive, action: deleteConversation) {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    private func selectConversation() {
        selectedConversation = conversation
    }

    private func deleteConversation() {
        ConversationStore.shared.deleteConversation(conversation)
    }
}
