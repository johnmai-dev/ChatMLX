//
//  MessageBubbleView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/4.
//

import AlertToast
import MarkdownUI
import SwiftUI

struct MessageBubbleView: View {
    @ObservedObject var message: Message

    let displayStyle: DisplayStyle

    var body: some View {
        HStack {
            if message.role == .assistant {
                AssistantMessageView(
                    displayStyle: displayStyle,
                    message: message
                )
            } else {
                UserMessageView(message: message)
            }
        }
        .textSelection(.enabled)
        .padding(.vertical, 8)
    }
}
