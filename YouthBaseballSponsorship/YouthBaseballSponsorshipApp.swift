//
//  YouthBaseballSponsorshipApp.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 3/6/25.
//

import SwiftUI


@main
struct YouthBaseballSponsorshipApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            WelcomeView() // ✅ Always starts on Welcome Screen
                .environment(\.managedObjectContext, persistenceController.context)
        }
    }
}
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }


