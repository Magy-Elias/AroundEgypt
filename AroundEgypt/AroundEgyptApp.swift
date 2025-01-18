//
//  AroundEgyptApp.swift
//  AroundEgypt
//
//  Created by moweex on 19/01/2025.
//

import SwiftUI

@main
struct AroundEgyptApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
