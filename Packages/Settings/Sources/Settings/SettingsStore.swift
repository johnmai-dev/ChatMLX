//
//  SettingsStore.swift
//  Settings
//
//  Created by John Mai on 2025/2/27.
//

import Utilities
import Foundation
import HuggingfaceHub

@MainActor
@Observable
public final class SettingsStore {
    var downloadTasks: [DownloadTask] = []
    
    public init() {}
    
    func addDownloadTask(repoId: String = "mlx-community/Qwen2.5-0.5B-Instruct-4bit") async throws {
        let task = SnapshotDownloader(
            repoId: repoId,
            options: .init(onProgress: { progress in
                Task { @MainActor in
                    if let index = self.downloadTasks.firstIndex(where: { $0.repoId == repoId }) {
                        self.downloadTasks[index].progress = progress.fractionCompleted
                        self.downloadTasks[index].downloaded = progress.completedUnitCount
                        
                        if self.downloadTasks[index].total != progress.totalUnitCount {
                            self.downloadTasks[index].total = progress.totalUnitCount
                        }
                    }
                }
            })
        )

        downloadTasks.append(.init(repoId: repoId, task: task))

        try await task.download()
    }

}
