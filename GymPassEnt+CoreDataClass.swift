//
//  GymPassEnt+CoreDataClass.swift
//  gymtracker Watch App
//
//  Created by Olof Jonsson on 2023-08-05.
//
//

import Foundation
import CoreData

@objc(GymPassEnt)
public class GymPassEnt: NSManagedObject {

    public var wrappedText: String {
        text ?? "Unknown Gympass"
    }
    
    public var exerciseArray: [ExerciseEnt] {
        let set = exerciseRelation as? Set<ExerciseEnt> ?? []
        return set.sorted {
            $0.wrappedTimestamp < $1.wrappedTimestamp
        }
    }
}
