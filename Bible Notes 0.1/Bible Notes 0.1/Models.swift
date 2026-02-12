//
//  Models.swift
//  Bible Notes
//
//  Data models for Bible Notes app
//

import Foundation
import SwiftUI
import SwiftData

// MARK: - Note Model

@Model
final class Note: Identifiable {
    var id: UUID
    var title: String
    var content: String
    var isFavorite: Bool
    var isPinned: Bool
    var isLocked: Bool
    var createdAt: Date
    var updatedAt: Date
    var book: String?
    var chapter: Int?
    var verse: Int?
    var isDeleted: Bool
    var deletedAt: Date?
    
    @Relationship(deleteRule: .cascade) var themes: [Theme]
    @Relationship(deleteRule: .cascade) var attachments: [Attachment]
    
    init(
        title: String,
        content: String,
        isFavorite: Bool = false,
        isPinned: Bool = false,
        isLocked: Bool = false,
        createdAt: Date = .now,
        updatedAt: Date = .now,
        book: String? = nil,
        chapter: Int? = nil,
        verse: Int? = nil,
        themes: [Theme] = [],
        attachments: [Attachment] = [],
        isDeleted: Bool = false,
        deletedAt: Date? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.isFavorite = isFavorite
        self.isPinned = isPinned
        self.isLocked = isLocked
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.book = book
        self.chapter = chapter
        self.verse = verse
        self.themes = themes
        self.attachments = attachments
        self.isDeleted = isDeleted
        self.deletedAt = deletedAt
    }
    
    func referenceString() -> String? {
        if let book {
            var ref = book
            if let chapter {
                ref += " \(chapter)"
                if let verse {
                    ref += ":\(verse)"
                }
            }
            return ref
        }
        return nil
    }
    
    var wordCount: Int {
        content.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .count
    }
    
    var characterCount: Int {
        content.count
    }
}

// MARK: - Theme Model

@Model
final class Theme: Identifiable, Hashable {
    var id: UUID
    var name: String
    var colorHex: String
    
    init(name: String, colorHex: String = "#007AFF") {
        self.id = UUID()
        self.name = name
        self.colorHex = colorHex
    }
    
    static func == (lhs: Theme, rhs: Theme) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Attachment Model

@Model
final class Attachment: Identifiable {
    var id: UUID
    var filename: String
    var data: Data
    var mimeType: String
    var createdAt: Date
    
    init(filename: String, data: Data, mimeType: String) {
        self.id = UUID()
        self.filename = filename
        self.data = data
        self.mimeType = mimeType
        self.createdAt = .now
    }
}

// MARK: - Bible Books Reference

enum BibleBookList {
    static let oldTestament: [String] = [
        "Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy",
        "Joshua", "Judges", "Ruth", "1 Samuel", "2 Samuel",
        "1 Kings", "2 Kings", "1 Chronicles", "2 Chronicles",
        "Ezra", "Nehemiah", "Esther", "Job", "Psalms", "Proverbs",
        "Ecclesiastes", "Song of Solomon", "Isaiah", "Jeremiah", "Lamentations",
        "Ezekiel", "Daniel", "Hosea", "Joel", "Amos", "Obadiah", "Jonah", "Micah",
        "Nahum", "Habakkuk", "Zephaniah", "Haggai", "Zechariah", "Malachi"
    ]
    
    static let newTestament: [String] = [
        "Matthew", "Mark", "Luke", "John", "Acts", "Romans", "1 Corinthians",
        "2 Corinthians", "Galatians", "Ephesians", "Philippians", "Colossians",
        "1 Thessalonians", "2 Thessalonians", "1 Timothy", "2 Timothy", "Titus",
        "Philemon", "Hebrews", "James", "1 Peter", "2 Peter", "1 John", "2 John",
        "3 John", "Jude", "Revelation"
    ]
    
    static let ordered: [String] = oldTestament + newTestament
}

// MARK: - Formatting Options

enum TextStyle: String, CaseIterable {
    case title = "Title"
    case heading = "Heading"
    case body = "Body"
    case monospaced = "Monospaced"
    
    var font: Font {
        switch self {
        case .title: return .title
        case .heading: return .headline
        case .body: return .body
        case .monospaced: return .system(.body, design: .monospaced)
        }
    }
}

enum ListStyle: String, CaseIterable {
    case bullet = "• Bullet"
    case numbered = "1. Numbered"
    case checked = "☑ Checklist"
    case dashed = "- Dashed"
}
