//
//  MarkdownMetadataTests.swift
//  ChatMLXTests
//
//  Created by John Mai on 2024/10/10.
//

import Testing

@testable import ChatMLX

struct MarkdownMetadataTests {
    @Test func testBasicMetadataParsing() async throws {
        let markdown = """
            ---
            license: other
            license_name: qwen
            license_link: https://huggingface.co/Qwen/Qwen2.5-VL-72B-Instruct/blob/main/LICENSE
            language:
            - en
            pipeline_tag: image-text-to-text
            tags:
             - multimodal
             - mlx
            library_name: transformers
            base_model:
            - Qwen/Qwen2.5-VL-72B-Instruct
            ---

            # Content
            This is the content.
            """

        let metadata = MarkdownMetadata(from: markdown)
        
        #expect(metadata.string(for: "license") == "other")
        #expect(metadata.string(for: "license_name") == "qwen")
        #expect(metadata.string(for: "license_link") == "https://huggingface.co/Qwen/Qwen2.5-VL-72B-Instruct/blob/main/LICENSE")
        #expect(metadata.array(for: "language") == ["en"])
        #expect(metadata.string(for: "pipeline_tag") == "image-text-to-text")
        #expect(metadata.array(for: "tags") == ["multimodal", "mlx"])
        #expect(metadata.string(for: "library_name") == "transformers")
        #expect(metadata.array(for: "base_model") == ["Qwen/Qwen2.5-VL-72B-Instruct"])
    }
}
