//
//  Theme.swift
//  ChatMLX
//
//  Created by John Mai on 2024/11/3.
//
import SwiftUI

@MainActor
@Observable
final class Theme {
    static let shared = Theme()

    let conversationDetailWidth: CGFloat = 550
    let padding: CGFloat = 8
}
