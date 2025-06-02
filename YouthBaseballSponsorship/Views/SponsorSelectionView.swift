//
//  SponsorSelectionView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 5/9/25.

// Removed this from this from the navigation logic of the player registration view. 5/27/25.
import SwiftUI
import CoreData

struct SponsorSelectionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("currentPlayerId") private var currentPlayerId: String = ""
    @AppStorage("linkedSponsorName") private var linkedSponsorName: String = ""
    @AppStorage("hasRegistered") private var hasRegistered: Bool = false

    @State private var sponsorInput: String = ""
    @State private var navigateToCreateEvent = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Optional Sponsor")) {
                    TextField("Enter sponsor name", text: $sponsorInput)
                        .textInputAutocapitalization(.words)
                }

                Section {
                    Button("Continue") {
                        if !sponsorInput.trimmingCharacters(in: .whitespaces).isEmpty {
                            linkedSponsorName = sponsorInput
                            updatePlayerWithSponsor()
                        }
                        hasRegistered = true
                        navigateToCreateEvent = true
                    }
                }
            }
            .navigationTitle("Select a Sponsor")
            .navigationDestination(isPresented: $navigateToCreateEvent) {
                CreateEventView()
            }
        }
    }

    private func updatePlayerWithSponsor() {
        guard let uuid = UUID(uuidString: currentPlayerId) else { return }

        let request: NSFetchRequest<PlayerEntity> = PlayerEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        request.fetchLimit = 1

        if let player = try? viewContext.fetch(request).first {
            player.sponsorName = sponsorInput
            try? viewContext.save()
        }
    }
}
