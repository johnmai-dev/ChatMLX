//
//  DownloadTask.swift
//  Utilities
//
//  Created by John Mai on 2025/3/5.
//

import Foundation
import HuggingfaceHub

public struct DownloadTask:Sendable {
    public let repoId: String
    public let task: SnapshotDownloader
    public var progress: Double = 0
    public var downloaded: Int64 = 0
    public var total: Int64 = 0
    public var isCompleted: Bool {
        return progress >= 1.0
    }

    public init(repoId: String, task: SnapshotDownloader) {
        self.repoId = repoId
        self.task = task
    }
}

extension DownloadTask: Identifiable {
    public var id: String {
        repoId
    }
}
