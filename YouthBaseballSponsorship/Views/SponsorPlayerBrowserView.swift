//
//  SponsorPlayerBrowserView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 5/16/25.
//
import SwiftUI
import CoreData

struct SponsorPlayerBrowserView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \PlayerEntity.name, ascending: true)],
        animation: .default)
    private var players: FetchedResults<PlayerEntity>

    @State private var searchText: String = ""

    var filteredPlayers: [PlayerEntity] {
        if searchText.isEmpty {
            return Array(players)
        } else {
            return players.filter {
                $0.name?.localizedCaseInsensitiveContains(searchText) == true
            }
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredPlayers) { player in
                    NavigationLink(destination: SponsorPlayerProfileView(player: player)) {
                        VStack(alignment: .leading) {
                            Text(player.name ?? "Unknown Player")
                                .font(.headline)
                            Text(player.position ?? "")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Browse Players")
            .searchable(text: $searchText, prompt: "Search by name")
        }
    }
}
