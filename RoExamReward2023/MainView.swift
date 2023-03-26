//
//  MainView.swift
//  RoExamReward2023
//
//  Created by rolodestar on 2023/3/21.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var database:DatabaseStore
    var body: some View {
        VStack{
            NavigationView{
                NavigationStack(path: $database.path) {
                    VStack(alignment: .leading){
//                        Text("总览")
//                            .font(.largeTitle)
//                            .foregroundColor(.primary)
                        ScoresBarMarkView()
                            .onTapGesture {
                                database.path.append(DatabaseStore.PathEnum.viewMark)
                            }
                        HStack{
                            ZStack(alignment: .topLeading){
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.red)
                                    .frame(height: 100)
                                VStack(alignment: .leading){
                                    Image("subject")
                                        .resizable()
                                        .frame(width: 30,height: 30)
                                        .aspectRatio(contentMode: .fit)
                                    Text("\(database.subjectExamRewards.count)个科目")
                                        .font(.title3)
                                }.padding()
                            
                            }
                            .onTapGesture {
                                database.path.append(DatabaseStore.PathEnum.viewSubjects)
                            }
                            ZStack(alignment: .topLeading){
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.green)
                                    .frame(height: 100)
                                VStack(alignment: .leading){
                                    Image("exam")
                                        .resizable()
                                        .frame(width: 30,height: 30)
                                        .aspectRatio(contentMode: .fit)
                                    Text("\(database.scores.count)个成绩")
                                        .font(.title3)
                                }.padding()
                            } .onTapGesture {
                                database.path.append(DatabaseStore.PathEnum.viewScores)
                            }
                        }
                        
                        RewardsView()
                        
                            .padding([.top,.bottom],10)
                        
                        
                        
                            .navigationDestination(for: DatabaseStore.PathEnum.self, destination: { pathEnum in
                                switch pathEnum{
                                case .appendSubject:
                                    AppendNewSubjectView()
                                case .viewSubject(let subId):
                                    if let subject = database.getSubject(by: subId){
                                        database.createSubjectView(by: subject)
                                    }else{
                                        Text("no find subject")
                                    }
                                    
                                case .viewScore(let scoreId):
                                    if let index = database.getScoreIndex(by: scoreId){
                                        ScoreShowAndEditView(score: $database.scores[index])
//                                        database.createScoreView(by: score)
                                    }else{
                                        Text("no find subject")
                                    }
                                    
                                case .viewSubjects:
                                    SubjectsView()
                                case .viewScores:
                                    ScoresView()
                                case .appendScore:
//                                    if database.scoreDraft == nil{
//                                        database.scoreDraft = Score(context: database.viewContext)
//                                        ScoreShowAndEditView(score: $database.scoreDraft!)
//                                    }
                                    AppendNewScoreView()
                                case .viewMark:
                                    ScoresBarMarkView()
                                        .padding()
                                case .viewPay:
                                    PayView()
                                        .padding()
                                }
                            })
                        Spacer()
                    }
//                    .background(.gray)
                        .padding()
                        .navigationTitle("总览")
                }
            }
        }
        //.background(.gray)
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(DatabaseStore())
    }
}
extension Double{
    var floatView: String{
        return String(format: "%.2f", self)
    }
}
