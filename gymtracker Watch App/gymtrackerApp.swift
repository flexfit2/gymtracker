//
//  gymtrackerApp.swift
//  gymtracker Watch App
//
//  Created by Olof Jonsson on 2023-07-29.
//

import SwiftUI
import WatchKit

@main
struct gymtracker_Watch_AppApp: App {
    @StateObject private var dataController = DataController()
//    @FetchRequest(sortDescriptors: []) var gymPassEnts: FetchedResults<GymPassEnt>

    
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                TopContentView()
                    .environment(\.managedObjectContext, dataController.container.viewContext)

            }
        }
        
    }
    
}
