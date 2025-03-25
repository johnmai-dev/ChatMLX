//
//  GreetingView.swift
//  UltraUI
//
//  Created by John Mai on 2025/2/23.
//

import SwiftUI

public struct GreetingView: View {

    @Environment(\.utlraTitle) private var utlraTitle
    @Environment(\.utlraSubtitle) private var utlraSubtitle

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6 ..< 12:
            return "Good Morning! ☀️"
        case 12 ..< 18:
            return "Good Afternoon! 🌇"
        default:
            return "Good Evening! 🌛"
        }
    }

    public init() {}

    public var body: some View {
        VStack {
            Text(greeting)
                .font(.largeTitle)
                .foregroundColor(utlraTitle)

            Text("How can I help you today?")
                .font(.title)
                .foregroundColor(utlraSubtitle)
        }
        .fontWeight(.bold)
        .shadow()
    }
}

#Preview {
    GreetingView()
}
