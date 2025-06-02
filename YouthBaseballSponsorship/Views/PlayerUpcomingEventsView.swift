//
//  PlayerUpcomingEventsView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 5/8/25.
//
import SwiftUI
import CoreData

struct PlayerUpcomingEventsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("currentPlayerId") private var currentPlayerId: String = ""
    @State private var showPastEvents = false

    @FetchRequest(
        entity: GameEventEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \GameEventEntity.date, ascending: true)]
    ) private var allEvents: FetchedResults<GameEventEntity>

    var body: some View {
        NavigationStack {
            Toggle("Show Past Events", isOn: $showPastEvents)
                .padding(.horizontal)
            List(filteredEvents) { event in
                NavigationLink(destination: EventDetailView(event: event)) {
                    VStack(alignment: .leading) {
                        Text(event.title ?? "Untitled Event")
                            .font(.headline)
                        Text(event.date ?? Date(), style: .date)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("Location: \(event.location ?? "Unknown")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("My Events")
            .toolbar {
            }
        }
    }

    private var filteredEvents: [GameEventEntity] {
        guard let playerUUID = UUID(uuidString: currentPlayerId) else { return [] }
        let now = Date()
        return allEvents.filter {
            $0.playerId == playerUUID &&
            (showPastEvents ? ($0.date ?? Date()) < now : ($0.date ?? Date()) >= now)
        }
        .sorted { ($0.date ?? Date()) < ($1.date ?? Date()) }
    }
}
