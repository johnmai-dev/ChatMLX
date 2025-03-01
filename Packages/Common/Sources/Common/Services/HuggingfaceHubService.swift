//
//  HuggingfaceHubService.swift
//  Common
//
//  Created by John Mai on 2025/2/19.
//
import HuggingfaceHub
import Models

struct HuggingfaceHubService {
    func scanMLXModels() throws -> [Model] {
        let hfCacheInfo = try CacheManager().scanCacheDir()

        return hfCacheInfo.repos.filter { repo in
            repo.repoId.hasPrefix("mlx-community/") || repo.repoId.contains("-MLX")
                || isMLX(repo: repo)
        }.map { repo in

            let file = try? HuggingfaceHub.Utility.tryToLoadFromCache(
                repoId: repo.repoId, filename: "")

            return Model(
                provider: .mlx,
                name: repo.repoId,
                model: .local(file ?? repo.repoPath)
            )
        }
    }

    private func isMLX(repo: CachedRepoInfo) -> Bool {
        if repo.repoId.hasPrefix("mlx-community/") {
            return true
        }

        let file = try? HuggingfaceHub.Utility.tryToLoadFromCache(
            repoId: repo.repoId, filename: "README.md")

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
