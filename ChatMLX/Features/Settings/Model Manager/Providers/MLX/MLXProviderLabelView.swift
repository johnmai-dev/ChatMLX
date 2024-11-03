//
//  MLXProviderLabelView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/26.
//

import SwiftUI

struct MLXProviderLabelView: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("ML")
                .foregroundStyle(.black)
            Text("X")
                .foregroundStyle(Color(hex: "#D5D5D5"))
        }
        .font(.title2.weight(.medium))
    }
}
