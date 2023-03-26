//
//  SubjectExamReward+CoreDataProperties.swift
//  RoExamReward2023
//
//  Created by rolodestar on 2023/3/20.
//
//

import Foundation
import CoreData


extension SubjectExamReward {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubjectExamReward> {
        return NSFetchRequest<SubjectExamReward>(entityName: "SubjectExamReward")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var subjectName: String?
    @NSManaged public var baseAllScore: Double
    @NSManaged public var baseScoreRewardLine: Double
    @NSManaged public var baseScoreMoneyPerScore: Double
    @NSManaged public var extensionAllScore: Double
    @NSManaged public var extensionScoreRewardLine: Double
    @NSManaged public var extensionScoreMoneyPerScore: Double

}

extension SubjectExamReward : Identifiable {

}
