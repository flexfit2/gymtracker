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
    

    
    public var wrappedText: String {
          text ?? "Unknown exercise"
      }
      
      public var exerciseSetArray: [ExerciseSetEnt] {
          let set = exercisesets as? Set<ExerciseSetEnt> ?? []
          return set
              .sorted {
              $0.id < $1.id

          }
      }

}
