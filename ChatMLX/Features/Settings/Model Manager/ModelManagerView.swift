//
//  ModelManagerView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/4.
//
import SwiftUI

struct ModelManagerView: View {
    @State var isMLXExpanded: Bool = true

    var body: some View {
        ScrollView {
            LazyVStack {
                MLXProviderView()
                OpenAIProviderView()
            }
            .padding()
        }
        .ultramanNavigationTitle("Model Manager")
    }
}
