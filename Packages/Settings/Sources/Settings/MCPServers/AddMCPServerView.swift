//
//  AddMCPServerView.swift
//  Settings
//
//  Created by John Mai on 2025/3/5.
//

import SwiftUI

struct AddMCPServerView: View {
    @Binding var isPresented: Bool
    var onSave: (MCPServer) -> Void
    
    @State private var serverName = ""
    @State private var selectedType: MCPServerType = .stdio
    @State private var command = ""
    @State private var serverLink = ""
    @State private var toolInput = ""
    @State private var tools: [String] = []
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Server Information")) {
                    TextField("Server Name", text: $serverName)
                    
                    Picker("Server Type", selection: $selectedType) {
                        Text("stdio").tag(MCPServerType.stdio)
                        Text("sse").tag(MCPServerType.sse)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // 根据选择的类型显示不同的输入项
                Section(header: Text(selectedType == .stdio ? "Command" : "Server Link")) {
                    if selectedType == .stdio {
                        TextField("Command", text: $command)
                    } else {
                        TextField("Server Link", text: $serverLink)
                    }
                }
                
                // 工具输入
                Section(header: Text("Tools")) {
                    HStack {
                        TextField("Add Tool", text: $toolInput)
                        
                        Button(action: {
                            if !toolInput.isEmpty {
                                tools.append(toolInput)
                                toolInput = ""
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                    
                    ForEach(tools, id: \.self) { tool in
                        HStack {
                            Text(tool)
                            Spacer()
                            Button(action: {
                                tools.removeAll { $0 == tool }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add New MCP Server")
        }
    }
}
