//
//  SponsorRegistrationView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 4/29/25.
//
import SwiftUI

struct SponsorRegistrationView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var sponsorName: String = ""
    @State private var email: String = ""
    @State private var organization: String = ""
    @State private var navigateToHome = true
    @AppStorage("currentUserRole") private var currentUserRole: String = ""
    @AppStorage("hasRegistered") private var hasRegistered: Bool = false
    @AppStorage("hasLoggedIn") private var hasLoggedIn: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Your Info")) {
                    TextField("Full Name", text: $sponsorName)
                        .textContentType(.name)

                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)

                    TextField("Organization (optional)", text: $organization)
                }

                Section {
                    Button(action: {
                        // Simple validation
                        if !sponsorName.isEmpty && !email.isEmpty {
                            let newSponsor = SponsorEntity(context: viewContext)
                            newSponsor.id = UUID()
                            newSponsor.name = sponsorName
                            newSponsor.email = email
                            newSponsor.organization = organization

                            do {
                                try viewContext.save()
                                currentUserRole = "sponsor"
                                hasRegistered = true
                                hasLoggedIn = true
                            } catch {
                                print("Failed to save sponsor: \(error.localizedDescription)")
                            }
                        }
                    }) {
                        Text("Continue")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .navigationTitle("Sponsor Sign Up")
            }
        }
    }

