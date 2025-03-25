//
//  ConversationView.swift
//  Conversation
//
//  Created by John Mai on 2025/2/21.
//

import Database
import SwiftUI
import UltraUI
import Utilities

public struct ConversationView: View {
    @State private var prompt = AttributedString("")

    @Environment(ConversationStore.self) var conversationStore

    public init() {}

    public var body: some View {
        @Bindable var conversationStore = conversationStore

        UltraNavigationSplitView(showDivider: conversationStore.selectedConversation != nil) {
            ConversationSidebarView(
                conversations: conversationStore.conversations,
                selectedConversation: $conversationStore.selectedConversation
            )
        } detail: {
            VStack(spacing: .zero) {

                if let conversation = conversationStore.selectedConversation {
                    ConversationDetailView()
                        .frame(maxHeight: .infinity)
                        .ultraNavigationTitle(conversation.titleUnwrapped)
                } else {
                    GreetingView()
                        .ultraNavigationTitle("")
                }

                PromptEditorView().frame(maxWidth: 765)
            }

            .ultraToolbar {
                UltraToolbarItem(placement: .leading) {
                    Button {
                        Task {
                            do {
                                try await conversationStore.createConversation()
                            } catch {
                                print("Failed to create conversation: \(error)")
                            }
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .buttonStyle(.ultraIcon)
                    
                    SettingsLink {
                        Image(systemName: "gear")
                    }
                    .buttonStyle(.ultraIcon)
                }

            }
        }
        .frame(minWidth: 580, minHeight: 360)
        .ultraWindowStyle()
    }
}
