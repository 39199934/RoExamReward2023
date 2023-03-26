//
//  AppendNewScoreView.swift
//  RoExamReward2023
//
//  Created by rolodestar on 2023/3/21.
//



import SwiftUI

struct AppendNewScoreView: View {
    @State public var examName: String = ""
    @State public var baseScore: Double = 0
    //    {
    //        didSet{
    //            createRewards()
    //        }
    //    }
    @State public var extensionScore: Double = 0
    //    {
    //        didSet{
    //            createRewards()
    //        }
    //    }
    @State public var isPay: Bool = false
    @State public var rewardMoney: Double = 0
    @State public var subjectID: UUID? = nil
    //    {
    //        didSet{
    //            createRewards()
    //        }
    //    }
    @State public var manualReward: Double = 0
    @State public var payedReward: Double = 0
    @State public var timeStamp: Date = Date.now
    @EnvironmentObject var database: DatabaseStore
    @Environment(\.presentationMode) var presentationMode
    
    
    func createRewards(){
        let automaticReward = database.calReward(with: baseScore, extensionScore: extensionScore, by: subjectID)
        if manualReward == rewardMoney{
            manualReward = automaticReward
        }else if manualReward == 0 && automaticReward > 0{
            manualReward = automaticReward
        }
        rewardMoney = automaticReward
        
    }
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        //        formatter.timeStyle = .none
        return formatter
    }()
    private let doubleFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    var body: some View {
        ScrollView{
            VStack(alignment: HorizontalAlignment.leading,spacing: 15){
                Group{
                    Group{
                        Text("考试科目：")
                        TextField("考试科目：", text: $examName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    Group{
                        Group{
                            Text("基础部分得分：")
                            TextField("基础部分得分", value: $baseScore, formatter: doubleFormatter)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .onChange(of: baseScore) { newValue in
                                    createRewards()
                                }
                            #if os(iOS)
                                .keyboardType(UIKit.UIKeyboardType.decimalPad)
                            #endif
                            
                        }
                        Group{
                            Text("拓展部分得分：")
                            TextField("拓展部分得分", value: $extensionScore, formatter: doubleFormatter)
                                .onChange(of: extensionScore) { newValue in
                                    createRewards()
                                }
                                .textFieldStyle(RoundedBorderTextFieldStyle())
#if os(iOS)
    .keyboardType(UIKit.UIKeyboardType.decimalPad)
#endif
                        }
                        Group{
                            HStack{
                                Text("自动计算应得奖励：")
                                Text("\(rewardMoney.floatView)")
                            }
                        }
                    }
                    Group{
                        Text("手动设置奖励总金额（元）：")
                        TextField("手动设置奖励总金额（元）", value: $manualReward, formatter: doubleFormatter)
                        //                        .onChange(of: score.extensionScore) { newValue in
                        //                            createRewards()
                        //                        }
                            .textFieldStyle(RoundedBorderTextFieldStyle())
#if os(iOS)
                            .keyboardType(UIKit.UIKeyboardType.decimalPad)
#endif
                    }
                    Group{
                        HStack{
                            Text("已支付奖励总金额（元）：")
                            //                        Text("\(score.payedReward.floatView)")
                            TextField("已支付奖励总金额（元Ω", value: $payedReward, formatter: doubleFormatter)
                            //                        .onChange(of: score.extensionScore) { newValue in
                            //                            createRewards()
                            //                        }
                                .textFieldStyle(RoundedBorderTextFieldStyle())
#if os(iOS)
    .keyboardType(UIKit.UIKeyboardType.decimalPad)
#endif
                        }
                    }
                }
                Group{
                    Toggle(isOn: $isPay) {
                        Text("是否已全部支付")
                    }.onChange(of: isPay) { newValue in
                        if newValue{
                            payedReward = manualReward
                        }else{
                            payedReward = 0
                            
                        }
                    }
                    database.createSubjectPickerView(selection: $subjectID)
                        .onChange(of: subjectID) { newValue in
                            createRewards()
                        }
                    database.createSubjectRewardView(by: subjectID)
                    DatePicker("考试时间", selection: $timeStamp,displayedComponents: .date)
                    
                        .padding(.bottom,40)
                    
                }
                Group{
                    HStack{
                        Spacer()
                        Button("自动计算奖励") {
                            createRewards()
                        }
                        Spacer()
                        Button("添加") {
                            
                            createRewards()
                            let score = Score(context: database.viewContext)
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
                
            }
        }
        .navigationBarTitle("添加新成绩")
        .onAppear(){
            timeStamp =  Date.now
            if examName.isEmpty{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyyMMdd"
                let dateString = dateFormatter.string(from: timeStamp)
                let autoName = "\(dateString)考试"
                examName = autoName
            }
            //            examName = score.examName ?? "未设置名称"
        }
        .padding()
    }
}

struct AppendNewScoreView_Previews: PreviewProvider {
    static var previews: some View {
        AppendNewScoreView()
    }
}
