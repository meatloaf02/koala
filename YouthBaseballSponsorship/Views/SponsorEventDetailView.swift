//
//  SponsorEventDetailView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 5/8/25.
//
import SwiftUI
import CoreData

struct SponsorEventDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    let event: GameEventEntity

    @State private var sponsorName: String = ""
    @State private var statType: String = "Home Runs"
    @State private var amountPerStat: Double = 5.0
    @State private var maxPledgeAmount: Double = 100.0
    @State private var isRecurring: Bool = false
    @State private var showConfirmation = false

    let statOptions = ["Home Runs", "Strikeouts", "Hits", "Stolen Bases"]

    var body: some View {
        Form {
            Section(header: Text("Event Details")) {
                Text(event.title ?? "Untitled Event")
                Text("Date: \(event.date ?? Date(), style: .date)")
                Text("Location: \(event.location ?? "Unknown")")
            }

            Section(header: Text("Sponsor Info")) {
                TextField("Your Name", text: $sponsorName)
            }

            Section(header: Text("Challenge Setup")) {
                Picker("Stat Type", selection: $statType) {
                    ForEach(statOptions, id: \.self) { stat in
                        Text(stat)
                    }
                }

                Stepper(value: $amountPerStat, in: 1...100, step: 1) {
                    Text("Amount per \(statType): $\(Int(amountPerStat))")
                }

                Stepper(value: $maxPledgeAmount, in: 10...1000, step: 10) {
                    Text("Max Pledge: $\(Int(maxPledgeAmount))")
                }

                Toggle("Recurring Monthly", isOn: $isRecurring)
            }

            Section {
                Button(action: submitChallenge) {
                    Text("Create Challenge")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .navigationTitle("Sponsor Player")
        .alert("Challenge Created", isPresented: $showConfirmation) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your challenge is now active for this event.")
        }
    }

    private func submitChallenge() {
        guard let eventId = event.id, let playerId = event.playerId else { return }

        let challenge = SponsorshipChallengeEntity(context: viewContext)
        challenge.id = UUID()
        challenge.eventId = eventId
        challenge.playerId = playerId
        challenge.sponsorName = sponsorName
        challenge.statType = statType
        challenge.amountPerStat = amountPerStat
        challenge.maxPledgeAmount = maxPledgeAmount
        challenge.isRecurring = isRecurring
        challenge.isPaid = false

        do {
            try viewContext.save()
            showConfirmation = true
        } catch {
            print("Failed to save challenge: \(error.localizedDescription)")
        }
    }
}
