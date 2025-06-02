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

    @AppStorage("hasLoggedIn") private var hasLoggedIn: Bool = false
    @AppStorage("currentUserRole") private var currentUserRole: String = ""

    var body: some Scene {
        WindowGroup {
            if hasLoggedIn {
                switch currentUserRole {
                case "player":
                    PlayerHomeView()
                        .id("loggedIn")
                        .environment(\.managedObjectContext, persistenceController.context)
                case "coach":
                    TeamDashboardView()
                        .id("loggedIn")
                        .environment(\.managedObjectContext, persistenceController.context)
                case "sponsor":
                    SponsorHomeView()
                        .id("loggedIn")
                        .environment(\.managedObjectContext, persistenceController.context)
                default:
                    WelcomeView()
                        .id("loggedOut")
                        .environment(\.managedObjectContext, persistenceController.context)
                }
            } else {
                WelcomeView()
                    .id("loggedOut")
                    .environment(\.managedObjectContext, persistenceController.context)
            }
        }
    }
}
