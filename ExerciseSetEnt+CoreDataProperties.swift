//
//  ExerciseSetEnt+CoreDataProperties.swift
//  gymtracker Watch App
//
//  Created by Olof Jonsson on 2023-08-05.
//
//

import Foundation
import CoreData


extension ExerciseSetEnt {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseSetEnt> {
        return NSFetchRequest<ExerciseSetEnt>(entityName: "ExerciseSetEnt")
    }

    @NSManaged public var name: String?
    @NSManaged public var reps: Int32
    @NSManaged public var weight: Float
    @NSManaged public var id: UUID?
    @NSManaged public var exercise: ExerciseEnt?

}

extension ExerciseSetEnt : Identifiable {

}
