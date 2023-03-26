//
//  ExamScoreProtocol.swift
//  RoExamReward2023
//
//  Created by rolodestar on 2023/3/20.
//

import Foundation

protocol ExamScoreProtocol{
    var examSubject: String{get set}
    var date: Date {get set}
    
}
protocol SubjectProtocol{
    var name: String{get set}
    
    
}
protocol ScoreProtocol{
    var baseScore: Double{get set}
    var extensionScore: Double{get set}
}

protocol RewardProtocol{
    func rewardsCalculation() -> Double
}
