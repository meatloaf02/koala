//
//  GameEventEntity+CoreDataProperties.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 5/8/25.
//
//

import Foundation
import CoreData


extension GameEventEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameEventEntity> {
        return NSFetchRequest<GameEventEntity>(entityName: "GameEventEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var location: String?
    @NSManaged public var playerId: UUID?
    @NSManaged public var statsSubmitted: Bool
    @NSManaged public var statsImageName: String?

}

extension GameEventEntity : Identifiable {

}
