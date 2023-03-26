//
//  Score+CoreDataProperties.swift
//  RoExamReward2023
//
//  Created by rolodestar on 2023/3/24.
//
//

import Foundation
import CoreData


extension Score {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Score> {
        return NSFetchRequest<Score>(entityName: "Score")
    }

    @NSManaged public var baseScore: Double
    @NSManaged public var examName: String?
    @NSManaged public var extensionScore: Double
    @NSManaged public var id: UUID?
    @NSManaged public var isPay: Bool
    @NSManaged public var rewardMoney: Double
    @NSManaged public var subjectID: UUID?
    @NSManaged public var timeStamp: Date?
    @NSManaged public var manualReward: Double
    @NSManaged public var payedReward: Double

}

extension Score : Identifiable {

   
}
