//
//  MarkdownMetadataTests.swift
//  ChatMLXTests
//
//  Created by John Mai on 2024/10/10.
//

@testable import ChatMLX
import Testing

struct MarkdownMetadataTests {
    @Test func testBasicMetadataParsing() async throws {
        let markdown = """
        ---
        title: Test Title
        date: 2024-10-01
        author: John Mai
        ---

        # Content
        This is the content.
        """

        let parser = MarkdownMetadata(markdown: markdown)
        #expect(parser.metadata["title"] == "Test Title")
        #expect(parser.metadata["date"] == "2024-10-01")
        #expect(parser.metadata["author"] == "John Mai")
    }
}
