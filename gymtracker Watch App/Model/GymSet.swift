//
//  Set.swift
//  gymtracker Watch App
//
//  Created by Olof Jonsson on 2023-08-02.
//

import Foundation

struct GymSet: Identifiable, Codable, Hashable {
    let id: UUID
    var reps: Int = 0
    var weight: Int = 0
    
    init(id: UUID, reps: Int, weight: Int) {
        self.id = id
        self.reps = reps
        self.weight = weight
    }
    
    func saveToFile() {
        
        let stringIWantToSave = "\(dump(self))"
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)[0].appendingPathComponent("gymtracker_data.json")
print("printing to file:\n \(stringIWantToSave)")
        
        if let stringData = stringIWantToSave.data(using: .utf8) {
            try? stringData.write(to: path)
        }
    }
    
}
