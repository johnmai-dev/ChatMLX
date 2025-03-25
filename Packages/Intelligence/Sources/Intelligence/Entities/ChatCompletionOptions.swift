//
//  ChatCompletionOptions.swift
//  Intelligence
//
//  Created by John Mai on 2025/3/9.
//


public struct ChatCompletionOptions: Sendable {
    let temperature: Float?
    let maxTokens: Int?
    let topP: Float?
    let stop: [String]?

    init(
        temperature: Float? = nil,
        maxTokens: Int? = nil,
        topP: Float? = nil,
        stop: [String]? = nil
    ) {
        self.temperature = temperature
        self.maxTokens = maxTokens
        self.topP = topP
        self.stop = stop
    }
}
