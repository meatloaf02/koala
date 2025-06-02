//
//  SponsorProfileView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 5/14/25.
//
import SwiftUI

struct SponsorProfileView: View {
    @AppStorage("sponsorName") private var sponsorName: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Sponsor Info")) {
                    Text("Name: \(sponsorName)")
                }
            }
            .navigationTitle("Profile")
        }
    }
}
