//
//  UltraPicker.swift
//  UltraUI
//
//  Created by John Mai on 2025/2/26.
//

import SwiftUI

public struct UltraPicker<SelectionValue: Hashable>: View {

    @Environment(\.utlraViewBackground) var utlraViewBackground

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

    @ViewBuilder
    private func optionsPanel() -> some View {
        VStack {
            ForEach(options, id: \.self) { option in
                Button {
                    selection = option
                    controller?.close()
                } label: {
                    Text("\(option)")

                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)

                }
                .buttonStyle(
                    UltraSidebarButtonStyle(selection == option)
                )
            }
        }
        .padding(8)
        .background(utlraViewBackground)
        .cornerRadius(10)
    }

    private func showOptionsPanel() {
        if controller == nil {
            controller = UltraOptionsWindowController(
                NSHostingView(
                    rootView: optionsPanel()
                )
            )
        }

        controller?.showWindow()
        controller?.setWindowPosition(rect)

    }
}
