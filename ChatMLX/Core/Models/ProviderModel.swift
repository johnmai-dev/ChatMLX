//
//  ProviderModel.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/14.
//

import Foundation

struct ProviderModel {
    let id: String
    let provider: Provider
    let name: String?
    let path: URL?
    let maxInputLength: Int?
    let maxOutputLength: Int?
    let toolCall: Bool
    let vision: Bool

    init(
        id: String,
        provider: Provider,
        name: String? = nil,
        path: URL? = nil,
        maxInputLength: Int? = nil,
        maxOutputLength: Int? = nil,
        toolCall: Bool = false,
        vision: Bool = false
    ) {
        self.id = id
        self.provider = provider
        self.name = name
        self.path = path
        self.maxInputLength = maxInputLength
        self.maxOutputLength = maxOutputLength
        self.toolCall = toolCall
        self.vision = vision
    }
}

extension ProviderModel: Hashable {}

extension ProviderModel {
    init(from modelInfo: ModelInfo) {
        self.init(
            id: modelInfo.id,
            provider: modelInfo.provider,
            name: modelInfo.name,
            path: modelInfo.path,
            maxInputLength: Int(modelInfo.maxInputLength),
            maxOutputLength: Int(modelInfo.maxOutputLength),
            toolCall: modelInfo.toolCall,
            vision: modelInfo.vision
        )
    }
}
