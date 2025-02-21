//
//  EmptyConversation.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/3.
//

import Luminare
import SwiftUI

struct EmptyConversation: View {
    var body: some View {
        ContentUnavailableView {
            Label("No Conversation", systemImage: "tray.fill")
        } description: {
            Text("Please select a new conversation")

            Button(action: ConversationStore.shared.createConversation) {
                Label("New Conversation", systemImage: "plus")
            }
            .buttonStyle(LuminareCompactButtonStyle())
            .fixedSize()
        }
        .foregroundColor(.white)
    }
}
