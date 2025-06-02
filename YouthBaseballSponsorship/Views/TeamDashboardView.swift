//
//  TeamDashboardView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 4/28/25.
//
import SwiftUI
import CoreData

struct TeamDashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: TeamEntity.entity(), sortDescriptors: []) var teams: FetchedResults<TeamEntity>

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let team = teams.first {
                    if let logoName = team.logoImageName,
                       let uiImage = loadImageFromDocuments(named: logoName) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    } else {
                        Image(systemName: "person.3.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.gray)
                    }

                    Text(team.name ?? "Unknown Team")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Coach: \(team.coachName ?? "Unknown Coach")")
                        .font(.title2)
                        .foregroundColor(.secondary)

                    Divider()
                    
                    if team.seasonStarted {
                                           Text("🏆 Season In Progress!")
                                               .font(.headline)
                                               .foregroundColor(.green)
                                               .padding()
                                       } else {
                                           Button(action: {
                                               startSeason(for: team)
                                           }) {
                                               Text("Start Season")
                                                   .bold()
                                                   .frame(maxWidth: .infinity)
                                                   .padding()
                                                   .background(Color.orange)
                                                   .foregroundColor(.white)
                                                   .cornerRadius(10)
                                                   .padding(.horizontal, 40)
                                           }
                                       }

                    Divider()

                    Text("Players")
                        .font(.headline)
                        .padding(.top, 10)

                    if let playerList = team.players as? [String], !playerList.isEmpty {
                        List(playerList, id: \.self) { player in
                            Text(player)
                        }
                        .frame(height: 300)
                    } else {
                        Text("No players added yet.")
                            .foregroundColor(.gray)
                    }

                    Spacer()
                } else {
                    Text("No team found. Please create a team.")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .navigationTitle("Team Dashboard")
        }
    }
    
    private func startSeason(for team: TeamEntity) {
            team.seasonStarted = true
            do {
                try viewContext.save()
                print("Season started!")
            } catch {
                print("Failed to start season: \(error.localizedDescription)")
            }
        }


    private func loadImageFromDocuments(named imageName: String) -> UIImage? {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(imageName)
        return UIImage(contentsOfFile: path.path)
    }
}
