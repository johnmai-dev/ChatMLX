//
//  ErrorView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/26.
//

import SwiftUI

struct ErrorEnvironmentKey: EnvironmentKey {
    static let defaultValue: @Sendable (Error) -> Void = { _ in }
}

extension EnvironmentValues {
    var appError: @Sendable (Error) -> Void {
        get { self[ErrorEnvironmentKey.self] }
        set { self[ErrorEnvironmentKey.self] = newValue }
    }
}

struct ErrorView: View {
    let errorWrapper: ErrorWrapper

    var body: some View {
        VStack {
            Text("An error has occurred!")
                .font(.title)
                .padding(.bottom)
            Text(errorWrapper.error.localizedDescription)
                .font(.headline)
            Text(errorWrapper.guidance)
                .font(.caption)
                .padding(.top)
            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
}
