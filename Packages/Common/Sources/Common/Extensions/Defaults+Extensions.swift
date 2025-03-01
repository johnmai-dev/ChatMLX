//
//  Defaults+Extensions.swift
//  Common
//
//  Created by John Mai on 2025/3/1.
//

import Defaults
import Foundation
import Models

extension Defaults.Keys {
    // MARK: - General
    public static let language = Key<Language>("language", default: .english)

    // MARK: - Appearance

    // MARK: - HuggingFace
    public static let huggingFaceToken = Key<String?>("huggingFaceToken")
    public static let huggingFaceEndpoint = Key<HuggingFaceEndpoint>(
        "huggingFaceEndpoint", default: .hugfaceFace)
    public static let huggingFaceCachePath = Key<URL?>("huggingFaceCachePath", default: nil)
}
