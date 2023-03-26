//
//  StringEditView.swift
//  RoExamReward2023
//
//  Created by rolodestar on 2023/3/21.
//

import SwiftUI

struct StringEditView: View {
    @Binding var origin: String?
    @State var draft : String = ""
    @State var isEdit: Bool = false
    var title: String
    
    var comletionHandle: ((_ value: Double) -> Void)?
    init(origin:Binding<String?>, draft: String = "", isEdit: Bool = false, title: String,completionHandel : ((_ value: Double) -> Void)? = nil) {
        self._origin = origin
        self.draft = draft
        self.isEdit = isEdit
        self.title = title
        self.comletionHandle = completionHandel
    }
    var body: some View {
        
        VStack(alignment:.leading){
            HStack(alignment: .firstTextBaseline){
                Text(title)
                if(!isEdit){
                    Text("\(origin != nil ? origin! : "未有数据")" + "\(isEdit ? " (未存储)" : "")")
                        .onTapGesture {
                            withAnimation {
                                isEdit.toggle()
                            }
                        }
                }else{
                   
                        
                        TextField(title, text: $draft)
                            .foregroundColor(.red)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onAppear{
                                draft = origin ?? ""
                            }
                            
                            
                            .multilineTextAlignment(.leading)
                            .onSubmit {
                                if self.comletionHandle != nil{
                                    self.comletionHandle!(Double(draft) ?? 0)
                                }
                                self.origin = draft
                                isEdit = false
                            }
                        
                            
                        
                   
                }
                Spacer()
            }

                
        }
    }
}
struct DoubleEditView: View {
    @Binding var origin: Double
    @State var draft : String = ""
    @State var isEdit: Bool = false
    var title: String
    var comletionHandle: ((_ value: Double) -> Void)?
    init(origin:Binding<Double>, draft: String = "", isEdit: Bool = false, title: String,completionHandel : ((_ value: Double) -> Void)? = nil) {
        self._origin = origin
        self.draft = draft
        self.isEdit = isEdit
        self.title = title
        self.comletionHandle = completionHandel
    }
    var body: some View {
        
        VStack(alignment:.leading){
            HStack(alignment: .firstTextBaseline){
                Text(title)
                if(!isEdit){
                    Text(String(format: "%.2f", origin) + "\(isEdit ? " (未存储)" : "")")
                        .onTapGesture {
                            withAnimation {
                                isEdit.toggle()
                            }
                        }
                }else{
                   
                        
                        TextField(title, text: $draft)
                            .foregroundColor(.red)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
#if os(iOS)
                            .keyboardType(UIKit.UIKeyboardType.decimalPad)
#endif
                            .onAppear{
                                draft = String(format: "%.2f", origin)
                            }
                            
                            
                            .multilineTextAlignment(.leading)
                            .onSubmit {
                                if self.comletionHandle != nil{
                                    self.comletionHandle!(Double(draft) ?? 0)
                                }
                                self.origin = Double(draft) ?? 0
                                isEdit = false
                            }
                        
                            
                        
                   
                }
                Spacer()
            }

                
        }
    }
}


struct StringEditView_Previews: PreviewProvider {
    @State var bb: String? = "dljkfsldfj"
    static var previews: some View {
        DoubleEditView(origin: .constant(5), title: "姓名：")
    }
}
