//
//  LanguageTests.swift
//  Common
//
//  Created by John Mai on 2025/2/28.
//

import Testing

@testable import Models

@Test func availableLanguages() async throws {
    debugPrint(Language.allCases)
    print("Available languages count: \(Language.allCases.count)")

    for language in Language.allCases {
        print("Language: \(language)")
    }

    #expect(Language.allCases.count == 40)
}
