//
//  SponsorEventBrowserView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 5/8/25.
//
import SwiftUI
import CoreData

struct SponsorEventBrowserView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: GameEventEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \GameEventEntity.date, ascending: true)]
    ) private var allEvents: FetchedResults<GameEventEntity>

    var body: some View {
        NavigationStack {
            List(filteredUpcomingEvents) { event in
                NavigationLink(destination: SponsorEventDetailView(event: event)) {
                    VStack(alignment: .leading) {
                        Text(event.title ?? "Untitled Event")
                            .font(.headline)
                        Text(event.date ?? Date(), style: .date)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("Location: \(event.location ?? "Unknown")")
                            .font(.subheadline)
                        if let player = fetchPlayer(for: event) {
                            Text("Player: \(player.name ?? "Unknown")")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                            if hasPaidChallenges(for: event) {
                                Text("Paid")
                                    .font(.caption2)
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .background(Color.green)
                                    .cornerRadius(4)
                            }
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Browse Upcoming Events")
        }
    }

    // Show all upcoming events with an associated player
    private var filteredUpcomingEvents: [GameEventEntity] {
        allEvents.filter {
            guard let date = $0.date else { return false }
            return date > Date() && $0.playerId != nil
        }
    }
    
    private func fetchPlayer(for event: GameEventEntity) -> PlayerEntity? {
        guard let playerId = event.playerId else { return nil }
        let request: NSFetchRequest<PlayerEntity> = PlayerEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", playerId as CVarArg)
        request.fetchLimit = 1
        return (try? viewContext.fetch(request))?.first
    }
    
    private func hasPaidChallenges(for event: GameEventEntity) -> Bool {
        let request: NSFetchRequest<SponsorshipChallengeEntity> = SponsorshipChallengeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "eventId == %@ AND isPaid == YES", event.id! as CVarArg)
        request.fetchLimit = 1
        return (try? viewContext.fetch(request))?.isEmpty == false
    }
}
