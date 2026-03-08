//
//  HistoryView.swift
//  2Notebooks
//
//  Created by Vladimir Belousov on 03.03.2026.
//


import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \DayEntry.date, order: .reverse) private var entries: [DayEntry]

    var body: some View {
        NavigationStack {
            List(entries) { entry in
                NavigationLink(destination: EntryDetailView(entry: entry)) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.date.formatted(date: .long, time: .omitted))
                            .font(.subheadline.weight(.semibold))
                        Text(preview(entry.declaration))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("History")
            .overlay {
                if entries.isEmpty {
                    ContentUnavailableView(
                        "No entries yet",
                        systemImage: "book.closed",
                        description: Text("Start writing in the Today tab.")
                    )
                }
            }
        }
    }

    private func preview(_ text: String) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "No declaration written." }
        return String(trimmed.prefix(50))
    }
}

// MARK: - Detail View

struct EntryDetailView: View {
    let entry: DayEntry

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                section(
                    title: "🌅 Morning Declaration",
                    text: entry.declaration,
                    color: .orange
                )
                Divider()
                section(
                    title: "🌙 Evening Confirmation",
                    text: entry.confirmation,
                    color: .indigo
                )
            }
            .padding()
        }
        .navigationTitle(entry.date.formatted(date: .long, time: .omitted))
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func section(title: String, text: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundStyle(color)
            if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text("Nothing written.")
                    .foregroundStyle(.secondary)
                    .italic()
            } else {
                Text(text)
                    .font(.body)
            }
        }
    }
}