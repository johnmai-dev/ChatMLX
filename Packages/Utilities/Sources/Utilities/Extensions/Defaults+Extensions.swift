//
//  Defaults+Extensions.swift
//  Utilities
//
//  Created by John Mai on 2025/3/1.
//

import Defaults
import Foundation

extension Defaults.Keys {
    // MARK: - General
    public static let language = Key<Language>("language", default: .english)

    // MARK: - Appearance

    // MARK: - HuggingFace
    public static let huggingFaceToken = Key<String?>("huggingFaceToken")
    public static let huggingFaceEndpoint = Key<HuggingFaceEndpoint>(
        "huggingFaceEndpoint", default: .hugfaceFace)
    public static let huggingFaceCachePath = Key<URL?>("huggingFaceCachePath", default: nil)

    // MARK: - Models
    public static let disabledModels = Key<[String]>("disabledModels", default: [])
    
    // MARK: - Providers
    public static let gpuCacheLimit = Key<Int>("gpuCacheLimit", default: 1024)
    public static let gpuMemoryLimit = Key<Int?>("gpuMemoryLimit", default: nil)
}
