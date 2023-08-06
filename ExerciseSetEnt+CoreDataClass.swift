//
//  ExerciseSetEnt+CoreDataClass.swift
//  gymtracker Watch App
//
//  Created by Olof Jonsson on 2023-08-05.
//
//

import Foundation
import CoreData

@objc(ExerciseSetEnt)
public class ExerciseSetEnt: NSManagedObject {

    public var wrappedReps: Int32 {
    reps ?? 0
}

    public var wrappedWeight: Float {
        weight ?? 0.0
    }
}
