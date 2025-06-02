//
//  WelcomeView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 3/17/25.
//
import SwiftUI
import CoreData

struct WelcomeView: View {
    @State private var navigateToLogin = false
    @State private var navigateToSignup = false
    @State private var showResetAlert = false

    // Reset mechanism
    @AppStorage("hasLoggedIn") private var hasLoggedIn = false
    @AppStorage("currentUserRole") private var currentUserRole = ""
    @AppStorage("currentPlayerId") private var currentPlayerId = ""
    @AppStorage("sponsorName") private var sponsorName = ""
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("Welcome to Youth Baseball Sponsorship")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                    .onTapGesture(count: 3) {
                        resetDemoState()
                    }

                Image("youth baseball")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 300, maxHeight: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .gray.opacity(0.4), radius: 8, x: 0, y: 4)
                    .padding(.horizontal)

                Text("Empowering players and connecting sponsors through performance-based pledges.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Button("Log In") {
                        withAnimation {
                            navigateToLogin = true
                        }
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Sign Up") {
                        withAnimation {
                            navigateToSignup = true
                        }
                    }
                    .buttonStyle(.bordered)

                    Spacer()
                }
                .navigationDestination(isPresented: $navigateToLogin) {
                    LoginView()
                }
                .navigationDestination(isPresented: $navigateToSignup) {
                    RoleSelectionView()
                }
        }
    }

    private func resetDemoState() {
        hasLoggedIn = false
        currentUserRole = ""
        currentPlayerId = ""
        sponsorName = ""
        showResetAlert = true

        deleteAllEntities(named: "PlayerEntity")
        deleteAllEntities(named: "SponsorshipChallengeEntity")
        deleteAllEntities(named: "GameEventEntity")
        deleteAllEntities(named: "TeamEntity")


        print("🔁 Demo state and Core Data reset.")
    }

    private func deleteAllEntities(named entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try viewContext.execute(deleteRequest)
            try viewContext.save()
        } catch {
            print("❌ Failed to delete \(entityName): \(error.localizedDescription)")
        }
    }
}
