//
//  Language.swift
//  Utilities
//
//  Created by John Mai on 2025/2/28.
//

import Defaults
import Foundation

public enum Language: String {
    case english = "en"
    case arabic = "ar"
    case chineseHongKong = "zh-HK"
    case simplifiedChinese = "zh-Hans"
    case traditionalChinese = "zh-Hant"
    case catalan = "ca"
    case croatian = "hr"
    case czech = "cs"
    case danish = "da"
    case dutch = "nl"
    case enAU = "en-AU"
    case enGB = "en-GB"
    case enIN = "en-IN"
    case finnish = "fi"
    case french = "fr"
    case frenchCanadian = "fr-CA"
    case de = "de"
    case greek = "el"
    case hebrew = "he"
    case hindi = "hi"
    case hungarian = "hu"
    case indonesian = "id"
    case italian = "it"
    case japanese = "ja"
    case korean = "ko"
    case malay = "ms"
    case norwegian = "nb"
    case polish = "pl"
    case portuguese = "pt-PT"
    case portugueseBrazilian = "pt-BR"
    case romanian = "ro"
    case russian = "ru"
    case slovak = "sk"
    case spanish = "es"
    case spanishLatinAmerica = "es-419"
    case swedish = "sv"
    case thai = "th"
    case turkish = "tr"
    case ukrainian = "uk"
    case vietnamese = "vi"

}

extension Language: Identifiable {
    public var id: String {
        self.rawValue
    }
}
extension Language: CaseIterable {}
extension Language: Defaults.Serializable {}

extension Language: CustomStringConvertible {
    public var description: String {
        let components = self.rawValue.components(separatedBy: "-")
        let languageCode = components[0]

        var languageComponents = Locale.Language.Components(identifier: languageCode)

        var scriptName: String? = nil
        var regionName: String? = nil

        if components.count > 1 {
            let secondPart = components[1]

            if secondPart.count == 4 && secondPart.first?.isUppercase == true {
                languageComponents.script = Locale.Script(secondPart)
                let currentLocale = Locale.current
                scriptName = currentLocale.localizedString(forScriptCode: secondPart)
            } else {
                languageComponents.region = Locale.Region(secondPart)
                let currentLocale = Locale.current
                regionName = currentLocale.localizedString(forRegionCode: secondPart)
            }
        }

        let nativeLocale =
            Locale(languageComponents: languageComponents).localizedString(
                forLanguageCode: languageCode)?.capitalized ?? ""
        let currentLocale =
            Locale.current.localizedString(forLanguageCode: languageCode)?.capitalized ?? ""

        var result = "\(nativeLocale)"

        if nativeLocale != currentLocale {
            result += " \(currentLocale)"
        }

        if let scriptName = scriptName {
            result += " (\(scriptName))"
        } else if let regionName = regionName {
            result += " (\(regionName))"
        }

        return result
    }
}
