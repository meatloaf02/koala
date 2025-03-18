//
//  YouthBaseballSponsorshipApp.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 3/6/25.
//

import SwiftUI

@main
struct YouthBaseballSponsorshipApp: App {
    @AppStorage("hasCompletedProfileSetup") private var hasCompletedProfileSetup: Bool = false
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            if hasCompletedProfileSetup {
                SponsorshipView()
                    .environment(\.managedObjectContext, persistenceController.context)
            } else {
                PlayerRegistrationView()
                    .environment(\.managedObjectContext, persistenceController.context)
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


