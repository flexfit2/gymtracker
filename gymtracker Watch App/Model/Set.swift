//
//  Set.swift
//  gymtracker Watch App
//
//  Created by Olof Jonsson on 2023-08-02.
//

import Foundation

struct Set: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    var reps: Int
    var weight: Int
    
    init(id: UUID, name: String, reps: Int, weight: Int) {
        self.id = id
        self.name = name
        self.reps = reps
        self.weight = weight
    }
    
}
