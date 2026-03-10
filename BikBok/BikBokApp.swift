//
//  bikbokApp.swift
//  bikbok
//
//  Created by Omar Abu Sharar on 8/21/25.
//

import SwiftUI
import SwiftData

@main
struct BikBokApp: App {
    
    // Shared Model Container
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Book.self,
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
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
