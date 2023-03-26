//
//  RewardsView.swift
//  RoExamReward2023
//
//  Created by rolodestar on 2023/3/26.
//

import SwiftUI

struct RewardsView: View {
    @EnvironmentObject var database: DatabaseStore
    var body: some View {
        if(database.scores.count > 0){
            ZStack(alignment:.topLeading){
                
                RoundedRectangle(cornerRadius: 12)
                
                    .foregroundColor(.green)
                    .frame(height: 180)
                
                VStack(alignment: .leading,spacing: 15){
                    HStack(alignment: .center){
                        Image( "reward")
                            .resizable()
                            .frame(width: 80,height: 80)
                            .aspectRatio(contentMode: .fit)
                        VStack(alignment:.leading){
                            Text(database.rewardTimePercent)
                                .font(.title2)
                                .foregroundColor(.primary.opacity(1))
                            Text("总奖励金额:\(database.allReward.floatView)元")
                                .font(.title3)
                                .foregroundColor(.primary.opacity(1))
                            
                            
                            Text("已兑付金额:\(database.payedReward.floatView)元")
                                .font(.body)
                                .foregroundColor(.secondary.opacity(1))
                            
                            
                        }.padding(10)
                        
                        Spacer()
                    }
                    HStack(alignment:.center){
                        Text("存款:\(database.notPayedReward.floatView)元")
                            .font(.largeTitle)
                            .foregroundColor(.primary.opacity(1))
                        Spacer()
                        Image("pay")
                            .resizable()
                            .frame(width: 25,height: 25)
                            .aspectRatio( contentMode: .fit)
                            .onTapGesture {
                                database.path.append(DatabaseStore.PathEnum.viewPay)
                            }
                    }
                }.padding()
            }
        }
        else{
            VStack{
                Text("没有成绩数据")
                    .font(.largeTitle)
            }
        }
    }
}

struct RewardsView_Previews: PreviewProvider {
    static var previews: some View {
        RewardsView()
    }
}
