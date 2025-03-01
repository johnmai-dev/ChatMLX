//
//  SettingsSidebarView.swift
//  Sources
//
//  Created by John Mai on 2025/2/27.
//

import Models
import SwiftUI
import UltraUI

struct SettingsSidebarView: View {

    @Binding var selection: SettingsTab

    let tabs: [SettingsTab]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
                Text("Settings")
                    .font(.title2)
                Text("Preferences and model settings")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.5))
            }
            .padding()

            List {
                ForEach(tabs) { tab in
                    item(tab).tag(tab.id)
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)

            Spacer()
        }

    }

    @ViewBuilder
    private func item(_ tab: SettingsTab) -> some View {
        Button(
            action: {
                selection = tab
            },
            label: {
                HStack {
                    tab.iconView()

                    Text(LocalizedStringKey(tab.id.rawValue))

                    if tab.showIndicator?() == true {
                        VStack {
                            Circle()
                                .foregroundStyle(.red)
                                .frame(width: 4, height: 4)
                                .padding(.top, 6)
                                .shadow(color: .red, radius: 4)

                            Spacer()
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
        )

        .buttonStyle(
            UltraSidebarButtonStyle(selection == tab)
        )
        .lineLimit(1)
    }
}
