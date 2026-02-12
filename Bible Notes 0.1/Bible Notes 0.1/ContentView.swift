//
//  ContentView.swift
//  Bible Notes
//
//  Main navigation and home screen
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Note.updatedAt, order: .reverse) private var allNotes: [Note]
    @Query private var allThemes: [Theme]
    
    @State private var searchText = ""
    @State private var showNewNote = false
    @State private var showSettings = false
    
    private var activeNotes: [Note] {
        allNotes.filter { !$0.isDeleted }
    }
    
    private var filteredNotes: [Note] {
        if searchText.isEmpty {
            return activeNotes
        }
        
        return activeNotes.filter { note in
            let searchable = "\(note.title) \(note.content) \(note.referenceString() ?? "")"
            return searchable.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private var pinnedNotes: [Note] {
        filteredNotes.filter { $0.isPinned }
    }
    
    private var unpinnedNotes: [Note] {
        filteredNotes.filter { !$0.isPinned }
    }
    
    var body: some View {
        NavigationStack {
            mainList
                .navigationTitle("Bible Notes")
                .searchable(text: $searchText, prompt: "Search notes")
                .toolbar {
                    toolbarContent
                }
                .sheet(isPresented: $showNewNote) {
                    newNoteSheet
                }
                .sheet(isPresented: $showSettings) {
                    SettingsView()
                }
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Menu {
                Label("Folders", systemImage: "folder")
                    .font(.headline)
                
                Divider()
                
                Button(action: {}) {
                    Label("All Notes (\(activeNotes.count))", systemImage: "folder")
                }
                
                NavigationLink(destination: FavoritesView()) {
                    Label("Favorites", systemImage: "heart")
                }
                
                NavigationLink(destination: RecentlyDeletedView()) {
                    Label("Recently Deleted", systemImage: "trash")
                }
            } label: {
                Image(systemName: "folder")
            }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: { showNewNote = true }) {
                Image(systemName: "square.and.pencil")
            }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: { showSettings = true }) {
                Image(systemName: "gear")
            }
        }
    }
    
    // MARK: - Main List
    
    private var mainList: some View {
        List {
            // Quick Actions
            quickActionsSection
            
            // Pinned Notes
            if !pinnedNotes.isEmpty {
                Section("PINNED") {
                    ForEach(pinnedNotes) { note in
                        noteRow(note)
                    }
                }
            }
            
            // All Notes
            Section("NOTES") {
                ForEach(unpinnedNotes) { note in
                    noteRow(note)
                }
            }
            
            // Browse by Category
            browseCategoriesSection
        }
        .listStyle(.insetGrouped)
    }
    
    private var quickActionsSection: some View {
        Section {
            NavigationLink(destination: FavoritesView()) {
                Label("Favorites", systemImage: "heart")
                    .badge(allNotes.filter { $0.isFavorite && !$0.isDeleted }.count)
            }
            
            NavigationLink(destination: ThemeListView()) {
                Label("Themes", systemImage: "tag")
                    .badge(allThemes.count)
            }
            
            NavigationLink(destination: RecentlyDeletedView()) {
                Label("Recently Deleted", systemImage: "trash")
                    .badge(allNotes.filter { $0.isDeleted }.count)
            }
        }
    }
    
    private var browseCategoriesSection: some View {
        Section("BROWSE") {
            NavigationLink(destination: BibleBooksListView()) {
                Label("Bible Books", systemImage: "book.closed")
            }
            
            if !allThemes.isEmpty {
                NavigationLink(destination: ThemeListView()) {
                    Label("All Themes", systemImage: "tag")
                }
            }
        }
    }
    
    @ViewBuilder
    private func noteRow(_ note: Note) -> some View {
        NavigationLink(destination: NoteEditorView(note: note)) {
            noteRowContent(note)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            trailingSwipeActions(note)
        }
        .swipeActions(edge: .leading) {
            leadingSwipeActions(note)
        }
        .contextMenu {
            noteContextMenu(note)
        }
    }
    
    @ViewBuilder
    private func noteRowContent(_ note: Note) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(note.title.isEmpty ? "New Note" : note.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Spacer()
                
                if note.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.pink)
                        .font(.caption)
                }
            }
            
            HStack {
                Text(note.updatedAt, style: .relative)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                if let ref = note.referenceString() {
                    Text("·")
                        .foregroundStyle(.secondary)
                    Text(ref)
                        .font(.caption)
                        .foregroundStyle(.blue)
                }
            }
            
            if !note.content.isEmpty {
                Text(note.content)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
    
    @ViewBuilder
    private func trailingSwipeActions(_ note: Note) -> some View {
        Button(role: .destructive) {
            deleteNote(note)
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
    
    @ViewBuilder
    private func leadingSwipeActions(_ note: Note) -> some View {
        Button {
            togglePin(note)
        } label: {
            Label(note.isPinned ? "Unpin" : "Pin", systemImage: "pin")
        }
        .tint(.orange)
        
        Button {
            toggleFavorite(note)
        } label: {
            Label(note.isFavorite ? "Unfavorite" : "Favorite", systemImage: "heart")
        }
        .tint(.pink)
    }
    
    @ViewBuilder
    private func noteContextMenu(_ note: Note) -> some View {
        Button(action: { togglePin(note) }) {
            Label(note.isPinned ? "Unpin Note" : "Pin Note", systemImage: "pin")
        }
        
        Button(action: { toggleFavorite(note) }) {
            Label(note.isFavorite ? "Remove from Favorites" : "Add to Favorites", systemImage: "heart")
        }
        
        Divider()
        
        ShareLink(item: exportNote(note)) {
            Label("Share", systemImage: "square.and.arrow.up")
        }
        
        Button(action: { duplicateNote(note) }) {
            Label("Duplicate", systemImage: "doc.on.doc")
        }
        
        Divider()
        
        Button(role: .destructive, action: { deleteNote(note) }) {
            Label("Delete", systemImage: "trash")
        }
    }
    
    // MARK: - New Note Sheet
    
    private var newNoteSheet: some View {
        let newNote = Note(title: "", content: "")
        
        return NavigationStack {
            NoteEditorView(note: newNote)
        }
        .onAppear {
            context.insert(newNote)
        }
        .onDisappear {
            if newNote.title.isEmpty && newNote.content.isEmpty {
                context.delete(newNote)
            }
        }
    }
    
    // MARK: - Actions
    
    private func togglePin(_ note: Note) {
        note.isPinned.toggle()
        note.updatedAt = .now
        Haptics.light()
    }
    
    private func toggleFavorite(_ note: Note) {
        note.isFavorite.toggle()
        note.updatedAt = .now
        Haptics.light()
    }
    
    private func deleteNote(_ note: Note) {
        note.isDeleted = true
        note.deletedAt = .now
        Haptics.warning()
    }
    
    private func restoreNote(_ note: Note) {
        note.isDeleted = false
        note.deletedAt = nil
        note.updatedAt = .now
        Haptics.success()
    }
    
    private func permanentlyDelete(_ note: Note) {
        context.delete(note)
        Haptics.warning()
    }
    
    private func duplicateNote(_ note: Note) {
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
    
    private func exportNote(_ note: Note) -> String {
        var text = note.title + "\n\n"
        if let ref = note.referenceString() {
            text += ref + "\n\n"
        }
        text += note.content
        return text
    }
}

// MARK: - Supporting Views

struct FavoritesView: View {
    @Query private var allNotes: [Note]
    
    private var favoriteNotes: [Note] {
        allNotes.filter { $0.isFavorite && !$0.isDeleted }
            .sorted { $0.updatedAt > $1.updatedAt }
    }
    
    var body: some View {
        List {
            if favoriteNotes.isEmpty {
                ContentUnavailableView(
                    "No Favorites",
                    systemImage: "heart",
                    description: Text("Notes you favorite will appear here")
                )
            } else {
                ForEach(favoriteNotes) { note in
                    NavigationLink(destination: NoteEditorView(note: note)) {
                        NoteRowView(note: note)
                    }
                }
            }
        }
        .navigationTitle("Favorites")
    }
}

struct RecentlyDeletedView: View {
    @Environment(\.modelContext) private var context
    @Query private var allNotes: [Note]
    
    private var deletedNotes: [Note] {
        allNotes.filter { $0.isDeleted }
            .sorted { ($0.deletedAt ?? .distantPast) > ($1.deletedAt ?? .distantPast) }
    }
    
    var body: some View {
        List {
            if deletedNotes.isEmpty {
                ContentUnavailableView(
                    "No Deleted Notes",
                    systemImage: "trash",
                    description: Text("Notes you delete will appear here for 30 days")
                )
            } else {
                ForEach(deletedNotes) { note in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(note.title.isEmpty ? "New Note" : note.title)
                                .font(.headline)
                            if let deletedAt = note.deletedAt {
                                Text("Deleted \(deletedAt, style: .relative)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        Button("Restore") {
                            note.isDeleted = false
                            note.deletedAt = nil
                            Haptics.success()
                        }
                        .buttonStyle(.bordered)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            context.delete(note)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
        }
        .navigationTitle("Recently Deleted")
    }
}

struct ThemeListView: View {
    @Query private var allThemes: [Theme]
    
    var body: some View {
        List {
            ForEach(allThemes) { theme in
                NavigationLink(destination: NotesByThemeView(themeName: theme.name)) {
                    HStack {
                        Image(systemName: "tag.fill")
                            .foregroundStyle(Color(hex: theme.colorHex) ?? .blue)
                        Text(theme.name)
                    }
                }
            }
        }
        .navigationTitle("Themes")
    }
}

struct BibleBooksListView: View {
    var body: some View {
        List {
            Section("OLD TESTAMENT") {
                ForEach(BibleBookList.oldTestament, id: \.self) { book in
                    NavigationLink(destination: NotesByBookView(book: book)) {
                        Text(book)
                    }
                }
            }
            
            Section("NEW TESTAMENT") {
                ForEach(BibleBookList.newTestament, id: \.self) { book in
                    NavigationLink(destination: NotesByBookView(book: book)) {
                        Text(book)
                    }
                }
            }
        }
        .navigationTitle("Bible Books")
    }
}

struct NoteRowView: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(note.title.isEmpty ? "New Note" : note.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Spacer()
                
                if note.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.pink)
                        .font(.caption)
                }
            }
            
            HStack {
                Text(note.updatedAt, style: .relative)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                if let ref = note.referenceString() {
                    Text("·")
                        .foregroundStyle(.secondary)
                    Text(ref)
                        .font(.caption)
                        .foregroundStyle(.blue)
                }
            }
            
            if !note.content.isEmpty {
                Text(note.content)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
}

struct NotesByBookView: View {
    let book: String
    @Query private var notes: [Note]
    
    init(book: String) {
        self.book = book
        _notes = Query(filter: #Predicate<Note> { 
            $0.book == book && !$0.isDeleted 
        }, sort: \Note.updatedAt, order: .reverse)
    }
    
    var body: some View {
        List {
            if notes.isEmpty {
                ContentUnavailableView(
                    "No Notes",
                    systemImage: "book.closed",
                    description: Text("Create a note for \(book)")
                )
            } else {
                ForEach(notes) { note in
                    NavigationLink(destination: NoteEditorView(note: note)) {
                        NoteRowView(note: note)
                    }
                }
            }
        }
        .navigationTitle(book)
    }
}

struct NotesByThemeView: View {
    let themeName: String
    @Query private var notes: [Note]
    
    init(themeName: String) {
        self.themeName = themeName
        _notes = Query(filter: #Predicate<Note> { note in
            note.themes.contains(where: { $0.name == themeName }) && !note.isDeleted
        }, sort: \Note.updatedAt, order: .reverse)
    }
    
    var body: some View {
        List {
            if notes.isEmpty {
                ContentUnavailableView(
                    "No Notes",
                    systemImage: "tag",
                    description: Text("No notes with theme \"\(themeName)\"")
                )
            } else {
                ForEach(notes) { note in
                    NavigationLink(destination: NoteEditorView(note: note)) {
                        NoteRowView(note: note)
                    }
                }
            }
        }
        .navigationTitle(themeName)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Note.self, Theme.self, Attachment.self], inMemory: true)
}
