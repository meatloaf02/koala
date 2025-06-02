//
//  CreateEventView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 5/8/25.
//
import SwiftUI
import CoreData

struct CreateEventView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("currentPlayerId") private var currentPlayerId: String = ""
    @State private var showSuccessMessage = false
    @State private var navigateToHome = false
    @AppStorage("hasRegistered") private var hasRegistered: Bool = false
    @AppStorage("hasLoggedIn") private var hasLoggedIn: Bool = false

    @State private var title: String = ""
    @State private var location: String = ""
    @State private var date: Date = Date()
    @State private var showConfirmation = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Event Info")) {
                    TextField("Event Title", text: $title)
                    TextField("Location", text: $location)
                    DatePicker("Date & Time", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }

                Section {
                    Button(action: saveEvent) {
                        Text("Create Event")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .navigationTitle("Create Game Event")
            .alert("Event Created!", isPresented: $showConfirmation) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Sponsors can now see this event.")
            }
        }
        .overlay(
            VStack {
                if showSuccessMessage {
                    Text("✅ Event Created!")
                        .font(.subheadline)
                        .padding()
                        .background(Color.green.opacity(0.85))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.top, 50)
                        .transition(.move(edge: .top))
                        .zIndex(1)
                }
                Spacer()
            }
        )
    }

    private func saveEvent() {
        guard let playerUUID = UUID(uuidString: currentPlayerId) else {
            print("Invalid player ID")
            return
        }

        let newEvent = GameEventEntity(context: viewContext)
        newEvent.id = UUID()
        newEvent.title = title
        newEvent.location = location
        newEvent.date = date
        newEvent.playerId = playerUUID
        newEvent.statsSubmitted = false

        do {
            try viewContext.save()
            showConfirmation = true
            hasRegistered = true
            showSuccessMessage = true
            // Delay before rerouting to PlayerHomeView via hasLoggedIn
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                hasLoggedIn = true
            }
        } catch {
            print("Failed to save event: \(error.localizedDescription)")
        }
    }
}
