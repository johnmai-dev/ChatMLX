//
//  MCPServersView.swift
//  Settings
//
//  Created by John Mai on 2025/2/27.
//

import SwiftUI
import UltraUI

enum MCPServerType: String, CaseIterable, Identifiable {
    case stdio
    case sse
    
    var id: String { self.rawValue }
}


struct MCPServer: Identifiable {
    var id = UUID()
    var name: String
    var type: MCPServerType
    var isOnline: Bool = true
    var tools: [String]
    var command: String?
    var serverLink: String?
    
    static func createStdio(name: String, command: String, tools: [String]) -> MCPServer {
        MCPServer(name: name, type: .stdio, tools: tools, command: command)
    }
    
    static func createSSE(name: String, serverLink: String, tools: [String]) -> MCPServer {
        MCPServer(name: name, type: .sse, tools: tools, serverLink: serverLink)
    }
}

struct MCPServersView: View {
    @State private var servers: [MCPServer] = [
        MCPServer.createStdio(
            name: "weather",
            command: "node ~/mcp-quickstart/weather-server-typescript/build/index.js",
            tools: ["get-alerts", "get-forecast", "get-mars-weather"]
        ),
        MCPServer.createSSE(
            name: "fetch",
            serverLink: "http://localhost:8765/sse",
            tools: ["fetch"]
        )
    ]

    @State private var showingAddServerSheet = false

    var body: some View {
        List {
            ForEach(servers) { server in
                ServerItemView(server: server)
                    .listRowInsets(EdgeInsets(top: 4, leading: -4, bottom: 4, trailing: -4))
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .padding()
        .ultraToolbar {
            UltraToolbarItem(placement: .trailing) {
                Button {
                    showingAddServerSheet = true
                } label: {
                    Image(systemName: "plus")
                }
                .buttonStyle(.plain)
            }
        }
        .sheet(isPresented: $showingAddServerSheet) {
            AddMCPServerView(
                isPresented: $showingAddServerSheet,
                onSave: { newServer in
                    servers.append(newServer)
                })
        }
    }
}

#Preview {
    VStack {
        MCPServersView()
            .labeledContentStyle(.horizontal)
            .foregroundStyle(.white)
    }.background(Color.black.opacity(0.5))
}
