//
//  CreateTeamView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 4/28/25.
//
import SwiftUI
import CoreData

struct CreateTeamView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var teamName: String = ""
    @State private var coachName: String = ""
    @State private var players: [String] = [""]
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @AppStorage("hasCompletedCoachSetup") private var hasCompletedCoachSetup: Bool = false
    @State private var navigateToTeamDashboard = false
    @AppStorage("currentUserRole") private var currentUserRole: String = ""
    @AppStorage("hasRegistered") private var hasRegistered: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Team Info")) {
                    TextField("Team Name", text: $teamName)
                    TextField("Coach Name", text: $coachName)
                }

                Section(header: Text("Team Logo")) {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .clipShape(Circle())
                    }
                    Button("Select Logo") {
                        showingImagePicker = true
                    }
                }

                Section(header: Text("Add Players")) {
                    ForEach(players.indices, id: \.self) { index in
                        TextField("Player \(index + 1)", text: $players[index])
                    }
                    Button(action: {
                        players.append("")
                    }) {
                        Label("Add Another Player", systemImage: "plus")
                    }
                }

                Section {
                    Button(action: saveTeam) {
                        Text("Create Team")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .navigationTitle("Create Team")
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
            .navigationDestination(isPresented: $navigateToTeamDashboard) {
                TeamDashboardView()
            }
        }
    }

    private func saveTeam() {
        let newTeam = TeamEntity(context: viewContext)
        newTeam.id = UUID()
        newTeam.name = teamName
        newTeam.coachName = coachName
        newTeam.logoImageName = saveImageToDocuments(image: selectedImage)
        newTeam.players = players.filter { !$0.isEmpty } as NSObject // Save non-empty player names
        
        do {
            try viewContext.save()
            hasCompletedCoachSetup = true
            navigateToTeamDashboard = true // Navigate after save
            currentUserRole = "coach"
            hasRegistered = true
            print("Team saved successfully!")
        } catch {
            print("Failed to save team: \(error.localizedDescription)")
        }
    }

    private func saveImageToDocuments(image: UIImage?) -> String? {
        guard let image = image else { return nil }
        let imageName = UUID().uuidString + ".png"
        let imagePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(imageName)

        if let data = image.pngData() {
            try? data.write(to: imagePath)
            return imageName
        }
        return nil
    }
}
