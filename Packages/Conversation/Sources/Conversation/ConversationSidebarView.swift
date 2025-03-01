//
//  ConversationSidebarView.swift
//  Conversation
//
//  Created by John Mai on 2025/2/21.
//

import Models
import Shimmer
import SwiftUI
import UltraUI

struct ConversationSidebarView: View {
    @Binding var conversations: [Conversation]
    @Binding var selectedConversation: Conversation?

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image("AppLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                Text("ChatMLX")
                    .font(.title)
                    .fontWeight(.bold)
                    .shimmering(
                        animation: .linear(duration: 2.6).delay(0.25)
                            .repeatForever(autoreverses: false))
            }
            .shadow()

            List {
                ForEach(conversations) { conversation in
                    item(conversation: conversation)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }

    @ViewBuilder
    func item(conversation: Conversation) -> some View {
        Button(action: {
            selectedConversation = conversation
        }) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(conversation.title)
                        .font(.headline)
                        .lineLimit(1)

                    Spacer()

                    Text(conversation.updatedTime.formatted())
                        .font(.caption)
                        .foregroundStyle(.secondary)

                }

                if let description = conversation.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .truncationMode(.tail)
                }
            }
            .padding(16)
        }
        .buttonStyle(
            UltraSidebarButtonStyle(conversation == selectedConversation)
        )

    }
}
