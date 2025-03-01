//
//  ChatMLXApp.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/3.
//

import Conversation
import Defaults
import Settings
import SwiftUI

@main
struct ChatMLXApp: App {
    @State private var conversationStore: ConversationStore = .init()

    @Default(.language) var language

    var body: some Scene {
        Group {
            WindowGroup {
                ConversationView()
                    .environment(conversationStore)
            }

            Settings {
                SettingsView()

            }
        }
        .environment(\.locale, .init(identifier: language.rawValue))
    }
}
