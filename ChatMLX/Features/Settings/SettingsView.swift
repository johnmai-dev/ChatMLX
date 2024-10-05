//
//  SettingsView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/10.
//

import SwiftUI

struct SettingsView: View {
    @Environment(SettingsViewModel.self) var vm

    var body: some View {
        @Bindable var vm = vm

        UltramanNavigationSplitView(sidebarWidth: 210) {
            SettingsSidebarView()
        } detail: {
            Group {
                switch vm.activeTabID {
                case .general:
                    GeneralView()
                case .defaultConversation:
                    DefaultConversationView()
                case .huggingFace:
                    HuggingFaceView()
                case .models:
                    ModelManagerView()
                case .downloadManager:
                    DownloadManagerView()
                case .mlxCommunity:
                    MLXCommunityView()
                case .about:
                    AboutView()
                }
            }
        }
        .ultramanMinimalistWindowStyle()
        .foregroundColor(.white)
    }
}
