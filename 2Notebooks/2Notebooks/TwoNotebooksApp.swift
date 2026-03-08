//
//  TwoNotebooksApp.swift
//  2Notebooks
//
//  Created by Vladimir Belousov on 03.03.2026.
//


import SwiftUI
import SwiftData

@main
struct TwoNotebooksApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: DayEntry.self)
    }
}