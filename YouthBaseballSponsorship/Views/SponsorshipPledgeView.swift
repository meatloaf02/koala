//
//  SponsorshipPledgeView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 4/29/25.
//
import SwiftUI

struct SponsorshipPledgeView: View {
    let sponsorName: String
    let email: String
    let organization: String
    let selectedPlayerIDs: [UUID]
    let selectedTeamIDs: [UUID]

    enum SponsorshipType: String, CaseIterable {
        case performanceBased = "Performance-Based"
        case oneTime = "One-Time"
    }

    enum StatCategory: String, CaseIterable {
        case homeRun = "Home Runs"
        case strikeout = "Strikeouts"
        case hits = "Hits"
    }

    @State private var sponsorshipType: SponsorshipType = .performanceBased
    @State private var statCategory: StatCategory = .homeRun
    @State private var amount: Double = 5.0
    @State private var maxAmount: Double = 100.0
    @State private var isRecurring: Bool = false

    @State private var oneTimeAmount: Double = 50.0
    @State private var showConfirmation = false

    var body: some View {
        Form {
            Section(header: Text("Sponsorship Type")) {
                Picker("Type", selection: $sponsorshipType) {
                    ForEach(SponsorshipType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            if sponsorshipType == .performanceBased {
                Section(header: Text("Performance-Based Details")) {
                    Picker("Stat Category", selection: $statCategory) {
                        ForEach(StatCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }

                    Stepper(value: $amount, in: 1...100, step: 1) {
                        Text("Amount per \(statCategory.rawValue): $\(Int(amount))")
                    }

                    Stepper(value: $maxAmount, in: 10...1000, step: 10) {
                        Text("Max Limit: $\(Int(maxAmount))")
                    }

                    Toggle("Recurring Monthly Donation", isOn: $isRecurring)
                }
            } else {
                Section(header: Text("One-Time Donation")) {
                    Stepper(value: $oneTimeAmount, in: 10...1000, step: 10) {
                        Text("Amount: $\(Int(oneTimeAmount))")
                    }
                }
            }

            Section {
                Button(action: {
                    submitPledge()
                    showConfirmation = true
                }) {
                    Text("Confirm Pledge")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .navigationTitle("Pledge Details")
        .alert("Pledge Confirmed", isPresented: $showConfirmation, actions: {
            Button("OK", role: .cancel) { }
        }, message: {
            Text("Thanks, \(sponsorName)! Your sponsorship has been recorded.")
        })
    }

    private func submitPledge() {
        // Future enhancement: Save to Core Data or send to backend

        print("Sponsor: \(sponsorName), \(email)")
        print("Target: \(selectedPlayerIDs.count) players, \(selectedTeamIDs.count) teams")
        print("Type: \(sponsorshipType.rawValue)")
        if sponsorshipType == .performanceBased {
            print("- Category: \(statCategory.rawValue)")
            print("- $\(Int(amount)) per \(statCategory.rawValue)")
            print("- Max: $\(Int(maxAmount)), Recurring: \(isRecurring)")
        } else {
            print("- One-time donation of $\(Int(oneTimeAmount))")
        }
    }
}
