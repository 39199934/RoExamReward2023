//
//  ScoresBarMarkView.swift
//  RoExamReward2023
//
//  Created by rolodestar on 2023/3/26.
//

import SwiftUI
import Charts
struct ScoresBarMarkView: View {
    @EnvironmentObject var database: DatabaseStore
    var body: some View {
        if(database.scores.count > 0){
            Chart{
                ForEach(database.scores,id: \.id!){score in
                    PointMark(x:  .value("日期", score.timeStamp ?? Date.now),y: .value("分数", score.baseScore + score.extensionScore))
                        .foregroundStyle(by: .value("是否奖励", score.manualReward > 0 ? "有奖": "无奖"))
                        .symbol(by: .value("科目", database.getSubject(by: score.subjectID ?? UUID() )?.subjectName ?? "其他科目"))
                    LineMark(x:  .value("日期", score.timeStamp ?? Date.now),y: .value("分数", score.baseScore + score.extensionScore),series: .value("科目", database.getSubject(by: score.subjectID ?? UUID() )?.subjectName ?? "其他科目"))
                        .foregroundStyle(by: .value("科目", database.getSubject(by: score.subjectID ?? UUID() )?.subjectName ?? "其他科目"))
                    
                    
                }
            }
            
            //        .navigationTitle("成绩分析表")
        }
    }
}

struct ScoresBarMarkView_Previews: PreviewProvider {
    static var previews: some View {
        ScoresBarMarkView()
            .environmentObject(DatabaseStore())
    }
}
