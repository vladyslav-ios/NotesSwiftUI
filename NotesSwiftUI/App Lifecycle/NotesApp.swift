//
//  NotesSwiftUIApp.swift
//  NotesSwiftUI
//
//  Created by Влад Лялькін on 12.12.2023.
//

import SwiftUI
import SwiftData

@main
struct NotesApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Note.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            NotesView(modelContext: sharedModelContainer.mainContext)
        }
        .modelContainer(sharedModelContainer)
    }
    
    init() {
        print(sharedModelContainer.configurations.first?.url.absoluteString ?? "")
    }
}
