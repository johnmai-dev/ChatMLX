//
//  Date+Extensions.swift
//  UltraUI
//
//  Created by John Mai on 2025/2/22.
//

import Foundation

extension Date {
    func formatted() -> String {
        let now = Date()
        let calendar = Calendar.current

        let yearDiff = calendar.dateComponents([.year], from: self, to: now).year ?? 0
        let dayDiff = calendar.dateComponents([.day], from: self, to: now).day ?? 0

        if dayDiff < 3 {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .short
            return formatter.localizedString(for: self, relativeTo: now)
        } else if yearDiff < 1 {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd HH:mm"
            return formatter.string(from: self)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            return formatter.string(from: self)
        }
    }
}
