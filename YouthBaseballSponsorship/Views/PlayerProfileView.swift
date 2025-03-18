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
import CoreData

struct PlayerProfileView: View {
    @State private var player: PlayerEntity?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let player = player {
                    // Ensure image loading works correctly
                    if let imageName = player.profileImage, let uiImage = UIImage(named: imageName) {
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

                    Text(player.name ?? "Unknown Player")
                        .font(.title)
                        .bold()

                    Text(player.position ?? "No Position")
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
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<PlayerEntity> = PlayerEntity.fetchRequest()

        do {
            let players = try context.fetch(fetchRequest)
            if let firstPlayer = players.first { // Assuming you're displaying only one player
                player = firstPlayer
            }
        } catch {
            print("Failed to fetch player profile: \(error.localizedDescription)")
        }
    }
}
