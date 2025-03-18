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
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: PlayerEntity.entity(), sortDescriptors: []) var players: FetchedResults<PlayerEntity>
    
    @AppStorage("hasCompletedProfileSetup") private var hasCompletedProfileSetup: Bool = true

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let player = players.first {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .foregroundColor(.gray)

                    Text(player.name ?? "Unknown Player")
                        .font(.title)
                        .bold()

                    Text(player.position ?? "No Position")
                        .font(.headline)
                        .foregroundColor(.gray)

                    Text("Sponsorship Goal: $\(Int(player.fundingGoal))")
                        .font(.subheadline)

                    Button(action: {
                        resetProfile()
                    }) {
                        Text("Reset Profile")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                } else {
                    Text("No player profile found.")
                }
            }
            .navigationTitle("Player Profile")
            .padding()
        }
    }

    private func resetProfile() {
        for player in players {
            viewContext.delete(player) // Delete existing player data
        }
        try? viewContext.save()
        
        hasCompletedProfileSetup = false // Reset profile setup flag
    }
}
