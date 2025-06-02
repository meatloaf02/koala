//
//  SponsorChallengeDashboardView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 5/16/25.
//
import SwiftUI
import CoreData

struct SponsorChallengeDashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("sponsorName") private var sponsorName: String = ""

    @FetchRequest private var challenges: FetchedResults<SponsorshipChallengeEntity>

    init() {
        _challenges = FetchRequest<SponsorshipChallengeEntity>(
            sortDescriptors: [NSSortDescriptor(keyPath: \SponsorshipChallengeEntity.deadline, ascending: true)],
            predicate: NSPredicate(format: "sponsorName == %@", UserDefaults.standard.string(forKey: "sponsorName") ?? "")
        )
    }

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Active Challenges")) {
                    ForEach(challenges.filter { challenge in
                        guard let deadline = challenge.deadline else { return false }
                        return !challenge.isClosed && deadline >= Date()
                    }) { challenge in
                        NavigationLink(destination: ChallengeDetailView(challenge: challenge)) {
                            challengeRow(challenge)
                        }
                    }
                }

                Section(header: Text("Closed Challenges")) {
                    ForEach(challenges.filter { challenge in
                        guard let deadline = challenge.deadline else { return true }
                        return challenge.isClosed || deadline < Date()
                    }) { challenge in
                        NavigationLink(destination: ChallengeDetailView(challenge: challenge)) {
                            challengeRow(challenge)
                        }
                    }
                }
            }
            .navigationTitle("My Challenges")
        }
    }

    @ViewBuilder
    private func challengeRow(_ challenge: SponsorshipChallengeEntity) -> some View {
        VStack(alignment: .leading) {
            Text(challenge.goalDescription ?? "No Goal")
                .font(.headline)

            Text("Deadline: \(formattedDate(challenge.deadline))")
                .font(.subheadline)
                .foregroundColor(.secondary)

            let amount = challenge.pledgeAmount
            if amount > 0 {
                Text(String(format: "$%.2f pledged", amount))
                    .font(.subheadline)
                    .foregroundColor(.green)

                if challenge.isPaid {
                    Text("Paid")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.green)
                        .cornerRadius(4)
                }
            }
        }
        .padding(.vertical, 4)
    }

    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
