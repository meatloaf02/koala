//
//  YouthBaseballSponsorshipApp.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 3/6/25.
//

import SwiftUI

@main
struct YouthBaseballSponsorshipApp: App {
    @AppStorage("hasSeenWelcomeScreen") private var hasSeenWelcomeScreen: Bool = false

    var body: some Scene {
        WindowGroup {
            if hasSeenWelcomeScreen {
                SponsorshipView()
            } else {
                OnboardingView()
            }
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


