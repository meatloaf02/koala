//
//  TeamEntity+CoreDataProperties.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 5/27/25.
//
//

import Foundation
import CoreData


extension TeamEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TeamEntity> {
        return NSFetchRequest<TeamEntity>(entityName: "TeamEntity")
    }

    @NSManaged public var coachName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var logoImageName: String?
    @NSManaged public var name: String?
    @NSManaged public var players: NSObject?
    @NSManaged public var seasonStarted: Bool

}

extension TeamEntity : Identifiable {

}
