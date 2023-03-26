//
//  ScoreView.swift
//  RoExamReward2023
//
//  Created by rolodestar on 2023/3/21.
//

import SwiftUI

struct ScoreView: View {
    @State public var examName: String?
    @State public var baseScore: Double = 0{
        didSet{
            createRewards()
        }
    }
    @State public var extensionScore: Double = 0
    {
        didSet{
            createRewards()
        }
    }
    @State public var isPay: Bool = false
    @State public var rewardMoney: Double = 0
    @State public var subjectID: UUID? = nil{
        didSet{
            createRewards()
        }
    }
    @State public var manualReward: Double = 0
    @State public var payedReward: Double = 0
    @State public var timeStamp: Date = Date.now
    @State var score: Score
    @EnvironmentObject var database: DatabaseStore
    @Environment(\.presentationMode) var presentationMode
    func createRewards(){
        let automaticReward = database.calReward(with: baseScore, extensionScore: extensionScore, by: subjectID)
        if manualReward == rewardMoney{
            manualReward = automaticReward
        }
        self.rewardMoney = automaticReward
        
    }
    var body: some View {
        VStack(alignment: HorizontalAlignment.leading,spacing: 15){
//            if draft.id != nil{
//                Text("编号：\n\(draft.id!.uuidString)")
//            }else{
//                Text("编号：无编号")
//            }
            Group{
                StringEditView(origin: $examName, title: "考试科目：")
                DoubleEditView(origin: $baseScore ,title: "基础部分得分")
                DoubleEditView(origin: $extensionScore, title: "拓展部分得分")
                Toggle(isOn: $isPay) {
                    Text("是否已支付")
                }
                DoubleEditView(origin: $rewardMoney, title: "自动计算奖励总金额（元）")
                DoubleEditView(origin: $manualReward, title: "手动设置奖励总金额（元）")
                DoubleEditView(origin: $payedReward, title: "已支付奖励总金额（元）")
            }
            database.createSubjectPickerView(selection: $subjectID)
            database.createSubjectRewardView(by: subjectID)
            DatePicker("考试时间", selection: $timeStamp,displayedComponents: .date)
            
                .padding(.bottom,40)
            
           
            HStack{
                Spacer()
                Button("自动计算奖励") {
                    
                    createRewards()
                        
                   
                }
                Spacer()
                Button("修改并自动计算奖励") {
                    /*
                     @NSManaged public var baseScore: Double
                     @NSManaged public var extensionScore: Double
                     @NSManaged public var id: UUID?
                     @NSManaged public var isPay: Bool
                     @NSManaged public var rewardMoney: Double
                     @NSManaged public var subjectID: UUID?
                     @NSManaged public var timeStamp: Date?
                     @NSManaged public var examName: String?
                     
                     */
//                        let score = Score(context: database.viewContext)
//                        score.id = UUID()
                    createRewards()
//                        let score = Score(context: database.viewContext)
                        score.id = UUID()
                        score.examName = examName
                        score.baseScore = baseScore
                        score.extensionScore = extensionScore
                        score.isPay = isPay
                        score.rewardMoney = rewardMoney
                    score.manualReward = manualReward
                    if isPay{
                        score.payedReward = manualReward
                    }else{
                        score.payedReward = payedReward
                    }
                        score.subjectID = subjectID
                        score.timeStamp = timeStamp
                   
                        database.saveAllToDatabase()
                        database.loadScores()
                   
//                    do{
//                        try database.viewContext.save()
//                    }catch{
//                        print(error.localizedDescription)
//                    }
//                    database.appendSubject(by: draft)
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                Button("修改") {
                    /*
                     @NSManaged public var baseScore: Double
                     @NSManaged public var extensionScore: Double
                     @NSManaged public var id: UUID?
                     @NSManaged public var isPay: Bool
                     @NSManaged public var rewardMoney: Double
                     @NSManaged public var subjectID: UUID?
                     @NSManaged public var timeStamp: Date?
                     @NSManaged public var examName: String?
                     
                     */
//                        let score = Score(context: database.viewContext)
//                        score.id = UUID()
//                    createRewards()
//                    createRewards()
//                        let score = Score(context: database.viewContext)
                        score.id = UUID()
                        score.examName = examName
                        score.baseScore = baseScore
                        score.extensionScore = extensionScore
                        score.isPay = isPay
                        score.rewardMoney = rewardMoney
                    score.manualReward = manualReward
                    if isPay{
                        score.payedReward = manualReward
                    }else{
                        score.payedReward = payedReward
                    }
                        score.subjectID = subjectID
                        score.timeStamp = timeStamp
                   
                        database.saveAllToDatabase()
                        database.loadScores()
                   
//                    do{
//                        try database.viewContext.save()
//                    }catch{
//                        print(error.localizedDescription)
//                    }
//                    database.appendSubject(by: draft)
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                
                Button("取消"){
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
            }
            Spacer()//.padding(.bottom,40)
//            Spacer()
            
        }
        .onAppear(){
            rewardMoney = score.rewardMoney
            extensionScore = score.extensionScore
            baseScore = score.baseScore
            subjectID = score.subjectID
            isPay  = score.isPay
            examName = score.examName
            
            
           
            manualReward = score.manualReward
            payedReward = score.payedReward
                score.subjectID = subjectID
                score.timeStamp = timeStamp
           
                database.saveAllToDatabase()
                database.loadScores()
            
            timeStamp = score.timeStamp ?? Date.now
        }
        .onDisappear(){
//             PersistenceController.shared.container.viewContext.delete(draft)
            
        }
        .padding()
    }
}
//
//struct ScoreView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScoreView(, score: <#Score#>)
//    }
//}
