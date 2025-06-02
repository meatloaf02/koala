//
//  CreateChallengeView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 5/16/25.
//
import SwiftUI
import CoreData

struct CreateChallengeView: View {
    var player: PlayerEntity
    var event: GameEventEntity

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @AppStorage("sponsorName") private var sponsorName: String = ""

    @State private var goalDescription: String = ""
    @State private var statType: String = ""
    @State private var maxPledgeAmount: String = ""
    @State private var deadline: Date = Date()
    @State private var showAlert = false

    let statTypes = ["Home Runs", "RBIs", "Hits", "Runs", "Stolen Bases", "Strikeouts", "Innings Pitched", "Batting Average"]

    private var calculatedPledgeAmount: Double {
        let pledgeRates: [String: Double] = [
            "Home Runs": 25.0,
            "RBIs": 10.0,
            "Hits": 5.0,
            "Runs": 7.0,
            "Stolen Bases": 15.0,
            "Strikeouts": 12.0,
            "Innings Pitched": 8.0,
            "Batting Average": 50.0
        ]
        return pledgeRates[statType] ?? 0.0
    }

    var body: some View {
        Form {
            Section(header: Text("Challenge Details")) {
                TextField("Description", text: $goalDescription)
                Picker("Stat Type", selection: $statType) {
                    ForEach(statTypes, id: \.self) { type in
                        Text(type).tag(type)
                    }
                }
                Text("Pledge Amount per \(statType): $\(calculatedPledgeAmount, specifier: "%.2f")")
                    .foregroundColor(.secondary)

                TextField("Max Pledge Amount (optional)", text: $maxPledgeAmount)
                    .keyboardType(.decimalPad)

                DatePicker("Deadline", selection: $deadline, displayedComponents: .date)
            }

            Section {
                Button("Create Challenge") {
                    createChallenge()
                }
                .disabled(goalDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .navigationTitle("New Challenge")
        .alert("Challenge Created", isPresented: $showAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your challenge has been saved.")
        }
    }

    private func createChallenge() {
        guard let playerId = player.id, let eventId = event.id else {
            print("❌ Missing player or event ID.")
            return
        }

        let newChallenge = SponsorshipChallengeEntity(context: viewContext)
        newChallenge.id = UUID()
        newChallenge.playerId = playerId
        newChallenge.eventId = eventId
        newChallenge.sponsorName = sponsorName
        newChallenge.goalDescription = goalDescription
        newChallenge.statType = statType
        newChallenge.deadline = deadline
        let pledgeRates: [String: Double] = [
            "Home Runs": 25.0,
            "RBIs": 10.0,
            "Hits": 5.0,
            "Runs": 7.0,
            "Stolen Bases": 15.0,
            "Strikeouts": 12.0,
            "Innings Pitched": 8.0,
            "Batting Average": 50.0
        ]
        newChallenge.pledgeAmount = pledgeRates[statType] ?? 0.0
        newChallenge.maxPledgeAmount = Double(maxPledgeAmount) ?? 0.0
        newChallenge.isClosed = false
        newChallenge.statImageName = nil

        do {
            try viewContext.save()
            print("✅ Challenge saved successfully.")
            showAlert = true
        } catch {
            print("❌ Failed to save challenge: \(error), \(error.localizedDescription)")
        }
    }
}
