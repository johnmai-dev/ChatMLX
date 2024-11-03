//
//  Bundle+Extensions.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/15.
//

import Foundation

extension Bundle {
    func getInfoDictionary(_ str: String) -> String? {
        infoDictionary?[str] as? String
    }

    var version: String {
        getInfoDictionary("CFBundleVersion") ?? "Unknown"
    }

    var shortVersion: String {
        getInfoDictionary("CFBundleShortVersionString") ?? "Unknown"
    }

    var name: String {
        getInfoDictionary("CFBundleName") ?? "ChatMLX"
    }
}
