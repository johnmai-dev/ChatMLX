//
//  MarkdownMetadata.swift
//  Common
//
//  Created by John Mai on 2025/2/27.
//

struct MarkdownMetadata {
    private(set) var values: [String: Any] = [:]

    init(from markdown: String) {
        let lines = markdown.split(separator: "\n")
        guard lines.first == "---" else { return }

        var currentKey: String?
        var arrayItems: [String] = []
        var isCollectingArray = false

        for line in lines.dropFirst() {
            if line == "---" {
                if isCollectingArray, let key = currentKey {
                    values[key] = arrayItems
                }
                return
            }

            let trimmedLine = line.trimmingCharacters(in: .whitespaces)
            guard !trimmedLine.isEmpty else { continue }

            if trimmedLine.hasPrefix("-") {
                let item = trimmedLine.dropFirst().trimmingCharacters(in: .whitespaces)
                if !isCollectingArray {
                    isCollectingArray = true
                    arrayItems = []
                }
                arrayItems.append(item)
                if let key = currentKey {
                    values[key] = arrayItems
                }
                continue
            }

            if let colonIndex = trimmedLine.firstIndex(of: ":") {
                if isCollectingArray {
                    isCollectingArray = false
                    arrayItems = []
                }

                let key = String(trimmedLine[..<colonIndex]).trimmingCharacters(in: .whitespaces)
                let value = String(trimmedLine[trimmedLine.index(after: colonIndex)...])
                    .trimmingCharacters(in: .whitespaces)

                if value.hasPrefix("[") && value.hasSuffix("]") {
                    let items = value.dropFirst().dropLast()
                        .split(separator: ",")
                        .map { $0.trimmingCharacters(in: .whitespaces) }
                        .filter { !$0.isEmpty }
                    values[key] = items
                } else if !value.isEmpty {
                    values[key] = value
                }
                currentKey = key
                continue
            }

            if let key = currentKey {
                if let existing = values[key] as? String {
                    values[key] = existing + " " + trimmedLine
                }
            }
        }
    }

    func string(for key: String) -> String? {
        values[key] as? String
    }

    func array(for key: String) -> [String] {
        (values[key] as? [String]) ?? []
    }
}
