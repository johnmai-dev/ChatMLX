//
//  DownloadStore.swift
//  ChatMLX
//
//  Created by John Mai on 2024/11/10.
//

import SwiftUI

@MainActor
@Observable
final class DownloadStore {
    static let shared = DownloadStore()

    var tasks: [DownloadTask] = []
}
