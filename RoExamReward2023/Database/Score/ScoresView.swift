//
//  ScoresView.swift
//  RoExamReward2023
//
//  Created by rolodestar on 2023/3/21.
//

import SwiftUI

struct ScoresView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    //    @State var selectedId: UUID? = nil
    @EnvironmentObject var database: DatabaseStore
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Score.id, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Score>
    
    var body: some View {
        
        //            database.createSubjectPickerView(selection: $selectedId)
        
        List{
            ForEach(items) { item in
                ScoresListItemView(score: item)
                
            }
            .onDelete(perform: deleteItems)
//            .navigationTitle("成绩列表")
            
            
        }
        
        
        .toolbar {
            #if os(iOS)
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    EditButton()
                                }
            #endif
            ToolbarItem {
                HStack(spacing: 30){
                    Image(systemName: "plus")
                        .onTapGesture {
                            
                            database.path.append(DatabaseStore.PathEnum.appendScore)
                            
                        }
                    Image(systemName: "trash")
                        .onTapGesture {
                            database.clearScores()
                        }
                    //                    Button(action: addItem) {
                    //                        Label("Add Item", systemImage: "plus")
                    //                    }
                }
            }
        }
        //                Text("科目列表")
        
        
    }
    
    private func addItem() {
        withAnimation {
            database.path.append(DatabaseStore.PathEnum.appendScore)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            database.loadScores()
        }
    }
}

struct ScoresView_Previews: PreviewProvider {
    static var previews: some View {
        ScoresView()
    }
}
