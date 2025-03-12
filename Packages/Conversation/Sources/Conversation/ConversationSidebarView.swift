//
//  ConversationSidebarView.swift
//  Conversation
//
//  Created by John Mai on 2025/2/21.
//

import Database
import Shimmer
import SwiftUI
import SwiftUIIntrospect
import UltraUI

struct ConversationSidebarView: View {
    var conversations: [Conversation]
    @Binding var selectedConversation: Conversation?

    @Environment(ConversationStore.self) var conversationStore

    @State var proxy: ScrollViewProxy?

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
            ScrollViewReader { proxy in
                ScrollView {
                    Color.clear
                        .frame(width: 0, height: 0)
                        .id("top")
                    LazyVStack(spacing: 4) {
                        ForEach(conversations, id: \.id) { conversation in
                            item(conversation: conversation)
                        }
                    }
                    .padding(.horizontal, 6)
                }
                .onChange(of: conversations) { oldValue, newValue in
                    if oldValue.count < newValue.count {
                        withAnimation {
                            proxy.scrollTo("top", anchor: .top)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
        }
        .task {
            do {
                try await self.conversationStore.loadConversations()
            } catch {
                print("Failed to load conversations: \(error)")
            }

        }
    }

    @ViewBuilder
    func item(conversation: Conversation) -> some View {
        Button(action: {
            Task{
                do {
                    try await conversationStore.switchToConversation(conversation)
                } catch {
                    print("Failed to switch to conversation: \(error)")
                }
            }

        }) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(conversation.titleUnwrapped)
                        .font(.headline)
                        .lineLimit(1)
                        .help(conversation.titleUnwrapped)

                    Spacer()

                    Text(conversation.updatedAt.shortFormatted())
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
            UltraSidebarButtonStyle(conversation.id == selectedConversation?.id)
        )

    }
}
