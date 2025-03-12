//
//  ChatCompletionStreamChunk.swift
//  Intelligence
//
//  Created by John Mai on 2025/3/9.
//


public struct ChatCompletionStreamChunk: Sendable {
    public let content: String?
    public let finishReason: String?
}
