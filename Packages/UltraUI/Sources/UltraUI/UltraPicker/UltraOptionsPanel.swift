//
//  UltraOptionsPanel.swift
//  UltraUI
//
//  Created by John Mai on 2025/2/26.
//

import AppKit

class UltraOptionsPanel: NSPanel {
    override var canBecomeKey: Bool {
        return true
    }

    override var canBecomeMain: Bool {
        return false
    }
}
