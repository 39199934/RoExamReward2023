//
//  ScoresListItemView.swift
//  RoExamReward2023
//
//  Created by rolodestar on 2023/3/26.
//

import SwiftUI

struct ScoresListItemView: View {
    @EnvironmentObject var database: DatabaseStore
    var score: Score
    var body: some View {
        VStack(alignment: .leading,spacing: 5){
            
            Text("\(score.examName ?? "未命名科目")")
                .font(.title3)
                .foregroundColor(.blue)
            Text("总分：\(score.baseScore + score.extensionScore)")
                .font(.body)
                .foregroundColor(.primary)
            
            Text("总未付金额\((score.manualReward - score.payedReward).floatView)")
                .font(.body)
                .foregroundColor(.primary)
            Text("总应付金额\(score.manualReward.floatView)")
                .font(.body)
                .foregroundColor(.secondary)
//                .navigationTitle("\(score.examName ?? "未命名科目")")
            
            
            
        }
//        .padding([.bottom],10)
        .onTapGesture {
            if let id = score.id{
                database.path.append(DatabaseStore.PathEnum.viewScore(scoreId:  id))
            }
        }
    }
}
//
//struct ScoresListItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScoresListItemView(score: Score())
//            .environmentObject(DatabaseStore())
//    }
//}
