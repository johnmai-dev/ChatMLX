//
//  HuggingfaceHubService.swift
//  ChatMLX
//
//  Created by John Mai on 2025/2/19.
//
import HuggingfaceHub

struct HuggingfaceHubService {
    func scanMLXModels() throws -> [String: [CachedRepoInfo]] {
        let hfCacheInfo = try CacheManager().scanCacheDir()

        let models = hfCacheInfo.repos.filter { repo in
            repo.repoId.hasPrefix("mlx-community/") || repo.repoId.contains("-MLX") || isMLX(repo: repo)
        }

        return Dictionary(grouping: models) { repo in
            repo.repoId.split(separator: "/").first.map(String.init) ?? "Other"
        }
    }

    private func isMLX(repo: CachedRepoInfo) -> Bool {
        if repo.repoId.hasPrefix("mlx-community/") {
            return true
        }

        let file = try? HuggingfaceHub.Utility.tryToLoadFromCache(repoId: repo.repoId, filename: "README.md")

        guard let file else {
            return false
        }

        let markdown = try? String(contentsOf: file)

        guard let markdown else {
            return false
        }

        let metadata = MarkdownMetadata(from: markdown)

        let tags = metadata.array(for: "tags")

        return tags.contains("mlx")
    }
}
