//
//  SubmissionsView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 5/27/25.
//

import SwiftUI
import CoreData

struct SubmissionsView: View {
    @AppStorage("currentPlayerId") private var currentPlayerId: String = ""

    var body: some View {
        let predicate: NSPredicate
        if let uuid = UUID(uuidString: currentPlayerId) {
            predicate = NSPredicate(format: "playerId == %@", uuid as CVarArg)
        } else {
            predicate = NSPredicate(value: false) // fallback to avoid crashing
        }

        return SubmissionsListView(predicate: predicate)
    }
}

struct SubmissionsListView: View {
    var predicate: NSPredicate

    @FetchRequest var challenges: FetchedResults<SponsorshipChallengeEntity>
    @State private var showPaidOnly = false

    init(predicate: NSPredicate) {
        self.predicate = predicate
        _challenges = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \SponsorshipChallengeEntity.deadline, ascending: false)],
            predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [
                predicate,
                NSPredicate(format: "statImageName != nil")
            ])
        )
        //print("Found challenges: \(challenges.count)")
    }

    var body: some View {
        NavigationStack {
            if challenges.isEmpty {
                VStack {
                    Text("No submissions yet.")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .padding()
                }
                .navigationTitle("Submissions")
            } else {
                VStack {
                    Toggle("Show Paid Only", isOn: $showPaidOnly)
                        .padding()
                    List {
                        ForEach(challenges.filter { showPaidOnly ? $0.isPaid : true }) { challenge in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(challenge.goalDescription ?? "No Description")
                                    .font(.headline)

                                if let statType = challenge.statType {
                                    Text("Stat Type: \(statType)")
                                        .font(.subheadline)
                                }

                                if let deadline = challenge.deadline {
                                    Text("Deadline: \(deadline.formatted(date: .abbreviated, time: .omitted))")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }

                                if challenge.isPaid {
                                    Text("Paid")
                                        .font(.caption2)
                                        .foregroundColor(.white)
                                        .padding(4)
                                        .background(Color.green)
                                        .cornerRadius(4)
                                }

                                if let note = challenge.notes, !note.isEmpty {
                                    Text("Note from Sponsor: \(note)")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }

                                if let imageName = challenge.statImageName {
                                    Text("Submitted Stat: \(imageName)")
                                        .font(.footnote)
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .navigationTitle("Submissions")
            }
        }
    }
}
