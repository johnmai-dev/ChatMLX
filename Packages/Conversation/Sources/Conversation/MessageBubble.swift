//
//  MessageBubble.swift
//  Conversation
//
//  Created by John Mai on 2025/3/2.
//

import Utilities
import Database
import MarkdownUI
import SwiftUI

struct MessageBubble: View {
    @Environment(\.ultraViewBackground) var utlraViewBackground
    @Environment(\.utlraSecondaryViewBackground) var utlraSecondaryViewBackground
    
    @State private var isHovering = false
    
    let message: Message
    
    var body: some View {
       
            HStack {
                if message.role == .user {
                    Spacer()
                }
                
                VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 2) {
                    Group {
                        if message.role == .user {
                            Text(message.content)
                        } else {
                            Markdown(message.content)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        BubbleShape(isUser: message.role == .user, cornerRadius: 10)
                            .fill(
                                message.role == .user
                                ? utlraViewBackground : utlraSecondaryViewBackground)
                    )
                    .foregroundColor(message.role == .user ? .white.opacity(0.8) : .white)
                    
                    Text(message.createdAt.shortFormatted())
                           .font(.caption2)
                           .foregroundColor(.gray)
                           .padding(.horizontal, 4)
                           .opacity(isHovering ? 1 : 0)
                           .animation(.easeIn(duration: 0.15), value: isHovering)
                           .frame(height: 16)
                }
                .onHover { hovering in
                    isHovering = hovering
                }
                
                if message.role != .user {
                    Spacer()
                }
            }
            
            
        
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .shadow()
        
    }
}
