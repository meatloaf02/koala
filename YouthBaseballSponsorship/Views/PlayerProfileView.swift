//
//  PlayerProfileView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 3/7/25.
//
//
//  PlayerProfileView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 3/7/25.
//
//
//  PlayerProfileView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 3/7/25.
//

//
//  PlayerProfileView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 3/7/25.
//
//
//  PlayerProfileView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 3/7/25.
//

import SwiftUI
import Foundation

struct PlayerProfileView: View {
    @State private var player: Player?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let player = player {
                    // Ensure image loading works correctly
                    if let uiImage = UIImage(named: player.profileImage) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .foregroundColor(.gray)
                    }

                    Text(player.name)
                        .font(.title)
                        .bold()

                    Text(player.position)
                        .font(.headline)
                        .foregroundColor(.gray)

                    Text("Sponsorship Goal: $\(Int(player.fundingGoal))")
                        .font(.subheadline)

                    Button("Edit Profile") {
                        // Navigate to edit profile screen
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                } else {
                    Text("No player profile found.")
                }
            }
            .navigationTitle("Player Profile")
        }
        .onAppear {
            loadPlayerProfile()
        }
    }

    private func loadPlayerProfile() {
        // Example Player Data
        player = Player(
            id: UUID(),
            name: "Jake Martinez",
            position: "Pitcher",
            stats: "ERA: 2.8",
            profileImage: "player1", // Ensure this image exists in the asset catalog
            fundingGoal: 1000
        )
    }
}
