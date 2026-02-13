# Contributing to Bible Notes

Thank you for your interest in contributing to Bible Notes! This document provides guidelines and instructions for contributing.

## Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help create a welcoming environment for all contributors
- Remember this is a project for Bible study and spiritual growth

## How to Contribute

### Reporting Bugs

If you find a bug:

1. **Check existing issues** to avoid duplicates
2. **Create a new issue** with:
   - Clear, descriptive title
   - Steps to reproduce the bug
   - Expected vs. actual behavior
   - Screenshots (if applicable)
   - Xcode version and iOS version
   - Device/simulator information

### Suggesting Features

For feature requests:

1. **Check existing issues** and discussions
2. **Create a new issue** with:
   - Clear description of the feature
   - Use case and benefits
   - Possible implementation approach
   - Any relevant mockups or examples

### Code Contributions

#### Before You Start

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/your-feature-name`
3. **Keep changes focused**: One feature/fix per pull request

#### Development Guidelines

**Code Style**
- Follow Swift naming conventions
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

**SwiftUI Best Practices**
- Extract views into smaller, reusable components
- Use `@ViewBuilder` for view composition
- Leverage property wrappers correctly (`@State`, `@Binding`, `@Environment`)
- Minimize view re-renders

**SwiftData Best Practices**
- Use proper model relationships
- Add appropriate delete rules
- Use predicates for efficient queries
- Handle migrations carefully

**Error Handling**
- Use `try-catch` for error-prone operations
- Avoid force unwraps (`!`) except in truly safe cases
- Provide graceful fallbacks
- Log errors appropriately

#### Testing Your Changes

1. **Build successfully**: `Cmd + B`
2. **Test on simulator** (multiple device sizes if UI changes)
3. **Test on physical device** (if possible)
4. **Verify iCloud sync** (if data model changes)
5. **Check for memory leaks** (use Instruments)
6. **Test edge cases**:
   - Empty states
   - Large datasets
   - Offline mode
   - iCloud unavailable

#### Commit Guidelines

Use clear, descriptive commit messages:

```
feat: Add Bible verse quick lookup feature
fix: Resolve crash when deleting pinned notes
docs: Update README with installation steps
refactor: Extract note row into separate view
style: Format code according to Swift style guide
test: Add unit tests for Bible reference parsing
```

Prefix types:
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `refactor:` - Code refactoring
- `style:` - Code style/formatting
- `test:` - Adding/updating tests
- `chore:` - Maintenance tasks

#### Pull Request Process

1. **Update documentation** if needed (README, code comments)
2. **Ensure all tests pass**
3. **Update CHANGELOG** (if applicable)
4. **Create pull request** with:
   - Clear title and description
   - Reference any related issues
   - Screenshots for UI changes
   - Testing notes

5. **Address review feedback** promptly and respectfully

## Development Setup

See [SETUP.md](SETUP.md) for detailed setup instructions.

Quick start:
```bash
git clone https://github.com/Ashtroyd/bible.notes.git
cd bible.notes
open "Bible Notes 0.1/Bible Notes 0.1.xcodeproj"
```

## Areas for Contribution

We welcome contributions in these areas:

### High Priority
- 🐛 **Bug fixes** - Always appreciated
- 📱 **iOS compatibility** - Ensure latest iOS support
- ♿ **Accessibility** - VoiceOver, Dynamic Type support
- 🌍 **Localization** - Translations for other languages
- 📚 **Documentation** - Improve guides and comments

### Medium Priority
- ✨ **New features** - Enhance functionality
- 🎨 **UI improvements** - Better design and UX
- ⚡ **Performance** - Optimization opportunities
- 🧪 **Testing** - Unit and UI tests

### Nice to Have
- 📊 **Analytics** (privacy-focused)
- 🔊 **Audio notes**
- ✍️ **Handwriting** (Apple Pencil)
- 🤝 **Collaboration** features
- 📄 **Export formats** (PDF, DOCX)

## Code Review Process

All contributions go through code review:

1. **Automated checks** run on PR creation
2. **Maintainer review** within a few days
3. **Feedback** may request changes
4. **Approval** and merge when ready

## Project Structure

```
Bible Notes 0.1/
└── Bible Notes 0.1/
    ├── BibleNotesApp.swift      # App entry point
    ├── Models.swift              # Data models
    ├── ContentView.swift         # Main UI
    ├── NoteEditorView.swift      # Note editor
    ├── SettingsView.swift        # Settings
    ├── Haptics.swift             # Haptics
    ├── Extensions.swift          # Extensions
    └── Assets.xcassets/          # Assets
```

## Useful Commands

```bash
# Build
xcodebuild -project "Bible Notes 0.1.xcodeproj" -scheme "Bible Notes 0.1"

# Clean
xcodebuild clean

# Test (when tests exist)
xcodebuild test -project "Bible Notes 0.1.xcodeproj" -scheme "Bible Notes 0.1"
```

## Resources

- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [SwiftData Documentation](https://developer.apple.com/documentation/swiftdata)
- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines)

## Questions?

- Open a **Discussion** for questions
- Create an **Issue** for bugs/features
- Be patient - maintainers are volunteers

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

Thank you for helping make Bible Notes better! 🙏
