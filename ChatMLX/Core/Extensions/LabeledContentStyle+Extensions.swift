//
//  LabeledContentStyle+Extensions.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/5.
//

import SwiftUI

struct HorizontalLabeledContentStyle: LabeledContentStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            configuration.content
        }
        .frame(minHeight: 35)
        .padding(.horizontal)
        
    }
}

extension LabeledContentStyle where Self == HorizontalLabeledContentStyle {
    static var horizontal: HorizontalLabeledContentStyle { .init() }
}

struct VerticalLabeledContentStyle: LabeledContentStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            configuration.label
            configuration.content
        }
    }
}

extension LabeledContentStyle where Self == VerticalLabeledContentStyle {
    static var vertical: VerticalLabeledContentStyle { .init() }
}
