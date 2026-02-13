//
//  NoteEditorView.swift
//  Bible Notes
//
//  Full-featured note editor with formatting toolbar
//

import SwiftUI
import SwiftData
import PhotosUI

struct NoteEditorView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Bindable var note: Note
    
    @Query private var allThemes: [Theme]
    
    @State private var showFormatting = false
    @State private var showThemePicker = false
    @State private var showBibleReference = false
    @State private var showInfo = false
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var newThemeName = ""
    
    @FocusState private var titleFocused: Bool
    @FocusState private var contentFocused: Bool
    
    @AppStorage("editorFontSize") private var fontSize: Double = 16
    
    private var themeSuggestions: [Theme] {
        let currentIDs: Set<UUID> = Set(note.themes.map { $0.id })
        return allThemes.filter { theme in
            !currentIDs.contains(theme.id)
        }
    }
    
    // Extracted small views to help the compiler
    @ViewBuilder
    private var referenceBadge: some View {
        if let ref = note.referenceString() {
            HStack {
                Label(ref, systemImage: "book.closed")
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.1))
                    .foregroundStyle(Color.blue)
                    .clipShape(Capsule())
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 4)
        }
    }

    @ViewBuilder
    private var themesChips: some View {
        if !note.themes.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(note.themes) { theme in
                        let chipColor: Color = Color(hex: theme.colorHex) ?? .blue
                        HStack(spacing: 4) {
                            Text(theme.name)
                                .font(.caption)
                            Button(action: {
                                if let index = note.themes.firstIndex(where: { $0.id == theme.id }) {
                                    note.themes.remove(at: index)
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.caption)
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(chipColor.opacity(0.1))
                        .foregroundStyle(chipColor)
                        .clipShape(Capsule())
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top, 4)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Title
            TextField("Title", text: $note.title, axis: .vertical)
                .font(.title2.bold())
                .focused($titleFocused)
                .padding(.horizontal)
                .padding(.top)
                .onChange(of: note.title) { _, _ in
                    note.updatedAt = .now
                }
            
            // Reference Badge
            referenceBadge
            
            // Themes
            themesChips
            
            Divider()
                .padding(.vertical, 8)
            
            // Content Editor
            TextEditor(text: $note.content)
                .font(.system(size: fontSize))
                .focused($contentFocused)
                .scrollContentBackground(.hidden)
                .onChange(of: note.content) { _, _ in
                    note.updatedAt = .now
                }
            
            // Formatting Toolbar
            if showFormatting {
                formattingToolbar
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Done") {
                    dismiss()
                }
                .fontWeight(.semibold)
            }
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                Menu {
                    menuContent
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                keyboardToolbar
            }
        }
        .sheet(isPresented: $showThemePicker) {
            themePickerSheet
        }
        .sheet(isPresented: $showBibleReference) {
            bibleReferenceSheet
        }
        .sheet(isPresented: $showInfo) {
            noteInfoSheet
        }
        .onChange(of: selectedPhotos) { _, newItems in
            Task {
                await loadPhotos(newItems)
            }
        }
        .onAppear {
            if note.title.isEmpty && note.content.isEmpty {
                titleFocused = true
            }
        }
    }
    
    // MARK: - Formatting Toolbar
    
    private var formattingToolbar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                Button(action: { insertText("**", "**") }) {
                    Image(systemName: "bold")
                }
                
                Button(action: { insertText("*", "*") }) {
                    Image(systemName: "italic")
                }
                
                Button(action: { insertText("~~", "~~") }) {
                    Image(systemName: "strikethrough")
                }
                
                Divider()
                    .frame(height: 20)
                
                Button(action: { insertText("# ", "") }) {
                    Text("H1")
                        .fontWeight(.bold)
                }
                
                Button(action: { insertText("## ", "") }) {
                    Text("H2")
                        .fontWeight(.semibold)
                }
                
                Button(action: { insertText("### ", "") }) {
                    Text("H3")
                }
                
                Divider()
                    .frame(height: 20)
                
                Group {
                    Button(action: { insertText("• ", "") }) {
                        Image(systemName: "list.bullet")
                    }
                    
                    Button(action: { insertText("1. ", "") }) {
                        Image(systemName: "list.number")
                    }
                    
                    Button(action: { insertText("- [ ] ", "") }) {
                        Image(systemName: "checklist")
                    }
                }
                
                Divider()
                    .frame(height: 20)
                
                Group {
                    Button(action: { insertText("> ", "") }) {
                        Image(systemName: "quote.opening")
                    }
                    
                    Button(action: { insertText("`", "`") }) {
                        Image(systemName: "chevron.left.forwardslash.chevron.right")
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(Material.ultraThin)
    }
    
    // MARK: - Keyboard Toolbar
    
    private var keyboardToolbar: some View {
        HStack {
            Button(action: { showFormatting.toggle() }) {
                Image(systemName: showFormatting ? "textformat.size.smaller" : "textformat.size")
            }
            
            Spacer()
            
            Button(action: { fontSize = max(12, fontSize - 2) }) {
                Image(systemName: "minus.magnifyingglass")
            }
            
            Button(action: { fontSize = min(24, fontSize + 2) }) {
                Image(systemName: "plus.magnifyingglass")
            }
            
            Spacer()
            
            Button("Done") {
                titleFocused = false
                contentFocused = false
            }
            .fontWeight(.semibold)
        }
    }
    
    // MARK: - Menu Content
    
    @ViewBuilder
    private var menuContent: some View {
        Section {
            Button(action: { togglePin() }) {
                Label(note.isPinned ? "Unpin" : "Pin", systemImage: "pin")
            }
            
            Button(action: { toggleFavorite() }) {
                Label(note.isFavorite ? "Remove from Favorites" : "Add to Favorites", systemImage: "heart")
            }
        }
        
        Section {
            Button(action: { showThemePicker = true }) {
                Label("Add Theme", systemImage: "tag")
            }
            
            Button(action: { showBibleReference = true }) {
                Label("Add Bible Reference", systemImage: "book.closed")
            }
            
            PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 5, matching: .images) {
                Label("Add Photo", systemImage: "photo")
            }
        }
        
        Section {
            Button(action: { showInfo = true }) {
                Label("Note Info", systemImage: "info.circle")
            }
            
            ShareLink(item: exportNote()) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
            
            Button(action: { duplicateNote() }) {
                Label("Duplicate", systemImage: "doc.on.doc")
            }
        }
        
        Section {
            Button(role: .destructive, action: { deleteNote() }) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    // MARK: - Theme Picker Sheet
    
    private var themePickerSheet: some View {
        NavigationStack {
            List {
                Section("NEW THEME") {
                    HStack {
                        TextField("Theme name", text: $newThemeName)
                            .textInputAutocapitalization(.words)
                            .submitLabel(.done)
                            .onSubmit {
                                addNewTheme()
                            }
                        
                        if !newThemeName.isEmpty {
                            Button(action: addNewTheme) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                }
                
                if !themeSuggestions.isEmpty {
                    Section("EXISTING THEMES") {
                        ForEach(themeSuggestions, id: \.id) { theme in
                            Button(action: {
                                note.themes.append(theme)
                                showThemePicker = false
                            }) {
                                let color: Color = Color(hex: theme.colorHex) ?? .blue
                                HStack {
                                    Image(systemName: "tag.fill")
                                        .foregroundStyle(color)
                                    Text(theme.name)
                                        .foregroundStyle(.primary)
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Theme")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showThemePicker = false
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
    
    // MARK: - Bible Reference Sheet
    
    private var bibleReferenceSheet: some View {
        NavigationStack {
            Form {
                Section("BOOK") {
                    Picker("Book", selection: Binding(
                        get: { note.book ?? "" },
                        set: { note.book = $0.isEmpty ? nil : $0 }
                    )) {
                        Text("Select book").tag("")
                        Group {
                            Text("Old Testament").font(.caption).foregroundStyle(.secondary).tag("")
                            ForEach(BibleBookList.oldTestament, id: \.self) { book in
                                Text(book).tag(book)
                            }
                        }
                        Group {
                            Text("New Testament").font(.caption).foregroundStyle(.secondary).tag("")
                            ForEach(BibleBookList.newTestament, id: \.self) { book in
                                Text(book).tag(book)
                            }
                        }
                    }
                }
                
                if note.book != nil {
                    Section("CHAPTER") {
                        HStack {
                            Text("Chapter")
                            Spacer()
                            TextField("Optional", value: $note.chapter, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 100)
                        }
                    }
                    
                    if note.chapter != nil {
                        Section("VERSE") {
                            HStack {
                                Text("Verse")
                                Spacer()
                                TextField("Optional", value: $note.verse, format: .number)
                                    .keyboardType(.numberPad)
                                    .multilineTextAlignment(.trailing)
                                    .frame(width: 100)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Bible Reference")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        showBibleReference = false
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
    
    // MARK: - Note Info Sheet
    
    private var noteInfoSheet: some View {
        NavigationStack {
            List {
                Section("DETAILS") {
                    HStack {
                        Text("Created")
                        Spacer()
                        Text(note.createdAt, style: .date)
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Modified")
                        Spacer()
                        Text(note.updatedAt, style: .date)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Section("STATISTICS") {
                    HStack {
                        Text("Words")
                        Spacer()
                        Text("\(note.wordCount)")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Characters")
                        Spacer()
                        Text("\(note.characterCount)")
                            .foregroundStyle(.secondary)
                    }
                }
                
                if let ref = note.referenceString() {
                    Section("REFERENCE") {
                        Text(ref)
                    }
                }
                
                if !note.themes.isEmpty {
                    Section("THEMES") {
                        ForEach(note.themes) { theme in
                            let color: Color = Color(hex: theme.colorHex) ?? .blue
                            HStack {
                                Image(systemName: "tag.fill")
                                    .foregroundStyle(color)
                                Text(theme.name)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Note Info")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        showInfo = false
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
    
    // MARK: - Actions
    
    private func togglePin() {
        note.isPinned.toggle()
        Haptics.light()
    }
    
    private func toggleFavorite() {
        note.isFavorite.toggle()
        Haptics.light()
    }
    
    private func addNewTheme() {
        let trimmed = newThemeName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        if let existing = allThemes.first(where: { 
            $0.name.localizedCaseInsensitiveCompare(trimmed) == .orderedSame 
        }) {
            if !note.themes.contains(where: { $0.id == existing.id }) {
                note.themes.append(existing)
            }
        } else {
            let newTheme = Theme(name: trimmed)
            context.insert(newTheme)
            note.themes.append(newTheme)
        }
        
        newThemeName = ""
        showThemePicker = false
        Haptics.success()
    }
    
    private func insertText(_ prefix: String, _ suffix: String) {
        note.content += prefix + suffix
        Haptics.light()
    }
    
    private func deleteNote() {
        note.isDeleted = true
        note.deletedAt = .now
        Haptics.warning()
        dismiss()
    }
    
    private func duplicateNote() {
        let duplicate = Note(
            title: note.title + " (Copy)",
            content: note.content,
            book: note.book,
            chapter: note.chapter,
            verse: note.verse
        )
        context.insert(duplicate)
        Haptics.success()
    }
    
    private func exportNote() -> String {
        var text = note.title + "\n\n"
        if let ref = note.referenceString() {
            text += ref + "\n\n"
        }
        text += note.content
        return text
    }
    
    private func loadPhotos(_ items: [PhotosPickerItem]) async {
        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self) {
                let attachment = Attachment(
                    filename: "photo_\(UUID().uuidString).jpg",
                    data: data,
                    mimeType: "image/jpeg"
                )
                note.attachments.append(attachment)
            }
        }
        selectedPhotos = []
    }
}

#Preview {
    @Previewable @State var note = Note(title: "Sample Note", content: "This is a sample note.")
    
    return NavigationStack {
        NoteEditorView(note: note)
    }
    .modelContainer(for: [Note.self, Theme.self, Attachment.self], inMemory: true)
}

