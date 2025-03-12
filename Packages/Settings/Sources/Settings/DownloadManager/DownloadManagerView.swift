//
//  DownloadManagerView.swift
//  Settings
//
//  Created by John Mai on 2025/2/27.
//

import SwiftUI
import UltraUI

struct DownloadManagerView: View {

    @Environment(SettingsStore.self) var settingsStore

    var body: some View {
        List {
            ForEach(settingsStore.downloadTasks) { task in
                DownloadTaskView(task: task)
            }
        }
        .ultraToolbar {
            UltraToolbarItem(placement: .trailing) {
                Button {
                    Task {
                        do {
                            try await settingsStore.addDownloadTask()
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Label("Add Task", systemImage: "plus")
                }
                
                Button {
                    Task {
                        await settingsStore.downloadTasks[0].task.pause()
                    }
                } label: {
                    Label("Add Task2", systemImage: "plus")
                }
                
                Button {
                    Task {
                        try await settingsStore.downloadTasks[0].task.download()
                    }
                } label: {
                    Label("Add Task3", systemImage: "plus")
                }
            }
        }
    }
}
