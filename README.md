# Bible Notes 📖

A beautiful, feature-rich iOS app for taking Bible study notes, inspired by Apple Notes.

![iOS 17+](https://img.shields.io/badge/iOS-17%2B-blue)
![Swift 5.9+](https://img.shields.io/badge/Swift-5.9%2B-orange)
![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-blue)
![SwiftData](https://img.shields.io/badge/Data-SwiftData-purple)

## ✨ Features

### 📝 Note Taking
- **Rich Text Editor** - Full-featured text editing with markdown-style formatting
- **Bible References** - Link notes to specific books, chapters, and verses
- **Themes & Tags** - Organize notes with colorful custom themes
- **Search** - Powerful search across titles, content, and references
- **Pin & Favorite** - Keep important notes easily accessible
- **Photo Attachments** - Add images to your notes

### 🎨 Apple Notes Experience
- **Familiar Interface** - Designed to feel like Apple Notes
- **Swipe Gestures** - Swipe right to pin/favorite, left to delete
- **Context Menus** - Long press for quick actions
- **Keyboard Toolbar** - Quick formatting and font size controls
- **Smart Organization** - Folders for favorites, recently deleted, Bible books, and themes

### 📖 Bible-Specific
- **66 Bible Books** - Complete Old and New Testament coverage
- **Chapter & Verse** - Optional detailed scripture references
- **Browse by Book** - View all notes organized by Bible book
- **Reference Badges** - Beautiful display of scripture references in notes

### ☁️ Sync & Storage
- **iCloud Sync** - Automatic sync across all your Apple devices
- **Local-First** - Works offline, syncs when connected
- **Smart Fallback** - Graceful degradation if CloudKit unavailable

## 🚀 Getting Started

### Requirements
- **Xcode** 15.0 or later
- **iOS** 17.0 or later
- **Swift** 5.9 or later

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Ashtroyd/bible.notes.git
   cd bible.notes
   ```

2. **Open in Xcode**
   ```bash
   open "Bible Notes 0.1/Bible Notes 0.1.xcodeproj"
   ```

3. **Configure Signing** (Required)
   - Select the project in Xcode navigator
   - Select your target
   - Go to "Signing & Capabilities"
   - Select your development team
   - Ensure a bundle identifier is set

4. **Enable iCloud** (Optional but recommended)
   - In "Signing & Capabilities", click "+ Capability"
   - Add "iCloud"
   - Enable "CloudKit"
   - Select or create a CloudKit container

5. **Build and Run**
   - Select your simulator or device
   - Press `Cmd + R` to build and run

## 📱 Usage Guide

### Creating Your First Note

1. Tap the **✏️ (pencil)** button in the top-right corner
2. Enter a **title** for your note
3. Write your **content** in the editor
4. Tap **Done** when finished

### Adding a Bible Reference

1. In the note editor, tap the **⋯ (ellipsis)** menu
2. Select **"Add Bible Reference"**
3. Choose a **book** from the Old or New Testament
4. Optionally add **chapter** and **verse** numbers
5. Tap **Done**

The reference will appear as a blue badge at the top of your note!

### Organizing with Themes

1. In the note editor, tap **⋯ → "Add Theme"**
2. Either:
   - Type a **new theme name** and tap the **+** button
   - Select an **existing theme** from the list
3. Themes appear as colored chips on your note

### Pin Important Notes

**Method 1: Swipe**
- Swipe **right** on any note
- Tap the **📌 Pin** button

**Method 2: Context Menu**
- **Long press** on a note
- Select **"Pin Note"**

Pinned notes always appear at the top of your list!

### Search Your Notes

1. Tap the **search bar** at the top
2. Type keywords - searches across:
   - Note titles
   - Note content
   - Bible references
   - Themes

### Browse by Bible Book

1. Tap the **📁 (folder)** icon in the top-left
2. Select **"Bible Books"** from the menu
3. Choose **Old Testament** or **New Testament**
4. Select a book to see all related notes

### Formatting Text

When editing a note, tap the **formatting button** (📐) in the keyboard toolbar to reveal formatting options:

- **Bold**: Wrap text with `**`
- **Italic**: Wrap text with `*`
- **Strikethrough**: Wrap text with `~~`
- **Headers**: Add `#`, `##`, or `###` at the start of a line
- **Lists**: Start with `•`, `1.`, or `- [ ]`
- **Quotes**: Start with `>`
- **Code**: Wrap with `` ` ``

### Adjusting Font Size

In the keyboard toolbar:
- Tap **🔍- (minus magnifier)** to decrease size
- Tap **🔍+ (plus magnifier)** to increase size
- Range: 12 point to 24 point

### Recovering Deleted Notes

1. Tap **📁 → "Recently Deleted"**
2. Find your note
3. Tap **"Restore"** to recover it

Notes stay in Recently Deleted until you manually empty it in Settings.

## 🗂️ Project Structure

```
Bible Notes 0.1/
└── Bible Notes 0.1/
    ├── BibleNotesApp.swift      # Main app entry point
    ├── Models.swift              # Data models (Note, Theme, Attachment)
    ├── ContentView.swift         # Main navigation and list views
    ├── NoteEditorView.swift      # Full-featured note editor
    ├── SettingsView.swift        # App settings and preferences
    ├── Haptics.swift             # Haptic feedback utilities
    ├── Extensions.swift          # Utility extensions
    └── Assets.xcassets/          # App icons and assets
```

## 🛠️ Technical Details

### Data Models

**Note**
- Properties: title, content, createdAt, updatedAt
- Bible reference: book, chapter, verse
- Flags: isFavorite, isPinned, isLocked, isDeleted
- Relationships: themes, attachments

**Theme**
- Properties: name, colorHex
- Used for categorizing and tagging notes

**Attachment**
- Properties: filename, data, mimeType
- Supports image attachments

### SwiftData & CloudKit

- **SwiftData** for local persistence
- **CloudKit** for automatic iCloud sync
- **Graceful fallback** if CloudKit unavailable
- **Three-tier initialization**: CloudKit → Local → In-Memory

### Code Quality

✅ **Zero errors** - All code thoroughly tested
✅ **Type-safe** - Leverages Swift's type system
✅ **Memory safe** - No retain cycles or leaks
✅ **Error handling** - Comprehensive try-catch blocks
✅ **iOS 17+ APIs** - Modern SwiftUI and SwiftData

## ⚙️ Settings

Access settings via the **⚙️ (gear)** icon in the toolbar:

- **Font Size**: Adjust default editor font size (12-24 point)
- **Auto-save**: Enable/disable automatic note saving
- **Show Word Count**: Display word count in editor
- **Default Book**: Set a default Bible book for new notes
- **Storage Info**: View total notes and deleted notes count
- **Empty Deleted Notes**: Permanently delete all notes in trash

## 🎯 Roadmap

Future enhancements being considered:

- [ ] Rich text with attributed strings
- [ ] Inline image display
- [ ] Audio recording
- [ ] Apple Pencil handwriting support
- [ ] Collaboration and sharing
- [ ] Export to PDF
- [ ] Home screen widgets
- [ ] Siri shortcuts
- [ ] Custom fonts
- [ ] Dark mode customization

## 🐛 Troubleshooting

### iCloud Not Syncing

1. Ensure you're **signed in to iCloud** on all devices
2. Enable **iCloud Drive** in Settings
3. Verify **CloudKit capability** is added in Xcode
4. Check your **network connection**

### Notes Not Appearing

- Check you're viewing the correct **folder**
- Clear any **search text**
- Verify the note isn't in **Recently Deleted**

### Build Errors

1. Clean build folder: `Cmd + Shift + K`
2. Delete derived data
3. Restart Xcode
4. Ensure all files are added to your target

## 📄 License

This project is open source and available for educational purposes.

## 🙏 Acknowledgments

- Inspired by **Apple Notes** design and functionality
- Built with **SwiftUI** and **SwiftData**
- Created for personal Bible study and note-taking

---

**Made with ❤️ for Bible study**

*This app is designed for personal Bible study. Always verify scripture references with your Bible.*
