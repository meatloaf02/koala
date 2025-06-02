//
//  ChallengeDetailView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 5/16/25.
//
import SwiftUI
import CoreData


struct ChallengeDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    var challenge: SponsorshipChallengeEntity

    var body: some View {
        Form {
            Section(header: Text("Challenge Details")) {
                Text(challenge.goalDescription ?? "No goal specified")
                if let statType = challenge.statType {
                    Text("Stat Type: \(statType)")
                }
                if challenge.maxPledgeAmount > 0 {
                    Text("Max Pledge: $\(String(format: "%.2f", challenge.maxPledgeAmount))")
                }
                if let playerId = challenge.playerId {
                    Text("Player ID: \(playerId)")
                }
                if let eventId = challenge.eventId {
                    Text("Event ID: \(eventId)")
                }
            }

            Section(header: Text("Deadline")) {
                Text(formattedDate(challenge.deadline))
            }

        let amount = challenge.pledgeAmount
        if amount > 0 {
                Section(header: Text("Pledge Amount")) {
                    Text(String(format: "$%.2f", amount))
                }
            }

            Section(header: Text("Status")) {
                Text(challenge.isClosed ? "Closed" : "Active")
            }
            
            Section(header: Text("Stat Submission")) {
                if let imageName = challenge.statImageName,
                   let imageURL = getDocumentsDirectory()?.appendingPathComponent(imageName),
                   let uiImage = UIImage(contentsOfFile: imageURL.path) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                } else {
                    Text("No stat image submitted.")
                        .foregroundColor(.secondary)
                }
            }
            
            Section(header: Text("Sponsor Notes")) {
                TextEditor(text: Binding(
                    get: { challenge.notes ?? "" },
                    set: { newValue in
                        challenge.notes = newValue
                        try? viewContext.save()
                    }
                ))
                .frame(minHeight: 100)
            }
            
            Section {
                Button(action: {
                    challenge.isClosed = true
                    try? viewContext.save()
                    dismiss()
                }) {
                    Text("Approve and Close Challenge")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }

            Section {
                Toggle("Mark as Closed", isOn: Binding(
                    get: { challenge.isClosed },
                    set: { newValue in
                        challenge.isClosed = newValue
                        try? viewContext.save()
                    }
                ))
            }

            Section(header: Text("Payment Status")) {
                Toggle("Mark as Paid", isOn: Binding(
                    get: { challenge.isPaid },
                    set: { newValue in
                        challenge.isPaid = newValue
                        try? viewContext.save()
                    }
                ))
            }
        }
        .navigationTitle("Challenge Details")
    }

    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func getDocumentsDirectory() -> URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
}
