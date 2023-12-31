//
//  ExerciseEnt+CoreDataClass.swift
//  gymtracker Watch App
//
//  Created by Olof Jonsson on 2023-08-05.
//
//

import Foundation
import CoreData

@objc(ExerciseEnt)
public class ExerciseEnt: NSManagedObject {
    
    
    
    public var wrappedTimestamp: String {
        timestamp ?? "Unknown timestamp"
    }
    
    public var wrappedText: String {
        text ?? "Unknown exercise"
    }
    
    public var exerciseSetArray: [ExerciseSetEnt] {
        let set = exercisesets as? Set<ExerciseSetEnt> ?? []
        return set
            .sorted {
                $0.wrappedName < $1.wrappedName
            }
    }
    
}
