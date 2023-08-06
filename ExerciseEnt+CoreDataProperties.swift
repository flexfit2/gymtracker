//
//  ExerciseEnt+CoreDataProperties.swift
//  gymtracker Watch App
//
//  Created by Olof Jonsson on 2023-08-05.
//
//

import Foundation
import CoreData


extension ExerciseEnt {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseEnt> {
        return NSFetchRequest<ExerciseEnt>(entityName: "ExerciseEnt")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var text: String?
    @NSManaged public var origin: GymPassEnt?
    @NSManaged public var exercisesets: NSSet?

}

// MARK: Generated accessors for exercisesets
extension ExerciseEnt {

    @objc(addExercisesetsObject:)
    @NSManaged public func addToExercisesets(_ value: ExerciseSetEnt)

    @objc(removeExercisesetsObject:)
    @NSManaged public func removeFromExercisesets(_ value: ExerciseSetEnt)

    @objc(addExercisesets:)
    @NSManaged public func addToExercisesets(_ values: NSSet)

    @objc(removeExercisesets:)
    @NSManaged public func removeFromExercisesets(_ values: NSSet)

}

extension ExerciseEnt : Identifiable {

}
