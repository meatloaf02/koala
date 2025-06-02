//
//  PlayerHomeView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 5/14/25.
//
import SwiftUI

struct PlayerHomeView: View {
    @AppStorage("hasLoggedIn") private var hasLoggedIn = false
    @AppStorage("currentUserRole") private var currentUserRole = ""
    @AppStorage("currentPlayerId") private var currentPlayerId = ""

    var body: some View {
        TabView {
            NavigationStack {
                PlayerUpcomingEventsView()
                    .navigationTitle("My Events")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Sign Out") {
                                signOut()
                            }
                        }
                    }
            }
            .tabItem {
                Label("My Events", systemImage: "calendar")
            }

            NavigationStack {
                CreateEventView()
                    .navigationTitle("Create Event")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Sign Out") {
                                signOut()
                            }
                        }
                    }
            }
            .tabItem {
                Label("Create Event", systemImage: "plus.circle")
            }

            NavigationStack {
                PlayerProfileView()
                    .navigationTitle("Profile")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Sign Out") {
                                signOut()
                            }
                        }
                    }
            }
            .tabItem {
                Label("Profile", systemImage: "person.circle")
            }

            NavigationStack {
                SubmissionsView()
                    .navigationTitle("Submissions")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Sign Out") {
                                signOut()
                            }
                        }
                    }
            }
            .tabItem {
                Label("Submissions", systemImage: "doc.text")
            }
        }
    }

    private func signOut() {
        hasLoggedIn = false
        currentUserRole = ""
        currentPlayerId = ""
        print("✅ Signed out")
    }
}
