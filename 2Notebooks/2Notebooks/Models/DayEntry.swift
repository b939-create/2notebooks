//
//  DayEntry.swift
//  2Notebooks
//
//  Created by Vladimir Belousov on 03.03.2026.
//


import Foundation
import SwiftData

@Model
final class DayEntry {
    var date: Date
    var declaration: String
    var confirmation: String

    init(date: Date = Calendar.current.startOfDay(for: .now),
         declaration: String = "",
         confirmation: String = "") {
        self.date = date
        self.declaration = declaration
        self.confirmation = confirmation
    }

    /// Strips time component so each calendar day maps to exactly one entry
    static func startOfDay(_ date: Date = .now) -> Date {
        Calendar.current.startOfDay(for: date)
    }
}