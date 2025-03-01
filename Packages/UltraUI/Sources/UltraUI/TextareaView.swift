//
//  TextView.swift
//  UltraUI
//
//  Created by John Mai on 2025/2/23.
//

import Foundation
import STTextView
import SwiftUI

public struct TextareaView: NSViewRepresentable {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.lineSpacing) private var lineSpacing
    @Environment(\.utlraSubtitle) private var utlraSubtitle

    @Binding private var text: AttributedString
    let placeholder: String
    let font: NSFont
    private var plugins: [any STPlugin]

    public init(
        text: Binding<AttributedString>,
        placeholder: String = "66",
        plugins: [any STPlugin] = [],
        font: NSFont = .preferredFont(forTextStyle: .title3)
    ) {
        self._text = text
        self.placeholder = placeholder
        self.plugins = plugins
        self.font = font
    }

    public func makeNSView(context: Context) -> NSScrollView {
        let scrollView = STTextView.scrollableTextView()
        let textView = scrollView.documentView as! STTextView

        let placeholderView = NSTextField(labelWithString: placeholder)
        placeholderView.font = font
        placeholderView.textColor = NSColor(utlraSubtitle)
        placeholderView.isHidden = !text.characters.isEmpty
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.lineBreakMode = .byWordWrapping
        placeholderView.setContentCompressionResistancePriority(
            .defaultLow,
            for: .horizontal
        )

        placeholderView.refusesFirstResponder = true
        placeholderView.isEditable = false
        placeholderView.isSelectable = false

        textView.addSubview(placeholderView, positioned: .below, relativeTo: nil)

        NSLayoutConstraint.activate(
            [
                placeholderView.leadingAnchor.constraint(
                    equalTo: textView.leadingAnchor,
                    constant: 4
                ),
                placeholderView.topAnchor.constraint(
                    equalTo: textView.topAnchor,
                    constant: 0
                ),
                placeholderView.trailingAnchor.constraint(
                    lessThanOrEqualTo: scrollView.contentView.trailingAnchor,
                    constant: -4
                ),
            ]
        )

        context.coordinator.placeholderView = placeholderView

        textView.textDelegate = context.coordinator
        textView.highlightSelectedLine = false
        textView.isHorizontallyResizable = true
        textView.showsLineNumbers = false
        textView.textSelection = NSRange()
        textView.textColor = .white
        textView.markedTextAttributes = [.underlineColor: NSColor.clear]
        textView.changeDocumentBackgroundColor(NSColor.clear)

        context.coordinator.isUpdating = true
        textView.attributedText = NSAttributedString(text)
        context.coordinator.isUpdating = false

        for plugin in plugins {
            textView.addPlugin(plugin)
        }

        return scrollView
    }

    public func updateNSView(_ scrollView: NSScrollView, context: Context) {
        context.coordinator.parent = self

        let textView = scrollView.documentView as! STTextView

        do {
            context.coordinator.isUpdating = true
            if context.coordinator.isDidChangeText == false {
                textView.attributedText = NSAttributedString(text)
            }
            context.coordinator.isUpdating = false
            context.coordinator.isDidChangeText = false
        }

        let isEmpty = text.characters.isEmpty
        context.coordinator.placeholderView?.isHidden = !isEmpty
        context.coordinator.placeholderView?.stringValue = placeholder
        context.coordinator.placeholderView?.font = font

        if textView.isEditable != isEnabled {
            textView.isEditable = isEnabled
        }

        if textView.isSelectable != isEnabled {
            textView.isSelectable = isEnabled
        }

        if textView.font != font {
            textView.font = font
        }

        textView.needsLayout = true
        textView.needsDisplay = true
    }

    public func makeCoordinator() -> TextCoordinator {
        TextCoordinator(parent: self)
    }

    @MainActor
    public class TextCoordinator: @preconcurrency STTextViewDelegate {
        var parent: TextareaView
        var isUpdating: Bool = false
        var isDidChangeText: Bool = false
        weak var placeholderView: NSTextField?

        init(parent: TextareaView) {
            self.parent = parent
        }

        @MainActor
        public func textViewDidChangeText(_ notification: Notification) {
            guard let textView = notification.object as? STTextView else {
                return
            }

            let isEmpty = self.parent.text.characters.isEmpty
            placeholderView?.isHidden = !isEmpty

            if !isUpdating {
                let newTextValue = AttributedString(
                    textView.attributedText ?? NSAttributedString())

                Task { @MainActor in
                    self.isDidChangeText = true
                    self.parent.text = newTextValue
                }
            }
        }
    }
}
