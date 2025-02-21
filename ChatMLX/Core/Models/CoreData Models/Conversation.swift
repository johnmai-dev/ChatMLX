//
//  Conversation.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/14.
//

import CoreData
import Defaults

extension Conversation {
    //    var modelIdentifier: ProviderModel.Identifier? {
    //        get {
    //            guard let modelType, let modelValue, let modelProvider, let provider = Provider(rawValue: modelProvider) else {
    //                return nil
    //            }
    //
    //            switch modelType {
    //            case "id":
    //                return .id(modelValue, provider)
    //            case "directory":
    //                guard let url = URL(string: modelValue) else { return nil }
    //                return .directory(url, provider)
    //            default:
    //                return nil
    //            }
    //        }
    //        set {
    //            switch newValue {
    //            case .id(let idString, let provider):
    //                modelType = "id"
    //                modelValue = idString
    //                modelProvider = provider.rawValue
    //            case .directory(let url, let provider):
    //                modelType = "directory"
    //                modelValue = url.absoluteString
    //                modelProvider = provider.rawValue
    //            case nil:
    //                modelType = nil
    //                modelValue = nil
    //                modelProvider = nil
    //            }
    //        }
    //    }

    var model: ProviderModel.Identifier? {
        get {
            guard let modelRaw = modelRaw?.data(using: .utf8) else { return nil }
            return try? JSONDecoder().decode(ProviderModel.Identifier.self, from: modelRaw)
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            modelRaw = String(data: data, encoding: .utf8)
        }
    }

    override public func awakeFromInsert() {
        super.awakeFromInsert()

        setPrimitiveValue(Defaults[.defaultTitle], forKey: #keyPath(Conversation.title))
        //        setPrimitiveValue(Defaults[.defaultModel], forKey: #keyPath(Conversation.model))

        setPrimitiveValue(Defaults[.defaultTemperature], forKey: #keyPath(Conversation.temperature))
        setPrimitiveValue(Defaults[.defaultTopP], forKey: #keyPath(Conversation.topP))
        setPrimitiveValue(
            Defaults[.defaultRepetitionContextSize],
            forKey: #keyPath(Conversation.repetitionContextSize))

        setPrimitiveValue(
            Defaults[.defaultUseRepetitionPenalty],
            forKey: #keyPath(Conversation.useRepetitionPenalty))
        setPrimitiveValue(
            Defaults[.defaultRepetitionPenalty], forKey: #keyPath(Conversation.repetitionPenalty))

        setPrimitiveValue(
            Defaults[.defaultUseMaxLength], forKey: #keyPath(Conversation.useMaxLength))
        setPrimitiveValue(Defaults[.defaultMaxLength], forKey: #keyPath(Conversation.maxLength))
        setPrimitiveValue(
            Defaults[.defaultMaxMessagesLimit], forKey: #keyPath(Conversation.maxMessagesLimit))
        setPrimitiveValue(
            Defaults[.defaultUseMaxMessagesLimit],
            forKey: #keyPath(Conversation.useMaxMessagesLimit))

        setPrimitiveValue(
            Defaults[.defaultUseSystemPrompt], forKey: #keyPath(Conversation.useSystemPrompt))
        setPrimitiveValue(
            Defaults[.defaultSystemPrompt], forKey: #keyPath(Conversation.systemPrompt))

        setPrimitiveValue(Date.now, forKey: #keyPath(Conversation.createdAt))
        setPrimitiveValue(Date.now, forKey: #keyPath(Conversation.updatedAt))
    }

    override public func willSave() {
        super.willSave()
        setPrimitiveValue(Date.now, forKey: #keyPath(Conversation.updatedAt))
    }

    func getLastAssistantMessage(context: NSManagedObjectContext) -> Message {
        if let message = messages.last, message.role == .assistant {
            message
        } else {
            Message(context: context).assistant(conversation: self)
        }
    }

    func prepareMessages() -> [[String: String]] {
        var messages = self.messages
        if self.useMaxMessagesLimit {
            let maxCount = self.maxMessagesLimit + 1
            if messages.count > maxCount {
                messages = Array(messages.suffix(Int(maxCount)))
                if messages.first?.role != .user {
                    messages = Array(messages.dropFirst())
                }
            }
        }

        var dictionary = messages[..<(messages.count - 1)].map {
            message -> [String: String] in
            message.format()
        }

        if self.useSystemPrompt, let systemPrompt = self.systemPrompt, !systemPrompt.isEmpty {
            dictionary.insert(
                self.formatMessage(
                    role: .system,
                    content: systemPrompt),
                at: 0)
        }

        return dictionary
    }

    private func formatMessage(role: Role, content: String) -> [String: String] {
        [
            "role": role.rawValue,
            "content": content,
        ]
    }
}

extension Conversation: @unchecked Sendable {}
