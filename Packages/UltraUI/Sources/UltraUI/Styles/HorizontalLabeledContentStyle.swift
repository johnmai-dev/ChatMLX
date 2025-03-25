//
//  HorizontalLabeledContentStyle.swift
//  UltraUI
//
//  Created by John Mai on 2025/2/28.
//

import SwiftUI

public struct HorizontalLabeledContentStyle: LabeledContentStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .fontWeight(.medium)
            Spacer()
            configuration.content
                .foregroundColor(.secondary)
        }
    }
}

extension LabeledContentStyle where Self == HorizontalLabeledContentStyle {
    public static var horizontal: HorizontalLabeledContentStyle { .init() }
}
