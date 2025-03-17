//
//  SponsorshipView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 3/6/25.
//

import SwiftUI
import MessageUI
import CoreData



struct SponsorshipView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: PlayerEntity.entity(), sortDescriptors: []) var players: FetchedResults<YouthBaseballSponsorship.PlayerEntity>
    
    @State private var selectedPlayer: PlayerEntity?
    @State private var showingSponsorshipDetails = false
    
    var body: some View {
        NavigationView {
            List(players) { player in
                PlayerRow(player: player)
                    .onTapGesture {
                        selectedPlayer = player
                        showingSponsorshipDetails.toggle()
                    }
            }
            .navigationTitle("Sponsor a Player")
            .sheet(isPresented: $showingSponsorshipDetails) {
                if let player = selectedPlayer {
                    SponsorshipDetailsView(player: player)
                }
            }
        }
    }
}

// PlayerRow UI Component
struct PlayerRow: View {
    let player: PlayerEntity

    var body: some View {
        HStack {
            Image(player.profileImage)
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())

            VStack(alignment: .leading) {
                Text(player.name)
                    .font(.headline)
                Text(player.position)
                    .font(.subheadline)
                Text(player.stats)
                    .font(.caption)
            }
        }
        .padding()
    }
}

// Sponsorship Details View
struct SponsorshipDetailsView: View {
    let player: PlayerEntity
    
    @State private var sponsorshipAmount = 20.0
    @State private var isPerformanceBased = false
    @State private var showingMessageComposer = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(player.profileImage)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                
                Text(player.name)
                    .font(.title)
                
                Toggle("Performance-Based Sponsorship", isOn: $isPerformanceBased)
                    .padding()
                
                if isPerformanceBased {
                    Text("Pledge per home run, strikeout, etc.")
                        .font(.subheadline)
                } else {
                    Stepper(value: $sponsorshipAmount, in: 10...500, step: 10) {
                        Text("Amount: $\(Int(sponsorshipAmount))")
                    }
                    .padding()
                }
                
                // Sponsor Now Button - Opens Messages for Apple Cash Request
                Button(action: {
                    if MessageComposerView.canSendMessages() {
                        showingMessageComposer = true
                    } else {
                        print("Messages not available on this device")
                    }
                }) {
                    Text("Sponsor Now")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showingMessageComposer) {
                    MessageComposerView(amount: sponsorshipAmount, playerName: player.name)
                }
                
                // Apple Cash Payment Instructions
                VStack(alignment: .leading, spacing: 10) {
                    Text("How to Send Apple Cash:")
                        .font(.headline)
                    Text("1. Click the 'Sponsor Now' button.")
                    Text("2. An iMessage will open with a pre-filled message.")
                    Text("3. Send the Apple Cash payment in Messages.")
                    Text("4. Confirm the sponsorship in the app.")
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

                Spacer()
            }
            .navigationTitle("Sponsorship Details")
            .padding()
        }
    }
}

// Message Composer View
struct MessageComposerView: UIViewControllerRepresentable {
    let amount: Double
    let playerName: String
    
    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        var parent: MessageComposerView

        init(_ parent: MessageComposerView) {
            self.parent = parent
        }

        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            controller.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let messageVC = MFMessageComposeViewController()
        messageVC.messageComposeDelegate = context.coordinator
        messageVC.body = "Hey! I’d like to sponsor \(playerName) with $\(amount) using Apple Cash. Let’s make it happen!"
        return messageVC
    }

    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}

    static func canSendMessages() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
}
