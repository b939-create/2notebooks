import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \DayEntry.date, order: .reverse) private var entries: [DayEntry]
    @Environment(\.modelContext) private var modelContext

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
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        modelContext.delete(entry)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
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

struct EntryDetailView: View {
    let entry: DayEntry
    @Environment(\.modelContext) private var modelContext

    @State private var isEditing = false
    @State private var draftDeclaration = ""
    @State private var draftConfirmation = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                if isEditing {
                    editingBody
                } else {
                    readingBody
                }
            }
            .padding()
        }
        .navigationTitle(entry.date.formatted(date: .long, time: .omitted))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isEditing {
                    Button("Save") { commitEdits() }
                        .fontWeight(.semibold)
                        .tint(.orange)
                } else {
                    Button("Edit") { beginEditing() }
                }
            }
            if isEditing {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { isEditing = false }
                        .tint(.secondary)
                }
            }
        }
    }

    @ViewBuilder
    private var readingBody: some View {
        detailSection(title: "🌅 Morning Declaration",
                      text: entry.declaration,
                      color: .orange)
        Divider()
        detailSection(title: "🌙 Evening Confirmation",
                      text: entry.confirmation,
                      color: .indigo)
    }

    @ViewBuilder
    private var editingBody: some View {
        editSection(title: "🌅 Morning Declaration",
                    text: $draftDeclaration,
                    color: .orange)
        Divider()
        editSection(title: "🌙 Evening Confirmation",
                    text: $draftConfirmation,
                    color: .indigo)
    }

    @ViewBuilder
    private func detailSection(title: String, text: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline).foregroundStyle(color)
            if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text("Nothing written.").foregroundStyle(.secondary).italic()
            } else {
                Text(text).font(.body)
            }
        }
    }

    @ViewBuilder
    private func editSection(title: String, text: Binding<String>, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline).foregroundStyle(color)
            TextEditor(text: text)
                .frame(minHeight: 140)
                .padding(8)
                .background(color.opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .scrollContentBackground(.hidden)
        }
    }

    private func beginEditing() {
        draftDeclaration = entry.declaration
        draftConfirmation = entry.confirmation
        isEditing = true
    }

    private func commitEdits() {
        entry.declaration = draftDeclaration
        entry.confirmation = draftConfirmation
        try? modelContext.save()
        isEditing = false
    }
}
