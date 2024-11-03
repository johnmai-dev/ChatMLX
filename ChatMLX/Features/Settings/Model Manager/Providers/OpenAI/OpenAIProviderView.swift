//
//  OpenAIProvider.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/4.
//

import Defaults
import Luminare
import SwiftUI

struct OpenAIProviderView: View {
    @State var isExpanded: Bool = false
    @State var isEnabled: Bool? = false

    @Default(.enableOpenAI) var enableOpenAI

    var body: some View {
        ProviderView(
            isEnabled: Binding(
                get: { enableOpenAI },
                set: { enableOpenAI = $0 ?? false }
            )
        ) {
            Label()
        } content: {
            Content()
        }
    }

    @ViewBuilder
    func Label() -> some View {
        HStack {
            Image("openai-logomark")
                .resizable()
                .scaledToFit()
                .frame(height: 24)
            Text("Other AI Provider")
        }
        .font(.title2.weight(.medium))
    }

    @ViewBuilder
    func Content() -> some View {
        DividedVStack {
            // API Key
            LabeledContent("API Key") {
                SecureField("API Key", text: .constant(""))
            }

            // API 代理地址
            LabeledContent("API Proxy Address") {
                TextField("API Proxy Address", text: .constant(""))
            }
        }
    }
}
