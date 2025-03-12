//
//  ChatMLXApp.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/3.
//

import Conversation
import Utilities
import Database
import Defaults
import Settings
import SwiftUI

@main
struct ChatMLXApp: App {
    @State private var appStore: AppStore = .init()
    @State private var conversationStore: ConversationStore = .init()
    @State private var settingsStore: SettingsStore = .init()

    @Default(.language) var language

    var body: some Scene {
        WindowGroup {
            ConversationView()
                .environment(appStore)
                .environment(conversationStore)
                .environment(\.locale, .init(identifier: language.id))
                .environment(\.appDatabase, .shared)
        }

        Settings {
            SettingsView()
                .environment(appStore)
                .environment(settingsStore)
                .environment(\.locale, .init(identifier: language.id))
                .environment(\.appDatabase, .shared)
        }
    }
}
