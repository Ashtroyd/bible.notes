//
//  SettingsView.swift
//  Bible Notes
//
//  App settings and preferences
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Query private var allNotes: [Note]
    
    @AppStorage("editorFontSize") private var fontSize: Double = 16
    @AppStorage("autoSave") private var autoSave = true
    @AppStorage("showWordCount") private var showWordCount = false
    @AppStorage("defaultBook") private var defaultBook = ""
    
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("EDITOR") {
                    HStack {
                        Text("Font Size")
                        Spacer()
                        Text("\(Int(fontSize))pt")
                            .foregroundStyle(.secondary)
                    }
                    
                    Slider(value: $fontSize, in: 12...24, step: 1)
                    
                    Toggle("Auto-save notes", isOn: $autoSave)
                    Toggle("Show word count", isOn: $showWordCount)
                }
                
                Section("DEFAULTS") {
                    Picker("Default Book", selection: $defaultBook) {
                        Text("None").tag("")
                        ForEach(BibleBookList.ordered, id: \.self) { book in
                            Text(book).tag(book)
                        }
                    }
                }
                
                Section("STORAGE") {
                    HStack {
                        Text("Total Notes")
                        Spacer()
                        Text("\(allNotes.filter { !$0.isDeleted }.count)")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Deleted Notes")
                        Spacer()
                        Text("\(allNotes.filter { $0.isDeleted }.count)")
                            .foregroundStyle(.secondary)
                    }
                    
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Text("Empty Deleted Notes")
                    }
                }
                
                Section("ABOUT") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Empty Deleted Notes?", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete All", role: .destructive) {
                    emptyTrash()
                }
            } message: {
                Text("This will permanently delete all notes in your Recently Deleted folder. This action cannot be undone.")
            }
        }
    }
    
    private func emptyTrash() {
        let deleted = allNotes.filter { $0.isDeleted }
        for note in deleted {
            context.delete(note)
        }
        Haptics.warning()
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: [Note.self, Theme.self, Attachment.self], inMemory: true)
}
