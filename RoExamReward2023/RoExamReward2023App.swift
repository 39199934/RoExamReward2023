//
//  RoExamReward2023App.swift
//  RoExamReward2023
//
//  Created by rolodestar on 2023/3/20.
//

import SwiftUI

@main
struct RoExamReward2023App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(DatabaseStore())
        }
    }
}
