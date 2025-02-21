////
////  DefaultProviderPicker.swift
////  ChatMLX
////
////  Created by John Mai on 2024/10/21.
////
//
//import Defaults
//import SwiftUI
//
//struct DefaultProviderPicker:View {
//    @Binding var provider: Provider
//
//    @Default(.enableOpenAI) private var enableOpenAI
//
//    var body: some View {
//        Picker("Provider", selection: $provider) {
//            Text("MLX").tag(Provider.mlx)
//
//            if enableOpenAI {
//                Text("OpenAI").tag(Provider.openAI)
//            }
//        }
//        .pickerStyle(.menu)
//        .labelsHidden()
//        .tint(.white)
//    }
//}
