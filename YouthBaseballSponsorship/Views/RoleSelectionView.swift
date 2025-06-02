//
//  RoleSelectionView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 4/28/25.
//
import SwiftUI

struct RoleSelectionView: View {
    @State private var navigateToPlayerRegistration = false
    @State private var navigateToCreateTeam = false
    @State private var navigateToSponsorRegistration = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()

                Text("Choose Your Role")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()

                Button(action: {
                    navigateToPlayerRegistration = true
                }) {
                    Text("I'm a Player")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }
                .navigationDestination(isPresented: $navigateToPlayerRegistration) {
                    PlayerRegistrationView()
                }

                Button(action: {
                    navigateToCreateTeam = true
                }) {
                    Text("I'm a Coach")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }
                .navigationDestination(isPresented: $navigateToCreateTeam) {
                    CreateTeamView()
                }
                Button(action: {
                    navigateToSponsorRegistration = true
                }) {
                    Text("I'm a Sponsor")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }
                .navigationDestination(isPresented: $navigateToSponsorRegistration) {
                    SponsorRegistrationView()
                }

                Spacer()
            }
            .navigationTitle("Select Role")
            .navigationBarHidden(true)
        }
    }
}
