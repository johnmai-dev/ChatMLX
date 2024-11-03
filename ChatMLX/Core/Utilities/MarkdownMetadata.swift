//
//  MarkdownMetadata.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/10.
//

import Foundation

struct MarkdownMetadata {
    var metadata: [String: String] = [:]

    init(markdown: String) {
        let lines = markdown.components(separatedBy: .newlines)
        var isMetadata = false
        var metadataLines: [String] = []
        var contentLines: [String] = []

        for line in lines {
            if line.trimmingCharacters(in: .whitespaces) == "---" {
                isMetadata.toggle()
                continue
            }

            if isMetadata {
                metadataLines.append(line)
            } else {
                contentLines.append(line)
            }
        }

        for line in metadataLines {
            let parts = line.split(separator: ":", maxSplits: 1).map { $0.trimmingCharacters(in: .whitespaces) }
            if parts.count == 2 {
                metadata[parts[0]] = parts[1]
            }
        }
    }
}
