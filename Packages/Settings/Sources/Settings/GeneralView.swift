//
//  GeneralView.swift
//  Sources
//
//  Created by John Mai on 2025/2/27.
//

import Common
import Defaults
import Models
import SwiftUI
import UltraUI

struct GeneralView: View {

    @Default(.language) var language

    var body: some View {
        VStack {
            UltraSection {
                LabeledContent("Language") {
                    Picker(
                        "Language",
                        selection: $language
                    ) {
                        ForEach(Language.allCases) { language in
                            Text(language.description).tag(language)
                        }
                    }
                    .buttonStyle(.borderless)
                    .tint(.white)
                    .labelsHidden()
                }
            } header: {
                Text("Language")
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    VStack {
        GeneralView()
            .labeledContentStyle(.horizontal)
            .foregroundStyle(.white)
    }.background(Color.black.opacity(0.5))
}
