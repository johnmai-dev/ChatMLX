import Defaults
//
//  HuggingFaceEndpoint.swift
//  Models
//
//  Created by John Mai on 2025/3/1.
//
import Foundation

public enum HuggingFaceEndpoint: String {
    case hugfaceFace = "https://huggingface.co"
    case hfMirror = "https://hf-mirror.com"
}

extension HuggingFaceEndpoint: CaseIterable {}
extension HuggingFaceEndpoint: Identifiable {
    public var id: String { rawValue }
}
extension HuggingFaceEndpoint: Defaults.Serializable {}
