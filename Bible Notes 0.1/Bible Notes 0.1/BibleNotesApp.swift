//
//  BibleNotesApp.swift
//  Bible Notes
//
//  Main app entry point with SwiftData and CloudKit configuration
//

import SwiftUI
import SwiftData

@main
struct BibleNotesApp: App {
    let container: ModelContainer
    
    init() {
        do {
            let schema = Schema([Note.self, Theme.self, Attachment.self])
            let config = ModelConfiguration(
                schema: schema,
                cloudKitDatabase: .automatic
            )
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            // Fallback to local-only storage
            let schema = Schema([Note.self, Theme.self, Attachment.self])
            do {
                container = try ModelContainer(for: schema)
            } catch {
                // Final fallback to in-memory storage
                let config = ModelConfiguration(isStoredInMemoryOnly: true)
                container = try! ModelContainer(for: schema, configurations: [config])
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
