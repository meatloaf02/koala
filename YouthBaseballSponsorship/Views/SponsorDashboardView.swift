//
//  sponsorDashboardView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 5/8/25.
//
import SwiftUI
import CoreData

struct SponsorDashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("sponsorName") private var sponsorName: String = ""

    @FetchRequest(
        entity: SponsorshipChallengeEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \SponsorshipChallengeEntity.id, ascending: false)]
    ) private var allChallenges: FetchedResults<SponsorshipChallengeEntity>

    var body: some View {
        NavigationStack {
            List(filteredChallenges) { challenge in
                VStack(alignment: .leading, spacing: 6) {
                    Text("\(challenge.statType ?? "") Challenge")
                        .font(.headline)

                    Text("Pledge: $\(Int(challenge.amountPerStat)) per \(challenge.statType ?? "")")
                        .font(.subheadline)

                    Text("Max: $\(Int(challenge.maxPledgeAmount))")
                        .font(.subheadline)

                    Text("Event ID: \(challenge.eventId?.uuidString ?? "N/A")")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    if challenge.isPaid {
                        Text("✅ Paid")
                            .font(.caption)
                            .foregroundColor(.green)
                    } else {
                        Text("💸 Payment Pending")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("My Sponsorships")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                }
            }

        }
    }

    private var filteredChallenges: [SponsorshipChallengeEntity] {
        allChallenges.filter { $0.sponsorName == sponsorName }
    }
}
