//
//  DataController.swift
//  gymtracker Watch App
//
//  Created by Olof Jonsson on 2023-08-05.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "GymtrackerModel")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}

