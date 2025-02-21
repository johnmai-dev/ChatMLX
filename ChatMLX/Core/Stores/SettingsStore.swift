//
//  SettingsStore.swift
//  ChatMLX
//
//  Created by John Mai on 2024/11/10.
//

import Defaults
import SwiftUI

@MainActor
@Observable
class SettingsStore {
    var activeTabID: SettingsTab.ID = .general
}
