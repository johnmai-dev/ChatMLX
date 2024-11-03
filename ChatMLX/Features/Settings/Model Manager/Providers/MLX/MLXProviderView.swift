//
//  MLXProvider.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/4.
//

import SwiftUI

struct MLXProviderView: View {
    var body: some View {
        ProviderView(isExpanded: true, isEnabled: .constant(nil)) {
            MLXProviderLabelView()
        } content: {
            MLXProviderContentView()
        }
    }
}
