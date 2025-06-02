//
//  ProfileView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 3/6/25.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("hasLoggedIn") private var hasLoggedIn: Bool = false
    @AppStorage("currentUserRole") private var currentUserRole: String = ""
    @AppStorage("currentPlayerId") private var currentPlayerId: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Player Info")) {
                    Text("User ID: \(currentPlayerId)")
                }

                Section {
                    Button("Sign Out") {
                        signOut()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Profile")
        }
    }

    private func signOut() {
        hasLoggedIn = false
        currentUserRole = ""
        currentPlayerId = ""
    }
}
