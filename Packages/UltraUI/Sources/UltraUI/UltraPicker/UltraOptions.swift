//
//  UltraOptions.swift
//  UltraUI
//
//  Created by John Mai on 2025/3/8.
//

import SwiftUI

struct UltraOptions<SelectionValue: Hashable>: View {

    @Binding var selection: SelectionValue?
    let options: [SelectionValue]
    let onSelection: (SelectionValue) -> Void
    @Environment(\.ultraViewBackground) var utlraViewBackground

    var body: some View {
        ScrollView {
            ForEach(options, id: \.self) { option in
                Button {
                    selection = option
                    onSelection(option)
                } label: {
                    Text("\(option)")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)

                }
                .buttonStyle(
                    UltraSidebarButtonStyle(selection == option)
                )
            }
        }
        .padding(4)
        .background(utlraViewBackground)
        .cornerRadius(10)
        .frame(maxHeight: 200)
    }
}
