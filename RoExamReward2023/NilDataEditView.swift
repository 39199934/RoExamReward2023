//
//  NilDataEditView.swift
//  RoExamReward2023
//
//  Created by rolodestar on 2023/3/20.
//
//
//import SwiftUI
//
//struct NilDataEditView<T>:  View  {
//    var c1: (_ t:T?) -> String
//    var c2: (_ str: String)->T?
//    @Binding var origin: T?
//    @State var draft: T? = nil
//    @State var isEdit: Bool = false
//    
//    init(_origin:  Binding<T?>,_isEdit: Bool = false,c1: @escaping (_: T?) -> String, c2: @escaping (_: String) -> T?) {
//        
//        self.origin = _origin as? T
//        self.isEdit = _isEdit
//        
//        self.draft = nil
//        self.c1 = c1
//        self.c2 = c2
//    }
//    
//    
//    var body: some View {
//        HStack{
//            if(!isEdit){
//                Text(origin == nil ? "未有数据" : "\(c1(origin!))")
//            }
//        }
//    }
//}
//
//struct NilDataEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        NilDataEditView(_origin: .constant("dkljflkdj"), c1: { t in
//            return("\(t)")
//        }, c2: { str in
//            return str
//        })
//    }
//}
