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
    @Default(.openAIApiKey) var openAIApiKey
    @Default(.openAIBaseURL) var openAIBaseURL

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
            LabeledContent("API Key") {
                UltramanSecureField(
                    $openAIApiKey,
                    placeholder: Text("Enter your OpenAI API Key"),
                    alignment: .trailing
                )
            }

            LabeledContent("API Proxy Address") {
                UltramanTextField(
                    $openAIBaseURL,
                    placeholder: Text("Enter your OpenAI API Proxy Address"),
                    alignment: .trailing
                )
            }
        }
        .labeledContentStyle(.horizontal)
    }
}
