//
//  ProviderModel.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/14.
//

import Defaults
import Foundation

struct ProviderModel: Identifiable {
    enum Identifier: Sendable, Equatable, Hashable, Codable, Defaults.Serializable {
        case id(String, Provider)
        case directory(URL, Provider)

        private enum IdentifierType: String, Codable {
            case id
            case directory
        }

        private enum CodingKeys: String, CodingKey {
            case type
            case provider
            case model
        }

        func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            switch self {
            case .id(let model, let provider):
                try container.encode(IdentifierType.id, forKey: .type)
                try container.encode(model, forKey: .model)
                try container.encode(provider, forKey: .provider)

            case .directory(let url, let provider):
                try container.encode(IdentifierType.directory, forKey: .type)
                try container.encode(url.absoluteString, forKey: .model)
                try container.encode(provider, forKey: .provider)
            }
        }

        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(IdentifierType.self, forKey: .type)
            switch type {
            case .id:
                let model = try container.decode(String.self, forKey: .model)
                let provider = try container.decode(Provider.self, forKey: .provider)
                self = .id(model, provider)
            case .directory:
                let model = try container.decode(String.self, forKey: .model)
                let provider = try container.decode(Provider.self, forKey: .provider)
                self = .directory(URL(string: model)!, provider)
            }
        }
    }

    let id: Identifier
    let name: String?
    let path: URL?
    let maxInputLength: Int?
    let maxOutputLength: Int?
    let toolCall: Bool
    let vision: Bool

    init(
        id: Identifier,
        name: String? = nil,
        path: URL? = nil,
        maxInputLength: Int? = nil,
        maxOutputLength: Int? = nil,
        toolCall: Bool = false,
        vision: Bool = false
    ) {
        self.id = id
        self.name = name
        self.path = path
        self.maxInputLength = maxInputLength
        self.maxOutputLength = maxOutputLength
        self.toolCall = toolCall
        self.vision = vision
    }
}

extension ProviderModel: Equatable {
    static func == (lhs: ProviderModel, rhs: ProviderModel) -> Bool {
        lhs.id == rhs.id
    }
}

extension ProviderModel: Hashable {}
