//
//  SponsorHomeView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 5/14/25.
//
import SwiftUI

struct SponsorHomeView: View {
    @AppStorage("hasLoggedIn") private var hasLoggedIn: Bool = false
    @AppStorage("currentUserRole") private var currentUserRole: String = ""
    @AppStorage("sponsorName") private var sponsorName: String = ""

    var body: some View {
        NavigationStack {
            TabView {
                SponsorPlayerBrowserView()
                    .tabItem {
                        Label("Events", systemImage: "calendar")
                    }

                SponsorChallengeDashboardView()
                    .tabItem {
                        Label("My Sponsorships", systemImage: "dollarsign.circle")
                    }

                SponsorProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.circle")
                    }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Sign Out") {
                        signOut()
                    }
                }
            }
        }
    }

    private func signOut() {
        hasLoggedIn = false
        currentUserRole = ""
        sponsorName = ""
        print("✅ Sponsor signed out")
    }
}
