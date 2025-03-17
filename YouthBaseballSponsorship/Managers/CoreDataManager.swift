//
//  CoreDataManager.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 3/7/25.
//

import CoreData
import SwiftUI

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "PlayerDataModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data store: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save Core Data: \(error)")
            }
        }
    }

    func addSamplePlayers() {
        let context = persistentContainer.viewContext
        
        // Check if players already exist to prevent duplicates
        let fetchRequest: NSFetchRequest<PlayerEntity> = PlayerEntity.fetchRequest()
        
        do {
            let existingPlayers = try context.fetch(fetchRequest)
            if !existingPlayers.isEmpty {
                print("Sample players already exist, skipping insertion.")
                return
            }
        } catch {
            print("Failed to fetch existing players: \(error.localizedDescription)")
        }

        let players = [
            ("Jake Martinez", "Pitcher", "ERA: 2.8, 50 Strikeouts", "player1", 1000.0),
            ("Chris Johnson", "Batter", "AVG: .320, 5 HR", "player2", 800.0),
            ("Alex Smith", "Catcher", "Fielding %: .985", "player3", 1200.0)
        ]

        for player in players {
            let newPlayer = PlayerEntity(context: context)
            newPlayer.id = UUID()
            newPlayer.name = player.0
            newPlayer.position = player.1
            newPlayer.stats = player.2
            newPlayer.profileImage = player.3
            newPlayer.fundingGoal = player.4 // Ensure fundingGoal is stored as Double
        }

        saveContext()
        print("Sample players added successfully.")
    }

    func fetchPlayers() -> [PlayerEntity] {
        let fetchRequest: NSFetchRequest<PlayerEntity> = PlayerEntity.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch players: \(error)")
            return []
        }
    }

    func deletePlayer(_ player: PlayerEntity) {
        context.delete(player)
        saveContext()
    }
}
