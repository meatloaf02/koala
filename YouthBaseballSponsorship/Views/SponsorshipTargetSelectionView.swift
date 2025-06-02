//
//  SponsorshipTargetSelectionView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 4/29/25.
//
import SwiftUI
import CoreData

struct SponsorshipTargetSelectionView: View {
    let sponsorName: String
    let email: String
    let organization: String

    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: PlayerEntity.entity(), sortDescriptors: []) var players: FetchedResults<PlayerEntity>
    @FetchRequest(entity: TeamEntity.entity(), sortDescriptors: []) var teams: FetchedResults<TeamEntity>

    @State private var selectionMode: SelectionMode = .player
    @State private var selectedPlayerIDs: Set<UUID> = []
    @State private var selectedTeamIDs: Set<UUID> = []
    @State private var navigateToPledge = false

    enum SelectionMode: String, CaseIterable {
        case player = "Players"
        case team = "Teams"
    }

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Sponsor", selection: $selectionMode) {
                    ForEach(SelectionMode.allCases, id: \.self) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                List {
                    if selectionMode == .player {
                        ForEach(players) { player in
                            MultipleSelectionRow(title: player.name ?? "Unnamed Player", isSelected: selectedPlayerIDs.contains(player.id ?? UUID())) {
                                togglePlayerSelection(player.id)
                            }
                        }
                    } else {
                        ForEach(teams) { team in
                            MultipleSelectionRow(title: team.name ?? "Unnamed Team", isSelected: selectedTeamIDs.contains(team.id ?? UUID())) {
                                toggleTeamSelection(team.id)
                            }
                        }
                    }
                }

                Button(action: {
                    navigateToPledge = true
                }) {
                    Text("Continue to Pledge")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(selectionIsEmpty)
                .padding(.bottom)
                .navigationDestination(isPresented: $navigateToPledge) {
                    SponsorshipPledgeView(
                        sponsorName: sponsorName,
                        email: email,
                        organization: organization,
                        selectedPlayerIDs: Array(selectedPlayerIDs),
                        selectedTeamIDs: Array(selectedTeamIDs)
                    )
                }
            }
            .navigationTitle("Select Who to Sponsor")
        }
    }

    private var selectionIsEmpty: Bool {
        selectionMode == .player ? selectedPlayerIDs.isEmpty : selectedTeamIDs.isEmpty
    }

    private func togglePlayerSelection(_ id: UUID?) {
        guard let id = id else { return }
        if selectedPlayerIDs.contains(id) {
            selectedPlayerIDs.remove(id)
        } else {
            selectedPlayerIDs.insert(id)
        }
    }

    private func toggleTeamSelection(_ id: UUID?) {
        guard let id = id else { return }
        if selectedTeamIDs.contains(id) {
            selectedTeamIDs.remove(id)
        } else {
            selectedTeamIDs.insert(id)
        }
    }
}

struct MultipleSelectionRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
