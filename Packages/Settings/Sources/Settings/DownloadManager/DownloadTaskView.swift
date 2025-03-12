//
//  DownloadTaskView.swift
//  Settings
//
//  Created by John Mai on 2025/3/5.
//

import Utilities
import SwiftUI

struct DownloadTaskView: View {

    let task: DownloadTask

    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text(task.repoId)
                        .font(.headline)
                        .lineLimit(1)
                        .truncationMode(.head)
                        .help(task.repoId)

                    Spacer()

                    Text("\(task.progress * 100, specifier: "%.2f")%")
                        .font(.subheadline)
                        .frame(width: 50, alignment: .trailing)
                }

                HStack {
                    Spacer()

                    Text("\(task.downloaded) / \(task.total)")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                }

                ProgressView(value: task.progress)
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(height: 4)
            }

            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.title2)
        }
    }
}

#Preview {
    VStack {
        DownloadTaskView(
            task: .init(
                repoId: "mlx-community/Qwen2.5-0.5B-Instruct-4bit",
                task: .init(repoId: "")
            )
        )
        .labeledContentStyle(.horizontal)
        .foregroundStyle(.white)
    }
    .padding()
    .background(Color.black.opacity(0.5))
}
