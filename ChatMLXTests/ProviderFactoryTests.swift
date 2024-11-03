//
//  ProviderFactoryTests.swift
//  ChatMLXTests
//
//  Created by John Mai on 2024/10/13.
//

@testable import ChatMLX
import Testing

struct ProviderFactoryTests {
    @Test func mlx() async throws {
        let models = await ProviderFactory.shared.provider(.mlx).listModels()
        print(models)
    }
}
