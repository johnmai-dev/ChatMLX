//
//  UltraPicker.swift
//  UltraUI
//
//  Created by John Mai on 2025/2/26.
//

import SwiftUI

public struct UltraPicker<SelectionValue: Hashable>: View {
    let options: [SelectionValue]

    @Binding var selection: SelectionValue?

    @State private var rect: CGRect = .zero

    @State private var controller: UltraOptionsWindowController?

    public init(options: [SelectionValue], selection: Binding<SelectionValue?>) {
        self.options = options
        self._selection = selection
    }

    public var body: some View {
        Button {
            showOptionsPanel()
        } label: {
            HStack {
                Text(selection == nil ? "Select a model" : "\(selection!)")
                    .lineLimit(1)
                    .truncationMode(.head)
                Image(systemName: "chevron.down")
            }
        }
        .onGeometryChange(for: CGRect.self) {
            $0.frame(in: .global)
        } action: {
            rect = $0
        }
        .buttonStyle(.ultraPlain)
    }

    private func showOptionsPanel() {
        if controller == nil {
            controller = UltraOptionsWindowController(
                NSHostingView(
                    rootView: UltraOptions(
                        selection: $selection,
                        options: options,
                        onSelection: { _ in
                            controller?.closeWindow()
                        })
                )
            )
        }

        controller?.showWindow()
        controller?.setWindowPosition(rect)
    }
}
