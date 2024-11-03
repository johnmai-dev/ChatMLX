//
//  LabeledToggle.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/26.
//

import SwiftUI

struct LabeledToggle: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        LabeledContent(title) {
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(.switch)
        }
        .labeledContentStyle(.horizontal)
    }
}
