//
//  check_list_planApp.swift
//  check-list-plan
//
//  Created by Carlos on 21/08/23.
//

import SwiftUI

@main
struct check_list_planApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
