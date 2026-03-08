//
//  DayEntryViewModel.swift
//  2Notebooks
//
//  Created by Vladimir Belousov on 03.03.2026.
//


import Foundation
import SwiftData
import SwiftUI

@Observable
final class DayEntryViewModel {
    var declaration: String = ""
    var confirmation: String = ""
    var declarationSaved = false
    var confirmationSaved = false

    private(set) var entry: DayEntry?
    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadOrCreateToday()
    }

    // MARK: - Load / Create

    func loadOrCreateToday() {
        let today = DayEntry.startOfDay()
        let descriptor = FetchDescriptor<DayEntry>(
            predicate: #Predicate { $0.date == today }
        )

        if let existing = try? modelContext.fetch(descriptor).first {
            entry = existing
        } else {
            let newEntry = DayEntry(date: today)
            modelContext.insert(newEntry)
            entry = newEntry
        }

        declaration = entry?.declaration ?? ""
        confirmation = entry?.confirmation ?? ""
    }

    // MARK: - Save

    func saveDeclaration() {
        entry?.declaration = declaration
        save()
        withAnimation { declarationSaved = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation { self.declarationSaved = false }
        }
    }

    func saveConfirmation() {
        entry?.confirmation = confirmation
        save()
        withAnimation { confirmationSaved = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation { self.confirmationSaved = false }
        }
    }

    private func save() {
        try? modelContext.save()
    }
}