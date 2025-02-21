//
//  ConversationSidebarView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/3.
//

import Defaults
import Luminare
import SwiftUI

struct ConversationSidebarView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Conversation.updatedAt, ascending: false)],
        animation: .default
    )
    private var conversations: FetchedResults<Conversation>

    private let theme = Theme.shared
    private let store = ConversationStore.shared

    @Binding var selectedConversation: Conversation?
    @State var keyword = ""

    var body: some View {
        VStack(spacing: 0) {
            headerView()
            logoView()
            searchField()
            conversationList()
        }
        .background(.black.opacity(0.4))
    }

    @ViewBuilder
    private func headerView() -> some View {
        HStack {
            Spacer()
            Button(action: store.createConversation) {
                Image(systemName: "plus")
            }
            SettingsLink {
                Image(systemName: "gear")
            }
        }
        .frame(height: 50)
        .padding(.horizontal, theme.padding)
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func logoView() -> some View {
        HStack {
            Image("AppLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .shadow(radius: 5)
            Text("ChatMLX")
                .font(.title)
                .fontWeight(.bold)
        }
    }

    @ViewBuilder
    private func searchField() -> some View {
        LuminareSection {
            UltramanTextField(
                $keyword,
                placeholder: Text("Search Conversation..."),
                onSubmit: search
            )
            .frame(height: 25)
        }
        .padding(.horizontal, theme.padding)
    }

    @ViewBuilder
    private func conversationList() -> some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(conversations) { conversation in
                    ConversationSidebarItemView(
                        conversation: conversation,
                        selectedConversation: $selectedConversation
                    )
                }
            }
        }
        .padding(.top, 6)
    }

    func search() {
        conversations.nsPredicate =
            keyword.isEmpty
            ? nil
            : NSPredicate(
                format: "title CONTAINS [cd] %@ OR ANY messages.content CONTAINS [cd] %@",
                keyword, keyword
            )
    }
}
