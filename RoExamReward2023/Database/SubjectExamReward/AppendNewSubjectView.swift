//
//  AppendNewSubjectView.swift
//  RoExamReward2023
//
//  Created by rolodestar on 2023/3/20.
//

/*
 @NSManaged public var subjectName: String?
 @NSManaged public var baseAllScore: Double
 @NSManaged public var baseScoreRewardLine: Double
 @NSManaged public var baseScoreMoneyPerScore: Double
 @NSManaged public var extensionAllScore: Double
 @NSManaged public var extensionScoreRewardLine: Double
 @NSManaged public var extensionScoreMoneyPerScore: Double
 */

import SwiftUI

struct AppendNewSubjectView: View {
    @State public var subjectName: String?
    @State public var baseAllScore: Double = 0
    @State public var baseScoreRewardLine: Double = 0
    @State public var baseScoreMoneyPerScore: Double = 0
    @State public var extensionAllScore: Double = 0
    @State public var extensionScoreRewardLine: Double = 0
    @State public var extensionScoreMoneyPerScore: Double = 0
    @EnvironmentObject var database: DatabaseStore
    @Environment(\.presentationMode) var presentationMode
//    @State var draft: SubjectExamReward = SubjectExamReward() //SubjectExamReward(context: PersistenceController.shared.container.viewContext)
//    @State var draft: SubjectExamReward = {
//        let obj = SubjectExamReward(context: PersistenceController.shared.container.viewContext)
//        obj.id = UUID()
//        return obj
//    }()
    var body: some View {
        VStack(alignment: HorizontalAlignment.leading,spacing: 15){
//            if draft.id != nil{
//                Text("编号：\n\(draft.id!.uuidString)")
//            }else{
//                Text("编号：无编号")
//            }
            
            StringEditView(origin: $subjectName, title: "科目：")
            DoubleEditView(origin: $baseAllScore, title: "基础部分总分")
            DoubleEditView(origin: $baseScoreRewardLine, title: "基础部分奖励分数线")
            DoubleEditView(origin: $baseScoreMoneyPerScore, title: "基础部分超线每分奖励金额（元）")
            DoubleEditView(origin: $extensionAllScore, title: "拓展部分总分")
            DoubleEditView(origin: $extensionScoreRewardLine, title: "拓展部分奖励分数线")
            DoubleEditView(origin: $extensionScoreMoneyPerScore, title: "拓展部分超线每分奖励金额（元）")
                .padding(.bottom,40)
            
           
            HStack{
                Spacer()
                Button("添加") {
                    
                        let sub = SubjectExamReward(context: database.viewContext)
                        sub.id = UUID()
                        sub.subjectName = subjectName
                        sub.baseAllScore = baseAllScore
                        sub.baseScoreRewardLine = baseScoreRewardLine
                        sub.baseScoreMoneyPerScore = baseScoreMoneyPerScore
                        sub.extensionAllScore = extensionAllScore
                        sub.extensionScoreRewardLine = extensionScoreRewardLine
                        sub.extensionScoreMoneyPerScore = extensionScoreMoneyPerScore
                        database.saveAllToDatabase()
                        database.loadSubjectExamRewards()
                   
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
            
        }.onDisappear(){
//             PersistenceController.shared.container.viewContext.delete(draft)
            
        }
        .padding()
    }
}

struct AppendNewSubjectView_Previews: PreviewProvider {
    static var previews: some View {
        AppendNewSubjectView()
            .environmentObject(DatabaseStore())
    }
}
