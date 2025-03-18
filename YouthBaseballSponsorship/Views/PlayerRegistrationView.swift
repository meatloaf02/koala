//
//  PlayerRegistrationView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 3/7/25.
//

import SwiftUI
import PhotosUI
import CoreData

struct PlayerRegistrationView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var name: String = ""
    @State private var position: String = ""
    @State private var team: String = ""
    @State private var fundingGoal: Double = 500.0
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingResetConfirmation = false
    @AppStorage("hasCompletedProfileSetup") private var hasCompletedProfileSetup: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Player Info")) {
                    TextField("Full Name", text: $name)
                    TextField("Position", text: $position)
                    TextField("Team Name", text: $team)
                }

                Section(header: Text("Sponsorship Goal")) {
                    Stepper(value: $fundingGoal, in: 100...5000, step: 50) {
                        Text("Goal: $\(Int(fundingGoal))")
                    }
                }

                Section(header: Text("Profile Picture")) {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .clipShape(Circle())
                    }
                    Button("Select Photo") {
                        showingImagePicker = true
                    }
                }

                Section {
                    Button(action: saveProfile) {
                        Text("Complete Setup")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }

                Section {
                    Button(action: {
                        showingResetConfirmation = true
                    }) {
                        Text("Reset Profile")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .alert(isPresented: $showingResetConfirmation) {
                        Alert(
                            title: Text("Reset Profile?"),
                            message: Text("This will erase your profile and restart the setup."),
                            primaryButton: .destructive(Text("Reset")) {
                                resetProfile()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
            .navigationTitle("Player Registration")
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }

    private func saveProfile() {
        let newPlayer = PlayerEntity(context: viewContext)
        newPlayer.id = UUID()
        newPlayer.name = name
        newPlayer.position = position
        newPlayer.stats = "No stats yet"
        newPlayer.profileImage = saveImageToDocuments(image: selectedImage)
        newPlayer.fundingGoal = fundingGoal

        do {
            try viewContext.save()
            hasCompletedProfileSetup = true
        } catch {
            print("Failed to save profile: \(error.localizedDescription)")
        }
    }

    private func resetProfile() {
        let fetchRequest: NSFetchRequest<PlayerEntity> = PlayerEntity.fetchRequest()

        do {
            let fetchedPlayers = try viewContext.fetch(fetchRequest)
            for player in fetchedPlayers {
                viewContext.delete(player) // Delete player from Core Data
            }
            try viewContext.save() // Save changes
            hasCompletedProfileSetup = false // Show registration again
        } catch {
            print("Failed to reset profile: \(error.localizedDescription)")
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
