//
//  ConversationDetailView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/4.
//

import AlertToast
import Defaults
import Luminare
import MLX
import MLXLLM
import SwiftUI

struct ConversationDetailView: View {
    let conversation: Conversation

    @State private var showRightSidebar = false
    @State private var displayStyle: DisplayStyle = .markdown
    @State private var isEditorFullScreen: Bool = false

    var body: some View {
        ZStack(alignment: .trailing) {
            VStack(spacing: 0) {
                if !isEditorFullScreen {
                    MessageBoxView(
                        conversation: conversation,
                        displayStyle: displayStyle
                    )
                    Divider()
                }

                EditorToolbarView(
                    conversation: conversation,
                    displayStyle: $displayStyle,
                    isEditorFullScreen: $isEditorFullScreen
                )

                EditorView(
                    conversation: conversation,
                    displayStyle: displayStyle,
                    isEditorFullScreen: isEditorFullScreen
                )
            }

            if showRightSidebar {
                Color.black.opacity(0.00001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showRightSidebar = false
                        }
                    }

                RightSidebarView(conversation: conversation)
            }
        }
        .ultramanToolbar(alignment: .trailing) {
            Button(action: showRightSidebarToggle) {
                Image(systemName: "slider.horizontal.3")
            }
            .buttonStyle(.plain)
        }
        .ultramanNavigationTitle(
            conversation.title
        )
    }

    func showRightSidebarToggle() {
        withAnimation {
            showRightSidebar.toggle()
        }
    }
}
