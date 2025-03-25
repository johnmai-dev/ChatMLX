//
//  Divided.swift
//  UltraUI
//
//  Created by John Mai on 2025/2/28.
//

import SwiftUI

struct Divided<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        _VariadicView.Tree(Root()) { content }
    }

    struct Root: _VariadicView_MultiViewRoot {
        @ViewBuilder
        func body(children: _VariadicView.Children) -> some View {
            let last = children.last?.id

            ForEach(children) { child in
                child

                if child.id != last {
                    Divider()
                        .foregroundStyle(.secondary.opacity(0.2))
                }
            }
        }
    }
}
