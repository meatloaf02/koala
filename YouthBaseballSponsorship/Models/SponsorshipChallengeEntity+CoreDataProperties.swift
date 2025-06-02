//
//  SponsorshipChallengeEntity+CoreDataProperties.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 6/2/25.
//
//

import Foundation
import CoreData


extension SponsorshipChallengeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SponsorshipChallengeEntity> {
        return NSFetchRequest<SponsorshipChallengeEntity>(entityName: "SponsorshipChallengeEntity")
    }

    @NSManaged public var amountPerStat: Double
    @NSManaged public var deadline: Date?
    @NSManaged public var eventId: UUID?
    @NSManaged public var goalDescription: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isClosed: Bool
    @NSManaged public var isPaid: Bool
    @NSManaged public var isRecurring: Bool
    @NSManaged public var maxPledge: Double
    @NSManaged public var notes: String?
    @NSManaged public var playerId: UUID?
    @NSManaged public var pledgeAmount: Double
    @NSManaged public var sponsorName: String?
    @NSManaged public var statImageName: String?
    @NSManaged public var statType: String?
    @NSManaged public var maxPledgeAmount: Double

}

extension SponsorshipChallengeEntity : Identifiable {

}
