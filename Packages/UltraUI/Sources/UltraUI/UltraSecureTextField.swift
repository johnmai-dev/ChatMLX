//
//  UltraSecureTextField.swift
//  UltraUI
//
//  Created by John Mai on 2025/3/1.
//

import SwiftUI

public struct UltraSecureTextField: NSViewRepresentable {
    @Binding var text: String

    let placeholder: String

    @Environment(\.utlraPlaceholder) var utlraPlaceholder
    @Environment(\.utlraText) var utlraText

    public init(
        text: Binding<String>,
        placeholder: String
    ) {
        self._text = text
        self.placeholder = placeholder
    }

    public func makeNSView(context: Context) -> NSTextField {
        let textField = NSSecureTextField()
        textField.delegate = context.coordinator
        textField.placeholderString = placeholder

        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: NSColor(utlraPlaceholder),
            .font: NSFont.preferredFont(forTextStyle: .body),
        ]
        textField.placeholderAttributedString = NSAttributedString(
            string: placeholder,
            attributes: attributes
        )

        textField.font = NSFont.preferredFont(forTextStyle: .body)
        textField.textColor = NSColor(utlraText)
        textField.drawsBackground = false
        textField.backgroundColor = .clear
        textField.isBordered = false
        textField.isBezeled = false
        textField.focusRingType = .none
        textField.isEditable = true
        textField.isSelectable = true

        return textField
    }

    public func updateNSView(_ nsView: NSTextField, context: Context) {
        nsView.stringValue = text
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public class Coordinator: NSObject, NSTextFieldDelegate {
        var parent: UltraSecureTextField

        init(_ parent: UltraSecureTextField) {
            self.parent = parent
        }

        public func controlTextDidChange(_ notification: Notification) {
            if let textField = notification.object as? NSTextField {
                parent.text = textField.stringValue
            }
        }
    }
}

#Preview {

    @Previewable @State var password: String = ""

    VStack {
        UltraSecureTextField(
            text: $password,
            placeholder: "Enter your password"
        )
    }
    .padding()
    .background(Color.black.opacity(0.5))
}
