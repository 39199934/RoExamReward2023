//
//  DatabaseStore.swift
//  RoExamReward2023
//
//  Created by rolodestar on 2023/3/20.
//

import Foundation
import CoreData
import SwiftUI

class DatabaseStore: ObservableObject{
    @Published var subjectExamRewards: [SubjectExamReward]
    
    @Published var scores: [Score]
    {
        didSet{
            calAllReward()
        }
    }
    @Published var path: NavigationPath
    @Published var allReward: Double
    @Published var payedReward: Double
    @Published var notPayedReward: Double
    @Published var rewardTimePercent: String
    @Published var paidChange: Double
    @Published var scoreDraft: Score?
    
    var paidChangeFileURL :URL
    
    //    @Published var subjectExamRewardDraft: SubjectExamReward
    enum PathEnum: Codable,Hashable{
        case appendSubject,viewSubject(subjectId: UUID),viewSubjects,viewScores,appendScore,viewScore(scoreId: UUID),viewMark,viewPay
    }
    var viewContext: NSManagedObjectContext
    init(){
        subjectExamRewards = []
        scores = []
        path = NavigationPath()
        viewContext  = PersistenceController.shared.container.viewContext
        paidChangeFileURL = URL(filePath: NSHomeDirectory() + "/Documents/paidChange.data")
        //        subjectExamRewardDraft = SubjectExamReward(context: viewContext)
        allReward = 0
        payedReward = 0
        notPayedReward = 0
        paidChange = 0
        rewardTimePercent = ""
        loadSubjectExamRewards()
        loadScores()
        loadPaidChange()
    }
    func payPaidChange(money: Double) -> String{
        loadPaidChange()
        calAllReward()
        paidChange += money
        if (paidChange > notPayedReward){
            return "余额不足，支付失败"
        }else{
            
            let result = checkNotPayRewardForPaidChange(money: paidChange)
            if(result.0 == paidChange){
                return "不足以从未兑付金额中抵扣，直接支付"
            }else {
                paidChange = result.0
                return "已从以下项目支付金额，\(result.1)"
            }
//            paidChange += money
//            payedReward += money
//            savePaidChange()
//            return "支付成功"
        }
    }
    func checkNotPayRewardForPaidChange(money: Double) -> (Double,String){
        var resultMoney: Double = money
        var resultString: String = ""
        
            for score in scores {
                if !score.isPay{
                    if(resultMoney >= score.rewardMoney){
                        score.isPay = true
                        resultMoney -= score.rewardMoney
                        resultString += "从\(score.examName ?? score.id!.uuidString)考试未支中支付金额\(score.rewardMoney)元  "
                        if resultMoney <= 0{
                            saveAllToDatabase()
                            return (resultMoney,resultString)
                        }
                        else{
                            continue
                        }
                    }
                }
            }
        return (resultMoney,resultString)
        
    }
    func savePaidChange(){
        let str = paidChange.floatView
        do{
            
            try str.write(to: paidChangeFileURL,atomically: true, encoding: String.Encoding.utf8)
        }catch{
            print(error.localizedDescription)
        }
    }
    func loadPaidChange(){
        
        
        do{
            let str = try String(contentsOfFile: paidChangeFileURL.absoluteString)
            paidChange = Double(str) ?? 0
//            calAllReward()
            
        }catch{
            print(error.localizedDescription)
        }
    }
    func calAllReward(){
        allReward = 0
        payedReward = 0
        notPayedReward = 0
        var rewardTime: Double = 0
        var allTime: Double = 0
        for score in scores{
            allReward += score.manualReward
            payedReward += score.payedReward
            notPayedReward += score.manualReward - score.payedReward
            allTime += 1
            if score.manualReward > 0{
                rewardTime += 1
            }
//            if score.isPay{
//                payedReward += score.rewardMoney
//            }else{
//                notPayedReward += score.rewardMoney
//            }
//            allReward += score.rewardMoney
        }
        let percent = rewardTime / allTime * 100
        rewardTimePercent = "获奖率\(percent.floatView)%"
    }
    func loadSubjectExamRewards(){
        do{
            let request = NSFetchRequest<SubjectExamReward>(entityName: "SubjectExamReward")
            self.subjectExamRewards = try viewContext.fetch(request)
        }catch{
            print(error.localizedDescription)
        }
        
    }
    func loadScores(){
        do{
            let request = NSFetchRequest<Score>(entityName: "Score")
            self.scores = try viewContext.fetch(request)
        }catch{
            print(error.localizedDescription)
        }
        
    }
}
extension DatabaseStore{
    func appendSubject(by subject: SubjectExamReward){
        do{
            let sub = SubjectExamReward(context: viewContext)
            sub.id = subject.id
            sub.subjectName = subject.subjectName
            sub.baseAllScore = subject.baseAllScore
            sub.baseScoreRewardLine = subject.baseScoreRewardLine
            sub.baseScoreMoneyPerScore = subject.baseScoreMoneyPerScore
            sub.extensionAllScore = subject.extensionAllScore
            sub.extensionScoreRewardLine = subject.extensionScoreRewardLine
            sub.extensionScoreMoneyPerScore = subject.extensionScoreMoneyPerScore
            try viewContext.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    func saveAllToDatabase(){
        do{
            try viewContext.save()
            loadScores()
            loadSubjectExamRewards()
            calAllReward()
            
        }catch{
            print(error.localizedDescription)
        }
    }
    func clearSubjects(){
        for item in subjectExamRewards{
            viewContext.delete(item)
            
        }
        saveAllToDatabase()
        
    }
    func clearScores(){
        for item in scores{
            viewContext.delete(item)
            
        }
        saveAllToDatabase()
    }
    func getSubject(by id: UUID) -> SubjectExamReward?{
        for item in subjectExamRewards{
            if item.id == id{
                return item
                
            }
        }
        return nil
    }
    func getScore(by id: UUID) -> Score?{
        for item in scores{
            if item.id == id{
                return item
                
            }
        }
        return nil
    }
    func getScoreIndex(by id: UUID) -> Int?{
        for index in 0..<scores.count{
            
            if scores[index].id == id{
                return index
                
            }
        }
        return nil
    }
    func calReward(with baseScore: Double,extensionScore:Double,by subjectID: UUID?) -> Double{
        if let subject = getSubject(by: subjectID ?? UUID()){
            let base = (baseScore - subject.baseScoreRewardLine) * subject.baseScoreMoneyPerScore
            let exten = (extensionScore - subject.extensionScoreRewardLine) * subject.extensionScoreMoneyPerScore
            
            let all = base + exten
            if all < 0 {
                return 0
            }
            return all
            
        }
        return 0
    }
    func getFirstSubjectId() -> UUID?{
        return self.subjectExamRewards.first?.id
    }
    func pay(money: Double){
        if money > allReward{
            return
        }else{
            var tempPayMoney = money
            for score in scores{
                let lastMoney =  score.manualReward - score.payedReward
                if lastMoney > 0 && lastMoney >= tempPayMoney{
                    score.payedReward += tempPayMoney
                    tempPayMoney = 0
                    
                }else if lastMoney > 0 && lastMoney < tempPayMoney{
                    score.payedReward += lastMoney
                    tempPayMoney -= lastMoney
                    
                }
                if score.manualReward - score.payedReward == 0 {
                    score.isPay = true
                }
                if tempPayMoney == 0{
                    break
                }
                
            }
            saveAllToDatabase()
        }
    }
}
extension DatabaseStore{
    @ViewBuilder func createSubjectView(by subject: SubjectExamReward) -> some View{
        SubjectView(subject: subject)
    }
    @ViewBuilder func createSubjectRewardView(by subjectId: UUID?) -> some View{
        if subjectId == nil{
            Text("未获取奖励方案")
        }
        else if let subject = getSubject(by: subjectId!)
        {
            Text("奖励方案名称：\(subject.subjectName ?? "无")\n基础部分超出\(String(format: "%.0f", subject.baseScoreRewardLine))分部分，每分\(String(format: "%.2f",subject.baseScoreMoneyPerScore ))元，扩展卷超出\(String(format: "%.0f", subject.extensionScoreRewardLine))分部分，每分\(String(format: "%.2f", subject.extensionScoreMoneyPerScore))元")
        }else{
            Text("未获取奖励方案")
        }
    }
    @ViewBuilder func createScoreView(by score: Score) -> some View{
        ScoreView(score: score)
    }
    //    @ViewBuilder func createSubjectView(by subjectId: UUID) -> some View{
    //
    //       Text("not find subject")
    //    }
    func emptyHandel(ss:UUID?){
        
    }
    @ViewBuilder func createSubjectPickerView(selection: Binding<UUID?>) -> some View{
        
        if self.subjectExamRewards.count > 4{
            Picker("请选择科目", selection: selection) {
                ForEach(subjectExamRewards,id:\.id){ item in
                    Text("\(item.subjectName ?? "未命名科目")")
                        .tag(item.id)
                }
            }
//            .onChange(of: selection, perform: completionHandle ?? emptyHandel)
            
            .pickerStyle(DefaultPickerStyle() )
        }else{
            Picker("请选择科目", selection: selection) {
                ForEach(subjectExamRewards,id:\.id){ item in
                    Text("\(item.subjectName ?? "未命名科目")")
                        .tag(item.id)
                }
                
            }
            .pickerStyle(SegmentedPickerStyle())
            //        .pickerStyle(((self.subjectExamRewards.count > 4) ? DefaultPickerStyle() : SegmentedPickerStyle()))
        }
    }
}
