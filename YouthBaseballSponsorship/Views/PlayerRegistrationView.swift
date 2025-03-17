//
//  PlayerRegistrationView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 3/7/25.
//

import SwiftUI
import PhotosUI

struct PlayerRegistrationView: View {
    @State private var name: String = ""
    @State private var position: String = ""
    @State private var team: String = ""
    @State private var fundingGoal: Double = 500.0
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false

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

                Button(action: savePlayerProfile) {
                    Text("Complete Registration")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Player Registration")
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }

    private func savePlayerProfile() {
        // Save player data locally or send to backend
        print("Player Registered: \(name), Position: \(position), Goal: $\(fundingGoal)")
    }
}
