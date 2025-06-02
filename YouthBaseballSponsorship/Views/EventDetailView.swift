//
//  EventDetailView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 5/8/25.
//
import SwiftUI
import UniformTypeIdentifiers
import CoreData

struct EventDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var event: GameEventEntity

    @AppStorage("currentPlayerId") private var currentPlayerId: String = ""

    @FetchRequest(
        sortDescriptors: [],
        predicate: nil,
        animation: .default
    ) private var allChallenges: FetchedResults<SponsorshipChallengeEntity>

    @State private var selectedFileURL: URL?
    @State private var showingFileImporter = false
    @State private var uploadSuccess = false

    private var relatedChallenges: [SponsorshipChallengeEntity] {
        guard let eventId = event.id, let playerUUID = UUID(uuidString: currentPlayerId) else {
            return []
        }
        return allChallenges.filter { $0.eventId == eventId && $0.playerId == playerUUID }
    }

    var body: some View {
        VStack(spacing: 20) {
            Text(event.title ?? "Untitled Event")
                .font(.title)
                .fontWeight(.bold)

            Text(event.date ?? Date(), style: .date)
                .font(.headline)
                .foregroundColor(.secondary)

            Text("Location: \(event.location ?? "Unknown")")
                .font(.subheadline)

            Divider()

            if event.statsSubmitted {
                Text("📄 Stats uploaded")
                    .foregroundColor(.green)
            } else {
                Button(action: {
                    showingFileImporter = true
                }) {
                    Text("Upload Game Stats")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }

            if !relatedChallenges.isEmpty {
                Divider()
                VStack(alignment: .leading, spacing: 10) {
                    Text("Challenges for This Event")
                        .font(.headline)
                    ForEach(relatedChallenges, id: \.self) { challenge in
                        VStack(alignment: .leading) {
                            Text("• \(challenge.goalDescription ?? "No description")")
                            let amount = challenge.pledgeAmount
                            if amount > 0 {
                                Text("  💰 Pledge: $\(amount, specifier: "%.2f")")
                            }
                            if let deadline = challenge.deadline {
                                Text("  ⏳ Deadline: \(deadline.formatted(date: .abbreviated, time: .omitted))")
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Event Details")
        .fileImporter(
            isPresented: $showingFileImporter,
            allowedContentTypes: [.image, .pdf],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    handleFileUpload(url: url)
                }
            case .failure(let error):
                print("File import error: \(error.localizedDescription)")
            }
        }
        .alert("Stats Uploaded", isPresented: $uploadSuccess) {
            Button("OK", role: .cancel) {}
        }
    }

    private func handleFileUpload(url: URL) {
        guard let eventId = event.id, let playerUUID = UUID(uuidString: currentPlayerId) else {
            print("Invalid event ID or player ID")
            return
        }
        let filename = UUID().uuidString + "-" + url.lastPathComponent
        let destURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)

        do {
            let data = try Data(contentsOf: url)
            try data.write(to: destURL)

            event.statsImageName = filename
            event.statsSubmitted = true

            // Associate stat image with related challenges
            let fetchRequest: NSFetchRequest<SponsorshipChallengeEntity> = SponsorshipChallengeEntity.fetchRequest()
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "eventId == %@", eventId as CVarArg),
                NSPredicate(format: "playerId == %@", playerUUID as CVarArg)
            ])

            do {
                let challenges = try viewContext.fetch(fetchRequest)
                for challenge in challenges {
                    challenge.statImageName = filename
                }

                try viewContext.save()
                uploadSuccess = true
            } catch {
                print("Failed to associate stat with challenge or save context: \(error)")
            }
        } catch {
            print("Failed to save file or update Core Data: \(error.localizedDescription)")
        }
    }
}
