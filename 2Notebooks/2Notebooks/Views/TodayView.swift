//
//  TodayView.swift
//  2Notebooks
//
//  Created by Vladimir Belousov on 03.03.2026.
//


import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: DayEntryViewModel?

    var body: some View {
        NavigationStack {
            Group {
                if let vm = viewModel {
                    GeometryReader { geo in
                        VStack(spacing: 0) {
                            // ── Top Half: Declaration ──────────────────────
                            notebookPane(
                                title: "🌅 Morning Declaration",
                                text: Binding(
                                    get: { vm.declaration },
                                    set: { vm.declaration = $0 }
                                ),
                                placeholder: "Write your intention for today…",
                                accentColor: .orange,
                                saved: vm.declarationSaved,
                                onSave: { vm.saveDeclaration() }
                            )
                            .frame(height: geo.size.height / 2)

                            Divider()

                            // ── Bottom Half: Confirmation ──────────────────
                            notebookPane(
                                title: "🌙 Evening Confirmation",
                                text: Binding(
                                    get: { vm.confirmation },
                                    set: { vm.confirmation = $0 }
                                ),
                                placeholder: "Reflect on your day…",
                                accentColor: .indigo,
                                saved: vm.confirmationSaved,
                                onSave: { vm.saveConfirmation() }
                            )
                            .frame(height: geo.size.height / 2)
                        }
                    }
                    .ignoresSafeArea(.keyboard)
                } else {
                    ProgressView()
                }
            }
            .navigationTitle(todayTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            if viewModel == nil {
                viewModel = DayEntryViewModel(modelContext: modelContext)
            }
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private func notebookPane(
        title: String,
        text: Binding<String>,
        placeholder: String,
        accentColor: Color,
        saved: Bool,
        onSave: @escaping () -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(accentColor)
                Spacer()
                Button(action: onSave) {
                    Label(saved ? "Saved!" : "Save",
                          systemImage: saved ? "checkmark.circle.fill" : "square.and.arrow.down")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(saved ? .green : accentColor)
                        .animation(.easeInOut, value: saved)
                }
                .buttonStyle(.bordered)
                .tint(saved ? .green : accentColor)
            }
            .padding(.horizontal)
            .padding(.top, 12)
            .padding(.bottom, 6)

            ZStack(alignment: .topLeading) {
                if text.wrappedValue.isEmpty {
                    Text(placeholder)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                }
                TextEditor(text: text)
                    .padding(.horizontal, 12)
                    .scrollContentBackground(.hidden)
            }
            .background(accentColor.opacity(0.04))
        }
    }

    private var todayTitle: String {
        let f = DateFormatter()
        f.dateStyle = .full
        f.timeStyle = .none
        return f.string(from: .now)
    }
}