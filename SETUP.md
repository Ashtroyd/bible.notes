# Bible Notes - Complete Setup Guide

This guide will walk you through setting up the Bible Notes app from scratch.

## Prerequisites

Before you begin, ensure you have:

- ✅ **macOS** 13.0 (Ventura) or later
- ✅ **Xcode** 15.0 or later installed
- ✅ **Apple Developer Account** (free tier is fine)
- ✅ **iOS Device or Simulator** running iOS 17.0+

## Step-by-Step Setup

### 1. Clone the Repository

Open Terminal and run:

```bash
git clone https://github.com/Ashtroyd/bible.notes.git
cd bible.notes
```

### 2. Open the Project

```bash
open "Bible Notes 0.1/Bible Notes 0.1.xcodeproj"
```

Xcode should launch and open the project.

### 3. Configure Project Settings

#### a. Set Your Development Team

1. In Xcode, select the **Bible Notes 0.1** project in the navigator (left sidebar)
2. Select the **Bible Notes 0.1** target
3. Go to the **"Signing & Capabilities"** tab
4. Under **"Signing"**, select your **Team** from the dropdown
   - If you don't see your team, you may need to add your Apple ID:
     - Xcode → Settings → Accounts → "+" → Sign in with Apple ID

#### b. Update Bundle Identifier (if needed)

If you get signing errors, you may need a unique bundle identifier:

1. In **"Signing & Capabilities"** tab
2. Change **Bundle Identifier** to something unique, like:
   ```
   com.yourname.biblenotes
   ```

### 4. Enable iCloud Sync (Optional but Recommended)

If you want notes to sync across devices:

1. In **"Signing & Capabilities"** tab
2. Click **"+ Capability"** button
3. Search for and add **"iCloud"**
4. Check the **"CloudKit"** checkbox
5. Click **"+"** under CloudKit Containers to create a new container, or select an existing one

**Note**: Free Apple Developer accounts can use iCloud/CloudKit!

### 5. Build the Project

1. Select a destination:
   - **Simulator**: Choose any iPhone simulator (iPhone 15 Pro recommended)
   - **Physical Device**: Connect your iPhone/iPad and select it
2. Press **Cmd + B** to build
3. Wait for the build to complete (first build may take a minute)

### 6. Run the App

1. Press **Cmd + R** (or click the Play ▶️ button)
2. The app should launch on your selected device/simulator
3. First launch will create the local database

## Verification Checklist

After the app launches, verify these features work:

- [ ] ✅ Create a new note (tap pencil icon)
- [ ] ✅ Edit note title and content
- [ ] ✅ Add a Bible reference (tap ⋯ → Add Bible Reference)
- [ ] ✅ Add a theme/tag (tap ⋯ → Add Theme)
- [ ] ✅ Pin a note (swipe right on note)
- [ ] ✅ Favorite a note (swipe right → heart icon)
- [ ] ✅ Search for notes (use search bar)
- [ ] ✅ Delete a note (swipe left)
- [ ] ✅ Restore from Recently Deleted
- [ ] ✅ Browse Bible books (tap folder icon)
- [ ] ✅ Adjust font size (keyboard toolbar)
- [ ] ✅ Access Settings (gear icon)

## Testing iCloud Sync

If you enabled iCloud:

1. **Create a note** on Device 1
2. **Wait 10-30 seconds** for sync
3. **Open the app** on Device 2 (signed into the same iCloud account)
4. The note should appear automatically

**Troubleshooting Sync:**
- Ensure both devices are signed into the **same iCloud account**
- Check that **iCloud Drive** is enabled in Settings
- Verify you have a working **internet connection**
- Try creating a note with distinctive content to confirm sync

## Common Issues & Solutions

### Issue: "Failed to create ModelContainer"

**Solution:**
- This is normal on first launch with CloudKit
- The app will automatically fall back to local storage
- Check your internet connection
- Verify iCloud is configured correctly

### Issue: Build fails with "No signing certificate"

**Solution:**
1. Go to Xcode → Settings → Accounts
2. Sign in with your Apple ID
3. Click "Download Manual Profiles"
4. Return to project settings and select your team

### Issue: "Untrusted Developer" on physical device

**Solution:**
1. On your iOS device, go to **Settings → General → VPN & Device Management**
2. Find your developer profile
3. Tap **"Trust [Your Name]"**
4. Confirm trust

### Issue: App crashes immediately on launch

**Solution:**
1. Clean build: **Cmd + Shift + K**
2. Delete derived data:
   - Xcode → Settings → Locations → Derived Data → Click arrow → Delete folder
3. Restart Xcode
4. Rebuild: **Cmd + B**

### Issue: Notes not appearing

**Solution:**
- Check you're in the "All Notes" view (not a filter)
- Clear any search text
- Verify the note wasn't deleted (check Recently Deleted)
- Try restarting the app

## Building for Release (App Store)

If you want to distribute the app:

1. **Change scheme to Release**:
   - Product → Scheme → Edit Scheme
   - Change "Build Configuration" to "Release"

2. **Archive the app**:
   - Product → Archive
   - Wait for archive to complete

3. **Submit to App Store**:
   - Follow Apple's App Store submission guidelines
   - Add app icons, screenshots, and description
   - Submit for review

**Note**: You'll need a **paid Apple Developer Program membership** ($99/year) to publish to the App Store.

## Customization

### Changing App Icon

1. Prepare icons in required sizes (see Apple's guidelines)
2. Drag icons into **Assets.xcassets → AppIcon**
3. Rebuild

### Modifying Colors

Edit theme colors in `Models.swift`:

```swift
Theme(name: "Your Theme", colorHex: "#FF6B6B")
```

### Adding Custom Fonts

1. Add `.ttf` or `.otf` font files to the project
2. Update `Info.plist` with font filenames
3. Use in code: `.font(.custom("FontName", size: 16))`

## Performance Tips

- **Large databases**: The app handles thousands of notes efficiently
- **Photos**: Limit photo attachments to reasonable sizes
- **Search**: Search is optimized with SwiftData predicates
- **Sync**: Sync happens in the background; manual intervention not needed

## Development Environment

### Recommended Xcode Settings

- **Editor**: Enable "Show Line Numbers"
- **Behaviors**: Configure behaviors for build success/failure
- **Theme**: Use a comfortable color scheme
- **Font**: SF Mono or Menlo at 11-12pt

### Debugging

To enable verbose logging:

1. Edit scheme: Product → Scheme → Edit Scheme
2. Run → Arguments → Environment Variables
3. Add: `SWIFTDATA_LOGGING_LEVEL` = `debug`

## Next Steps

Now that you have the app running:

1. 📖 **Read the [README.md](README.md)** for feature documentation
2. 🎯 **Try all features** to understand the app
3. 💡 **Customize** the app for your needs
4. 🤝 **Contribute** improvements back to the project
5. ⭐ **Star the repo** if you find it useful!

## Support

If you encounter issues:

1. Check this setup guide thoroughly
2. Review the [Troubleshooting](#common-issues--solutions) section
3. Search existing GitHub Issues
4. Create a new Issue with:
   - Xcode version
   - iOS version
   - Detailed description of the problem
   - Steps to reproduce
   - Screenshots (if applicable)

## Resources

- [Apple SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Apple SwiftData Documentation](https://developer.apple.com/documentation/swiftdata)
- [Apple CloudKit Documentation](https://developer.apple.com/documentation/cloudkit)
- [Swift.org](https://swift.org)

---

**Happy Bible Studying! 📖✨**
