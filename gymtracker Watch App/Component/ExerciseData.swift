//
//  ExerciseData.swift
//  gymtracker Watch App
//
//  Created by Olof Jonsson on 2023-08-03.
//

import Foundation


import UIKit
import SwiftUI
import CoreLocation

let exercisenames: [ExerciseName] = load("exercisenames.json")

func load<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
    var data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}



