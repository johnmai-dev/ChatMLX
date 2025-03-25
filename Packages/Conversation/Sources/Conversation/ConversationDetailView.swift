//
//  ConversationDetailView.swift
//  Conversation
//
//  Created by John Mai on 2025/2/23.
//

import Combine
import Database
import GRDB
import SwiftUI
import SwiftUIIntrospect

struct ConversationDetailView: View {

    @Environment(ConversationStore.self) private var conversationStore

    @State private var scrollToBottom: Bool = true
    @State private var scrollViewProxy: ScrollViewProxy? = nil
    @State private var scrollViewProxy2: NSScrollView?

    var body: some View {
        ScrollViewReader { proxy in
            List {
                Color.clear.frame(width: 0, height: 0).id("top")
                    .listRowSeparator(.hidden)
                ForEach(conversationStore.currentMessages) { message in
                    MessageBubble(message: message)
                        .listRowSeparator(.hidden)
                }
                Color.clear.frame(width: 0, height: 0).id("bottom")
                    .listRowSeparator(.hidden)
            }
            .frame(maxWidth: 800)
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .onAppear {
                scrollViewProxy = proxy
                if scrollToBottom {
                    withAnimation {
                        proxy.scrollTo("bottom", anchor: .bottom)
                    }
                }
            }
            .onChange(of: conversationStore.currentMessages.last?.id) { _, _ in
                if scrollToBottom {
                    withAnimation {
                        proxy.scrollTo("bottom", anchor: .bottom)
                    }
                }
            }
//            .onChange(of: conversationStore.currentMessages.count) { newCount, previousCount in
//                if let scrollView = scrollViewProxy2, previousCount > 0, newCount > previousCount {
//                    let oldContentHeight = scrollView.documentView?.frame.height ?? 0
//
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                        let newContentHeight = scrollView.documentView?.frame.height ?? 0
//                        let diff = newContentHeight - oldContentHeight
//
//                        let newY = scrollView.contentView.bounds.origin.y + diff
//                        scrollView.contentView.scroll(
//                            to: CGPoint(x: scrollView.contentView.bounds.origin.x, y: newY))
//                    }
//                }
//            }
//            .introspect(.scrollView, on: .macOS(.v15, .v14)) { scrollView in
//                let contentView = scrollView.contentView
//
//                NotificationCenter.default.addObserver(
//                    forName: NSView.boundsDidChangeNotification,
//                    object: contentView,
//                    queue: .main
//                ) { _ in
//                    MainActor.assumeIsolated {
//
//                        let visibleRect = contentView.bounds
//                        let contentRect = scrollView.documentView?.frame ?? .zero
//
//                        print("visibleRect: \(visibleRect)")
//                        print("contentRect: \(contentRect)")
//
//                        if visibleRect.minY < 10 && contentRect.height > visibleRect.height {
//                            guard conversationStore.hasReachedTop == false else { return }
//
//                            guard conversationStore.isLoadMessages == false else { return }
//                            let oldContentHeight = contentRect.height
//                            print("oldContentHeight: \(contentRect.height)")
//
//                            Task { [oldContentHeight] in
//                                try? await conversationStore.loadMessagesIfNeeded()
//
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                                    let newContentHeight = contentRect.height
//                                    print("newContentHeight: \(contentRect.height)")
//                                    print("newContentHeight: \(newContentHeight)")
//                                    let diff = newContentHeight - oldContentHeight
//                                    print("diff: \(diff)")
//
//                                    let newY = scrollView.contentView.bounds.origin.y + diff
//                                    scrollView.contentView.scroll(
//                                        to: CGPoint(
//                                            x: scrollView.contentView.bounds.origin.x, y: 280))
//                                }
//
//                            }
//                        }
//
//                        let isNearBottom = (contentRect.height - visibleRect.maxY) < 50
//                        if isNearBottom != scrollToBottom {
//
//                            scrollToBottom = isNearBottom
//                        }
//                    }
//                }
//            }
        }
    }
}
