//
//  SettingsView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/10.
//

import SwiftUI

struct SettingsView: View {
    @Environment(SettingsStore.self) var store

    var body: some View {
        UltramanNavigationSplitView(sidebarWidth: 220) {
            SettingsSidebarView()
        } detail: {
            Group {
                switch store.activeTabID {
                case .general:
                    GeneralView()
                case .defaultConversation:
                    DefaultConversationView()
                case .huggingFace:
                    HuggingFaceView()
                case .models:
                    LocalModelsView()
                case .providers:
                    ModelManagerView()
                case .downloadManager:
                    DownloadManagerView()
                case .mlxCommunity:
                    MLXCommunityView()
                case .experimentalFeatures:
                    ExperimentalFeaturesView()
                case .about:
                    AboutView()
                }
            }
        }
        .ultramanMinimalistWindowStyle()
        .foregroundColor(.white)
    }
}
