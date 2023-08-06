//
//  GymPassEnt+CoreDataProperties.swift
//  gymtracker Watch App
//
//  Created by Olof Jonsson on 2023-08-05.
//
//

import Foundation
import CoreData


extension GymPassEnt {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GymPassEnt> {
        return NSFetchRequest<GymPassEnt>(entityName: "GymPassEnt")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var text: String?
    @NSManaged public var exerciseRelation: NSSet?

}

// MARK: Generated accessors for exerciseRelation
extension GymPassEnt {

    @objc(addExerciseRelationObject:)
    @NSManaged public func addToExerciseRelation(_ value: ExerciseEnt)

    @objc(removeExerciseRelationObject:)
    @NSManaged public func removeFromExerciseRelation(_ value: ExerciseEnt)

    @objc(addExerciseRelation:)
    @NSManaged public func addToExerciseRelation(_ values: NSSet)

    @objc(removeExerciseRelation:)
    @NSManaged public func removeFromExerciseRelation(_ values: NSSet)

}

extension GymPassEnt : Identifiable {

}
