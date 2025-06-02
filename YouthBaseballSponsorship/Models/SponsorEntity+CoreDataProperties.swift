//
//  SponsorEntity+CoreDataProperties.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 5/14/25.
//
//

import Foundation
import CoreData

extension SponsorEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SponsorEntity> {
        return NSFetchRequest<SponsorEntity>(entityName: "SponsorEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var organization: String?

}

extension SponsorEntity : Identifiable {

}
