//
//  ContentView.swift
//  2Notebooks
//
//  Created by Vladimir Belousov on 03.03.2026.
//


import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "book.pages")
                }

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
        }
    }
}