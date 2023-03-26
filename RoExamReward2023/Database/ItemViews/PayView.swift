//
//  PayView.swift
//  RoExamReward2023
//
//  Created by rolodestar on 2023/3/26.
//

import SwiftUI

struct PayView: View {
    @EnvironmentObject var database: DatabaseStore
    @Environment(\.presentationMode) var presentationMode
    @State var payMoney: Double = 0
    @State var isShowOverMoney: Bool = false
    private let doubleFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Image("pay")
                    .resizable()
                    .frame(width: 50,height: 50)
                    .aspectRatio( contentMode: .fit)
                Text("支取存款")
                    .font(.largeTitle)
                    .foregroundColor(.red.opacity(1))
            }
            Text("可用存款:\(database.notPayedReward.floatView)元")
                .font(.title)
                .foregroundColor(.primary.opacity(1))
                .sheet(isPresented: $isShowOverMoney) {
                    VStack(alignment: .center,spacing: 30){
                        Image(systemName: "wrongwaysign")
                            .resizable()
                            .frame(width: 30,height: 30)
                            .foregroundColor(.red)
                        Text("支取金额超出限额，应低于\(database.notPayedReward.floatView)元")
                    }
                }
            TextField("准备提取多少存款", value: $payMoney, formatter: doubleFormatter)
                .font(.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
#if os(iOS)
                            .keyboardType(UIKit.UIKeyboardType.decimalPad)
#endif
                .foregroundColor(.blue)
                .padding(.bottom,30)
                
            HStack{
                Spacer()
                
                Button("支取") {
                    
                    if payMoney > database.allReward{
                        isShowOverMoney = true
                        return
                    }else{
                        database.pay(money: payMoney)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                Spacer()
                
                Button("取消"){
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
            }
            Spacer()
            
            
        }
    }
}

struct PayView_Previews: PreviewProvider {
    static var previews: some View {
        PayView()
            .environmentObject(DatabaseStore())
    }
}
