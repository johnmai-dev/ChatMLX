//
//  HuggingfaceHubService.swift
//  Utilities
//
//  Created by John Mai on 2025/2/19.
//

import Defaults
import Foundation
import HuggingfaceHub
import Intelligence

struct HuggingfaceHubService {
    func scanMLXModels() throws -> [Model] {
        var cacheDir = Defaults[.huggingFaceCachePath]

        if cacheDir == nil {
            let pw = getpwuid(getuid())!
            let huggingfaceDir = URL(
                fileURLWithFileSystemRepresentation: pw.pointee.pw_dir,
                isDirectory: true,
                relativeTo: nil
            )
            .appendingPathComponent(".cache")
            .appendingPathComponent("huggingface")

            cacheDir = huggingfaceDir
        }

        cacheDir = cacheDir?.appendingPathComponent("hub")

        let hfCacheInfo = try CacheManager(cacheDir: cacheDir).scanCacheDir()

        return try hfCacheInfo.repos.filter { repo in
            repo.repoId.hasPrefix("mlx-community/") || repo.repoId.contains("-MLX")
                || isMLX(repo: repo)
        }.map { repo in

            //            let file = try? HuggingfaceHub.Utility.tryToLoadFromCache(
            //                repoId: repo.repoId,
            //                filename: ""
            //            )

            return Model(
                provider: .mlx,
                name: repo.repoId,
                model: try .local(getModelDirectory(repo.repoPath))
            )
        }.sorted { $0.name < $1.name }
    }

    func getModelDirectory(_ repoPath: URL) throws -> URL {
        let defaultRevision = "main"
        let refsDir = repoPath.appendingPathComponent("refs")
        let revisionFile = refsDir.appendingPathComponent(defaultRevision)

        guard FileManager.default.fileExists(atPath: revisionFile.path) else {
            fatalError("Revision file not found")
        }

        let actualRevision = try String(contentsOf: revisionFile)
        let snapshotsDir = repoPath.appendingPathComponent("snapshots")
        let modelDirectory = snapshotsDir.appendingPathComponent(actualRevision)

        return modelDirectory
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
