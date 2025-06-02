//
//  SponsorPlayerProfileView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 5/16/25.
//
import SwiftUI
import CoreData

struct SponsorPlayerProfileView: View {
    var player: PlayerEntity

    @FetchRequest var upcomingEvents: FetchedResults<GameEventEntity>

    init(player: PlayerEntity) {
        self.player = player
        _upcomingEvents = FetchRequest<GameEventEntity>(
            sortDescriptors: [NSSortDescriptor(keyPath: \GameEventEntity.date, ascending: true)],
            predicate: NSPredicate(format: "playerId == %@", player.id?.uuidString ?? "")
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(player.name ?? "Unknown Player")
                .font(.largeTitle)
                .bold()

            Text("Position: \(player.position ?? "N/A")")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Divider()

            Text("Upcoming Events")
                .font(.headline)

            if upcomingEvents.isEmpty {
                Text("No upcoming events.")
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            } else {
                List(upcomingEvents) { event in
                    NavigationLink(destination: CreateChallengeView(player: player, event: event)) {
                        VStack(alignment: .leading) {
                            Text(event.title ?? "Untitled Event")
                                .font(.headline)
                            Text(event.dateFormatted)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Player Profile")
    }
}

// Extension for formatting dates
extension GameEventEntity {
    var dateFormatted: String {
        guard let date = self.date else { return "Unknown Date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
