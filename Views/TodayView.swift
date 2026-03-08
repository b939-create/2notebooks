import SwiftUI

enum NotebookPane { case declaration, confirmation }

struct TodayView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: DayEntryViewModel?
    @FocusState private var focusedPane: NotebookPane?

    private var declarationRatio: CGFloat {
        switch focusedPane {
        case .confirmation: return 0.15
        case .declaration:  return 0.85
        default:            return 0.5
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if let vm = viewModel {
                    GeometryReader { geo in
                        VStack(spacing: 0) {
                            notebookPane(
                                title: "🌅 Morning Declaration",
                                text: Binding(get: { vm.declaration }, set: { vm.declaration = $0 }),
                                placeholder: "Write your intention for today…",
                                accentColor: .orange,
                                saved: vm.declarationSaved,
                                focusValue: .declaration,
                                onSave: { vm.saveDeclaration() }
                            )
                            .frame(height: geo.size.height * declarationRatio)
                            .onTapGesture { focusedPane = .declaration }

                            Divider()

                            notebookPane(
                                title: "🌙 Evening Confirmation",
                                text: Binding(get: { vm.confirmation }, set: { vm.confirmation = $0 }),
                                placeholder: "Reflect on your day…",
                                accentColor: .indigo,
                                saved: vm.confirmationSaved,
                                focusValue: .confirmation,
                                onSave: { vm.saveConfirmation() }
                            )
                            .frame(height: geo.size.height * (1 - declarationRatio))
                        }
                        .animation(.easeInOut(duration: 0.3), value: focusedPane)
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

    @ViewBuilder
    private func notebookPane(
        title: String,
        text: Binding<String>,
        placeholder: String,
        accentColor: Color,
        saved: Bool,
        focusValue: NotebookPane,
        onSave: @escaping () -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(accentColor)
                    .lineLimit(1)
                Spacer()
                if focusedPane == focusValue || focusedPane == nil {
                    Button(action: onSave) {
                        Label(saved ? "Saved!" : "Save",
                              systemImage: saved ? "checkmark.circle.fill" : "square.and.arrow.down")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(saved ? .green : accentColor)
                    }
                    .buttonStyle(.bordered)
                    .tint(saved ? .green : accentColor)
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
            .padding(.bottom, 4)

            ZStack(alignment: .topLeading) {
                if text.wrappedValue.isEmpty {
                    Text(placeholder)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .allowsHitTesting(false)
                }
                TextEditor(text: text)
                    .padding(.horizontal, 12)
                    .scrollContentBackground(.hidden)
                    .focused($focusedPane, equals: focusValue)
            }
            .background(accentColor.opacity(0.04))
        }
        .clipped()
    }

    private var todayTitle: String {
        Date.now.formatted(.dateTime.weekday(.wide).month().day())
    }
}
