//
//  LoginView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 5/14/25.
//
import SwiftUI
import CoreData

struct LoginView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @AppStorage("currentUserRole") private var currentUserRole: String = ""
    @AppStorage("currentPlayerId") private var currentPlayerId: String = ""
    @AppStorage("hasLoggedIn") private var hasLoggedIn: Bool = false
    @AppStorage("sponsorName") private var sponsorName: String = ""

    @State private var name: String = ""
    @State private var roleSelection: String = "player"
    @State private var loginFailed: Bool = false

    let roles = ["player", "coach", "sponsor"]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Login")) {
                    Picker("Role", selection: $roleSelection) {
                        ForEach(roles, id: \.self) { role in
                            Text(role.capitalized)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    TextField("Name", text: $name)
                        .autocapitalization(.words)

                    Button("Log In") {
                        login()
                    }
                }

                if loginFailed {
                    Section {
                        Text("No matching user found. Please check your name or role.")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("User Login")
        }
    }

    private func login() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }

        switch roleSelection {
        case "player":
            let request: NSFetchRequest<PlayerEntity> = PlayerEntity.fetchRequest()
            request.predicate = NSPredicate(format: "name ==[c] %@", trimmedName)
            request.fetchLimit = 1

            if let player = try? viewContext.fetch(request).first {
                currentPlayerId = player.id?.uuidString ?? ""
                currentUserRole = "player"
                hasLoggedIn = true
                loginFailed = false
            } else {
                loginFailed = true
            }
        case "sponsor":
                    let request: NSFetchRequest<SponsorEntity> = SponsorEntity.fetchRequest()
                    request.predicate = NSPredicate(format: "name ==[c] %@", trimmedName)
                    request.fetchLimit = 1

                    if let sponsor = try? viewContext.fetch(request).first {
                        sponsorName = sponsor.name ?? ""
                        currentUserRole = "sponsor"
                        hasLoggedIn = true
                        loginFailed = false
                    } else {
                        loginFailed = true
                    }
        
        default:
            loginFailed = true
        }
    }
}
