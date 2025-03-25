//
//  ServerItemView.swift
//  Settings
//
//  Created by John Mai on 2025/3/4.
//

import SwiftUI


struct ServerItemView: View {
    let server: MCPServer
    
    @Environment(\.ultraViewBackground) var utlraViewBackground
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(server.isOnline ? Color.green : Color.red)
                    .frame(width: 10, height: 10)
                
                Text(server.name)
                    .font(.title2)
                
                Text(server.type.rawValue)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                Spacer()
                
                HStack {
                    Button(action: {}) {
                        Image(systemName: "pencil")
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "arrow.clockwise")
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "trash")
                    }
                }
                .buttonStyle(.ultraPlain)
            }
            
            LabeledContent {
                HStack(spacing: 8) {
                    ForEach(server.tools, id: \.self) { tool in
                        Text(tool)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(4)
                    }
                }
            } label: {
                HStack {
                    Image(systemName: "wrench")
                    Text("Tools:")
                }
            }
            
            if let command = server.command, server.type == .stdio {
                            LabeledContent {
                                Text(command)
                            } label: {
                                HStack {
                                    Image(systemName: "terminal")
                                    Text("Command:")
                                }
                            }
                        } else if let link = server.serverLink, server.type == .sse {
                            LabeledContent {
                                Text(link)
                            } label: {
                                HStack {
                                    Image(systemName: "link")
                                    Text("Server Link:")
                                }
                            }
                        }
        }
        .labeledContentStyle(.horizontal)
        .padding()
        .background(utlraViewBackground)
        .shadow()
        .cornerRadius(8)
    }
}

#Preview {
    let server = MCPServer.createStdio(
        name: "weather",
        command: "node ~/mcp-quickstart/weather-server-typescript/build/index.js",
        tools: ["get-alerts", "get-forecast", "get-mars-weather"]
    )
    
    ServerItemView(server: server)
}
        
