import Models
//
//  ConversationView.swift
//  Conversation
//
//  Created by John Mai on 2025/2/21.
//
import SwiftUI
import UltraUI

public struct ConversationView: View {
    @State private var prompt = AttributedString("")

    @Environment(ConversationStore.self) var conversationStore

    public init() {}

    public var body: some View {
        @Bindable var conversationStore = conversationStore

        UltraNavigationSplitView {
            ConversationSidebarView(
                conversations: $conversationStore.conversations,
                selectedConversation: $conversationStore.selectedConversation
            )
        } detail: {
            VStack(spacing: .zero) {
                if let conversations = conversationStore.selectedConversation {
                    ChatView()
                        .frame(maxHeight: .infinity)
                        .ultraNavigationTitle(conversations.title)
                } else {
                    GreetingView()
                }

                PromptEditorView(prompt: $prompt) {

                } trailingToolbar: {

                }
                .frame(maxWidth: 765)
            }
        }
        .frame(minWidth: 580, minHeight: 360)
        .task {
            conversationStore.conversations = [
                .init(
                    title: "Exploring SwiftUI and Vapor in Chat App Development",
                    description:
                        "This conversation delves into the nuances of using SwiftUI for building a chat interface, comparing it with UIKit, and considering Vapor for backend development. The dialogue showcases the developer's journey, from learning SwiftUI to planning a personal blog project, while highlighting the strengths of these frameworks.",
                    model: .init(
                        provider: .openAI,
                        name: "gpt-4o",
                        model: .id("gpt-4o")
                    )
                ),
                .init(
                    title: "Summary of the legal advisory dialogue",
                    description:
                        "This conversation is about legal counseling and covers questions, answers and related advice on legal issues. As specific conversation content was not provided, the above titles and descriptions are generic templates that are applicable to most legal counseling scenarios. For a more tailored title and description, please provide the specific conversation content to customize a version that more accurately reflects the topic and focus of the conversation.",
                    model: .init(
                        provider: .openAI,
                        name: "gpt-4o",
                        model: .id("gpt-4o")
                    )
                ),
            ]
        }
        .ultraWindowStyle()
    }
}
