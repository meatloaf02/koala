//
//  PlayerEntity+CoreDataProperties.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 3/7/25.
//
//

import Foundation
import CoreData


extension YouthBaseballSponsorship.PlayerEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayerEntity> {
        return NSFetchRequest<PlayerEntity>(entityName: "PlayerEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var position: String?
    @NSManaged public var stats: String?
    @NSManaged public var profileImage: String?
    @NSManaged public var fundingGoal: Double
    @NSManaged public var sponsorName: String?

}

extension PlayerEntity : Identifiable {

}
