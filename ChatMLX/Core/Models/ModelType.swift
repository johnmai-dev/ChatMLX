//
//  TaskType.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/20.
//

import Foundation
import SwiftUI

enum ModelType: String {
    case textGeneration = "text-generation"
    case imageTextToText = "image-text-to-text"
    case anyToAny = "any-to-any"
    case unknown

    var name: LocalizedStringKey {
        switch self {
        case .textGeneration:
            "Text Generation"
        case .imageTextToText:
            "Image Text to Text (Vision)"
        case .anyToAny:
            "Any to Any"
        case .unknown:
            "Unknown"
        }
    }
}
