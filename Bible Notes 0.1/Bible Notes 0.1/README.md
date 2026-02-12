# Bible Notes

A beautiful, feature-rich iOS app for taking Bible study notes, inspired by Apple Notes.

## Features

### Core Functionality
- ✅ **Rich Note Editor** - Full-featured text editing with markdown support
- ✅ **Bible References** - Link notes to specific books, chapters, and verses
- ✅ **Themes & Tags** - Organize notes with custom themes/tags
- ✅ **Search** - Powerful search across all notes
- ✅ **Pin & Favorite** - Keep important notes easily accessible
- ✅ **Recently Deleted** - Recover accidentally deleted notes
- ✅ **iCloud Sync** - Automatic sync across all your devices
- ✅ **Share** - Export and share your notes

### Apple Notes Features Implemented
1. **Three-pane Navigation** (iPad/Mac)
   - Sidebar with folders and categories
   - List view of notes
   - Detail editor view

2. **Folders & Organization**
   - All Notes
   - Favorites
   - Recent
   - Recently Deleted
   - Bible Books (Old/New Testament)
   - Custom Themes

3. **Note Actions**
   - Pin to top
   - Add to favorites
   - Delete (soft delete to Recently Deleted)
   - Restore from trash
   - Duplicate
   - Share

4. **Swipe Gestures**
   - Swipe right: Pin, Favorite
   - Swipe left: Delete
   - Full swipe for quick actions

5. **Rich Text Formatting**
   - Bold, Italic, Strikethrough
   - Headers (H1, H2, H3)
   - Bullet lists, Numbered lists, Checklists
   - Block quotes
   - Code formatting
   - Adjustable font size

6. **Context Menus**
   - Long press for quick actions
   - Copy, share, delete options

7. **Keyboard Toolbar**
   - Quick formatting buttons
   - Font size controls
   - Done button to dismiss keyboard

8. **Note Info**
   - Creation date
   - Last modified date
   - Word count
   - Character count

9. **Search**
   - Real-time search across titles and content
   - Search in specific folders

10. **Settings**
    - Font size preferences
    - Auto-save toggle
    - Default book selection
    - Storage information
    - Empty trash

### Bible-Specific Features
- **Book Selection** - Choose from all 66 Bible books
- **Chapter & Verse** - Optional chapter and verse references
- **Old/New Testament** - Organized by testament
- **Theme Tags** - Create and assign themes to notes
- **Reference Display** - Beautiful badge showing scripture reference

## Project Structure

```
BibleNotes/
├── BibleNotesApp.swift       # Main app entry point
├── Models.swift              # Data models (Note, Theme, Attachment)
├── ContentView.swift         # Main navigation and list views
├── NoteEditorView.swift      # Full-featured note editor
├── SettingsView.swift        # App settings
├── Haptics.swift            # Haptic feedback utilities
└── Extensions.swift         # Utility extensions
```

## Data Models

### Note
- Title, content
- Created/updated timestamps
- Bible reference (book, chapter, verse)
- Favorite, pinned, locked flags
- Soft delete support
- Themes relationship
- Attachments relationship

### Theme
- Name
- Color (hex)

### Attachment
- Filename
- Data
- MIME type
- Created timestamp

## Setup Instructions

### Requirements
- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

### Installation

1. **Create a new Xcode project**
   - Open Xcode
   - File → New → Project
   - Choose "App" template
   - Name it "Bible Notes"
   - Select SwiftUI and Swift

2. **Add the files**
   - Replace the auto-generated files with the provided ones
   - Ensure all files are added to your target

3. **Configure CloudKit (Optional)**
   - Select your project in the navigator
   - Select your target
   - Go to "Signing & Capabilities"
   - Click "+ Capability"
   - Add "iCloud"
   - Enable "CloudKit"
   - Select your container

4. **Build and Run**
   - Select your simulator or device
   - Press Cmd+R to build and run

## Usage

### Creating a Note
1. Tap the "+" button in the toolbar
2. Enter a title
3. Write your content
4. Optionally add a Bible reference
5. Optionally add themes/tags

### Adding Bible Reference
1. In the editor, tap the "..." menu
2. Select "Add Bible Reference"
3. Choose book, chapter, and verse
4. Tap "Done"

### Organizing with Themes
1. In the editor, tap "..." → "Add Theme"
2. Type a new theme name or select existing
3. Themes appear as colored badges

### Search
- Use the search bar at the top
- Search works across titles, content, and references

### Pin & Favorite
- Swipe right on a note or use the context menu
- Pinned notes appear at the top
- Favorites have their own folder

### Delete & Restore
- Swipe left to delete
- Deleted notes move to "Recently Deleted"
- Swipe right in deleted folder to restore
- Empty all deleted notes in Settings

## Customization

### Changing Colors
Edit the color scheme in `Models.swift`:
```swift
Theme(name: "Your Theme", colorHex: "#FF6B6B")
```

### Adding More Features
The app is designed to be extensible:
- Add more attachment types in `Models.swift`
- Customize the editor toolbar in `NoteEditorView.swift`
- Add new folders in `ContentView.swift`

### Font Customization
Users can adjust font size in Settings or via keyboard toolbar (12pt - 24pt).

## iCloud Sync

The app automatically syncs via CloudKit when configured:
- Notes sync across all devices
- Themes are shared
- Attachments sync (with size limits)

## Future Enhancements

Potential features to add:
- [ ] Rich text editor with attributed strings
- [ ] Image attachments inline
- [ ] Audio recording
- [ ] Handwriting support (Apple Pencil)
- [ ] Collaboration/sharing
- [ ] Export to PDF
- [ ] Widgets
- [ ] Siri integration
- [ ] Dark mode customization
- [ ] Custom fonts

## Troubleshooting

### CloudKit Not Syncing
1. Ensure you're signed in to iCloud
2. Check iCloud Drive is enabled
3. Verify CloudKit capability is added
4. Check network connection

### Notes Not Appearing
- Check if you're in the correct folder
- Clear search text
- Ensure note isn't deleted

### Build Errors
- Clean build folder (Cmd+Shift+K)
- Delete derived data
- Restart Xcode
- Ensure all files are in target

## Credits

Inspired by Apple Notes app design and functionality.
Built with SwiftUI and SwiftData.

## License

This is a sample project for educational purposes.

---

**Note**: This app is designed for personal Bible study. Always verify scripture references with your Bible.
