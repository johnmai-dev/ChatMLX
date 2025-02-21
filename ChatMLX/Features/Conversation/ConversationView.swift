//
//  ConversationView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/3.
//

import Defaults
import SwiftUI

struct ConversationView: View {
    @Binding var selectedConversation: Conversation?

    var body: some View {
        UltramanNavigationSplitView(
            sidebar: {
                ConversationSidebarView(selectedConversation: $selectedConversation)
            },
            detail: {
                detailView()

            }
        )
        .foregroundColor(.white)
        .ultramanMinimalistWindowStyle()
        .appleIntelligenceEffect(isPresented: .constant(false))
    }

    @ViewBuilder
    private func detailView() -> some View {
        Group {
            if let conversation = selectedConversation {
                ConversationDetailView(conversation: conversation)

            } else {
                EmptyConversation()
            }
        }
    }
}
