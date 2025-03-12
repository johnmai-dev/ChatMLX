//
//  SettingsView.swift
//  Settings
//
//  Created by John Mai on 2025/2/27.
//

import Utilities
import SwiftUI
import UltraUI

public struct SettingsView: View {
    @State private var selection: SettingsTab

    private static let tabs: [SettingsTab] = [
        .init(.general, Image(systemName: "gearshape")),
        .init(.defaultConversation, Image(systemName: "person.bubble")),
        .init(.huggingFace, Image("huggingface")),
        .init(.models, Image(systemName: "brain")),
        .init(.providers, Image(systemName: "brain")),
        .init(.mcp, Image("MCP")),
        .init(.mlxCommunity, Image("MLX")),
        .init(
            .downloadManager, Image(systemName: "arrow.down.circle"),
            showIndicator: { true }
        ),
        .init(.experimentalFeatures, Image(systemName: "flask")),
        .init(.about, Image(systemName: "info.circle")),
    ]

    public init() {
        self._selection = .init(initialValue: Self.tabs.first!)
    }

    public var body: some View {
        UltraNavigationSplitView(initialSidebarWidth: 220) {
            SettingsSidebarView(selection: $selection, tabs: Self.tabs)
        } detail: {
            detailView
                .ultraNavigationTitle(selection.id.rawValue)
                .labeledContentStyle(.horizontal)
        }
        .ultraWindowStyle()
        .frame(width: 720, height: 480)
    }

    @ViewBuilder
    private var detailView: some View {
        switch selection.id {
        case .general:
            GeneralView()
        case .defaultConversation:
            DefaultConversationView()
        case .huggingFace:
            HuggingFaceView()
        case .models:
            ModelsView()
        case .providers:
            ProvidersView()
        case .mcp:
            MCPServersView()
        case .mlxCommunity:
            MLXCommunityView()
        case .downloadManager:
            DownloadManagerView()
        case .experimentalFeatures:
            ExperimentalFeaturesView()
        case .about:
            AboutView()
        default:
            EmptyView()
        }
    }
}

#Preview {
    SettingsView()
        .background(Color.black.opacity(0.5))
}
