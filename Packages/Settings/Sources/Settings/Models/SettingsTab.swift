//
//  SettingsTab.swift
//  Models
//
//  Created by John Mai on 2025/2/27.
//

import SwiftUI

public struct SettingsTab: Identifiable {

    public enum ID: String {
        case general = "General"
        case defaultConversation = "Default Conversation"
        case search = "Search"
        case mcp = "MCP Servers"
        case huggingFace = "Hugging Face"
        case models = "Models"
        case providers = "Providers"
        case mlxCommunity = "MLX Community"
        case downloadManager = "Download Manager"
        case experimentalFeatures = "Experimental Features"
        case about = "About"
    }

    public let id: ID
    public let icon: Image
    public let showIndicator: (() -> Bool)?

    public init(_ id: ID, _ icon: Image, showIndicator: (() -> Bool)? = nil) {
        self.id = id
        self.icon = icon
        self.showIndicator = showIndicator
    }

    public func iconView() -> some View {
        icon
            .resizable()
            .scaledToFit()
            .frame(width: 18, height: 18)
    }
}

extension SettingsTab: Equatable {
    public static func == (lhs: SettingsTab, rhs: SettingsTab) -> Bool {
        rhs.id == lhs.id
    }
}
