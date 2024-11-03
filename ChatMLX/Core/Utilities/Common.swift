//
//  Common.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/15.
//

import Foundation

func getVersion() -> String {
    Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
}
