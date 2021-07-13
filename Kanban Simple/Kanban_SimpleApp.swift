//
//  Kanban_SimpleApp.swift
//  Kanban Simple
//
//  Created by Arrinal Sholifadliq on 10/07/21.
//

import SwiftUI

@main
struct Kanban_SimpleApp: App {
    
    let persistenceController = PersistenceController.shared
    
    @Environment(\.scenePhase) var scenePhase
    
    
    var body: some Scene {
        WindowGroup {
            KanbanView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        }
        .onChange(of: scenePhase) { (newScenePhase) in
            switch newScenePhase {
                
            case .background:
                print("Scene is in background")
                persistenceController.save()
            case .inactive:
                print("Scene is inactive")
            case .active:
                print("Scene is active")
            @unknown default:
                print("Apple error")
            }
        }
    }
}
