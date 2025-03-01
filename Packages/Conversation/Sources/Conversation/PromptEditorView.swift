//
//  PromptEditor.swift
//  Conversation
//
//  Created by John Mai on 2025/2/23.
//

import Models
import STTextView
import SwiftUI
import UltraUI

struct PromptEditorView<LeadingToolbar: View, TrailingToolbar: View>: View {
    @Environment(\.utlraViewBackground) var utlraViewBackground

    @Binding var prompt: AttributedString

    @ViewBuilder var leadingToolbar: () -> LeadingToolbar
    @ViewBuilder var trailingToolbar: () -> TrailingToolbar

    @State private var height: CGFloat = 36
    @State private var selection: NSRange? = nil

    @State private var models: [Model] = []

    @State var model: Model? = nil

    @Environment(\.utlraRadius) var ultraRadius

    let font: NSFont = .preferredFont(forTextStyle: .title3)
    let minHeight: CGFloat = 36
    let maxHeight: CGFloat = 200

    var body: some View {
        VStack(spacing: .zero) {
            TextareaView(
                text: $prompt,
                placeholder: "What do you want to know?",
                plugins: [
                    TextViewPlugin(
                        font: font,
                        onHeightChange: updateHeight
                    )
                ],
                font: font
            )
            .frame(minHeight: minHeight)
            .frame(height: height)
            .transition(.move(edge: .top))

            HStack {
                Button {

                } label: {
                    Image(systemName: "paperclip")
                }.buttonStyle(.ultraIcon)

                // 网络搜索
                Button {

                } label: {
                    Image(systemName: "network")
                }.buttonStyle(.ultraIcon)

                leadingToolbar()
                Spacer()
                trailingToolbar()
                UltraPicker(
                    options: models,
                    selection: $model
                )

                Button("Send", systemImage: "paperplane.fill") {
                    print("Send")
                }.buttonStyle(.ultra)
            }

        }
        .padding()
        .background(utlraViewBackground)
        .cornerRadius(ultraRadius)
        .shadow()
        .padding()
        .task {
            //            do {
            //                models = try HuggingfaceHubService().scanMLXModels()
            //            } catch {
            //                print(error)
            //            }
        }
    }

    func updateHeight(height: CGFloat) {
        if height != self.height && minHeight < height && height < maxHeight {
            Task { @MainActor in
                withAnimation {
                    self.height = height
                }
            }
        }
    }
}

extension PromptEditorView {
    struct TextViewPlugin: STPlugin {
        let font: NSFont
        let onHeightChange: (CGFloat) -> Void

        func setUp(context: any Context) {
            let textView = context.textView
            let textLayoutManager = textView.textLayoutManager

            calculateAndUpdateHeight(textLayoutManager)

            context.events.onDidChangeText { _, _ in
                calculateAndUpdateHeight(textLayoutManager)
            }
        }

        private func calculateAndUpdateHeight(
            _ textLayoutManager: NSTextLayoutManager?
        ) {
            var line = 0

            if let viewportRange = textLayoutManager?
                .textViewportLayoutController.viewportRange
            {
                textLayoutManager?.enumerateTextLayoutFragments(
                    in: viewportRange,
                    options: .ensuresLayout
                ) { fragment in
                    line += fragment.textLineFragments.count
                    return true
                }
            }

            let layoutManager = NSLayoutManager()
            let lineHeight = layoutManager.defaultLineHeight(
                for: font)
            let newHeight = CGFloat(max(1, line)) * lineHeight

            onHeightChange(newHeight)
        }
    }

}
