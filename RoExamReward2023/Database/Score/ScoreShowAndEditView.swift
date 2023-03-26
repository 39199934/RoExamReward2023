//
//  ScoreShowAndEditView.swift
//  RoExamReward2023
//
//  Created by rolodestar on 2023/3/24.
//

import SwiftUI
/*
 StringEditView(origin: $examName, title: "考试科目：")
 DoubleEditView(origin: $baseScore ,title: "基础部分得分")
 DoubleEditView(origin: $extensionScore, title: "拓展部分得分")
 Toggle(isOn: $isPay) {
 Text("是否已支付")
 }
 DoubleEditView(origin: $rewardMoney, title: "自动计算奖励总金额（元）")
 DoubleEditView(origin: $manualReward, title: "手动设置奖励总金额（元）")
 DoubleEditView(origin: $payedReward, title: "已支付奖励总金额（元）")
 */
struct ScoreShowAndEditView: View {
    @EnvironmentObject var database: DatabaseStore
    @Binding var score: Score
    @State var isEdit: Bool = false
    @State var timeStamp: Date = Date.now
    @State var examName: String = ""
    func createRewards(){
        let automaticReward = database.calReward(with: score.baseScore, extensionScore: score.extensionScore, by: score.subjectID)
        if score.manualReward == score.rewardMoney{
            score.manualReward = automaticReward
        }else if score.manualReward == 0 && automaticReward > 0{
            score.manualReward = automaticReward
        }
        score.rewardMoney = automaticReward
        
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
        VStack(alignment: .leading ){
            if !isEdit{
                Text(score.id?.uuidString ?? "无ID")
                
                
                Text("考试科目：\(score.examName ?? "未设置科目名称")")
                
                
                Text("基础部分得分：\(score.baseScore)")
                
                Text("拓展部分得分：\(score.extensionScore)")
                
                Text("自动计算应得奖励：\(score.rewardMoney.floatView)")
                
                Text("手动设置奖励总金额（元）：\(score.manualReward)")
                
                Text("已支付奖励总金额（元）：\(score.payedReward)")
                
                Text("\(score.isPay ? "已全部支付" : "未全部兑付")")
                //
                
                
                database.createSubjectRewardView(by: score.subjectID)
                Text("考试时间：\(score.timeStamp == nil ? Date.now : score.timeStamp!, formatter: itemFormatter)")
                
                
            }else{
                Section{
                    Text("考试科目：")
                    TextField("考试科目：", text: $examName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: examName) { newValue in
                            score.examName = examName
                        }
                    //                    .onChange(of: score.examName) { newValue in
                    //                        print(newValue)
                    //                    }
                }
                .padding(.bottom,10)
                Group{
                    Text("基础部分得分：")
                    TextField("基础部分得分", value: $score.baseScore, formatter: doubleFormatter)
                        .onChange(of: score.baseScore) { newValue in
                            createRewards()
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
#if os(iOS)
                            .keyboardType(UIKit.UIKeyboardType.decimalPad)
#endif
                }
                Group{
                    Text("拓展部分得分：")
                    TextField("拓展部分得分", value: $score.extensionScore, formatter: doubleFormatter)
                        .onChange(of: score.extensionScore) { newValue in
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
                        Text("\(score.rewardMoney.floatView)")
                    }
                }
                Group{
                    Text("手动设置奖励总金额（元）：")
                    TextField("手动设置奖励总金额（元）", value: $score.manualReward, formatter: doubleFormatter)
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
                        TextField("已支付奖励总金额（元Ω", value: $score.payedReward, formatter: doubleFormatter)
                        //                        .onChange(of: score.extensionScore) { newValue in
                        //                            createRewards()
                        //                        }
                            .textFieldStyle(RoundedBorderTextFieldStyle())
#if os(iOS)
                            .keyboardType(UIKit.UIKeyboardType.decimalPad)
#endif
                    }
                }
                Toggle(isOn: $score.isPay) {
                    Text("是否已全部支付")
                }.onChange(of: score.isPay) { newValue in
                    if newValue{
                        score.payedReward = score.manualReward
                    }else{
                        score.payedReward = 0
                        
                    }
                }
                database.createSubjectPickerView(selection: $score.subjectID)
                    .onChange(of: score.subjectID) { newValue in
                        createRewards()
                    }
                database.createSubjectRewardView(by: score.subjectID)
                DatePicker("考试时间", selection: $timeStamp ,displayedComponents: .date)
                    .onChange(of: timeStamp) { newValue in
                        score.timeStamp = newValue
                    }
                
                    .padding(.bottom,40)
            }
            
            /*
             
             }
             DoubleEditView(origin: $rewardMoney, title: "自动计算奖励总金额（元）")
             DoubleEditView(origin: $manualReward, title: "手动设置奖励总金额（元）")
             DoubleEditView(origin: $payedReward, title: "已支付奖励总金额（元）")
             */
            Spacer()
            
        }.toolbar {
            Image(systemName: "pencil")
                .resizable()
                .frame(width: 20, height: 20)
                .onTapGesture {
                    isEdit.toggle()
                }
        }
        .padding()
        .onAppear(){
            timeStamp = score.timeStamp != nil ? score.timeStamp! : Date.now
            if score.examName == nil{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyyMMdd"
                let dateString = dateFormatter.string(from: timeStamp)
                let autoName = "\(dateString)考试"
                score.examName = autoName
            }
            examName = score.examName ?? "未设置名称"
        }
        .onDisappear(){
            database.saveAllToDatabase()
//            database.calAllReward()
        }
    }
    class StringFormatter: Formatter{
        override func string(for obj: Any?) -> String? {
            if obj is String{
                return obj as? String
            }else{
                return nil
            }
        }
        override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
            return true
        }
    }
}
//
//struct ScoreShowAndEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScoreShowAndEditView()
//    }
//}
