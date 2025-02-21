//
//  MessageBoxView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/11/10.
//

import SwiftUI

struct MessageBoxView: View {
    @ObservedObject var conversation: Conversation
    @State var scrollViewProxy: ScrollViewProxy?
    let displayStyle: DisplayStyle

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack {
                    ForEach(conversation.messages) { message in
                        MessageBubbleView(
                            message: message,
                            displayStyle: displayStyle
                        )
                    }
                }
                .padding()
            }
            .onChange(
                of: conversation.messages.last,
                { _, _ in
                    scrollToBottom()
                }
            )
            .onAppear {
                scrollViewProxy = proxy
                scrollToBottom()
            }
        }
    }

    private func scrollToBottom() {
        guard let lastMessageId = conversation.messages.last?.id, let scrollViewProxy else {
            return
        }

        withAnimation {
            scrollViewProxy.scrollTo(lastMessageId, anchor: .bottom)
        }
    }
}
