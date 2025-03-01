//
//  AppStore.swift
//  Common
//
//  Created by John Mai on 2025/2/27.
//

import Foundation
import Models

@MainActor
@Observable
final class AppStore {
    var models: [Model] = []
}
