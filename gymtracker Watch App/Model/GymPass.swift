//
//  TopNote.swift
//  gymtracker Watch App
//
//  Created by Olof Jonsson on 2023-08-01.
//

import Foundation

struct GymPass: Identifiable, Codable {
    let id: UUID
    let text: String
    var exercises: [Exercise]
    
    init(id: UUID, text: String, exercises: [Exercise]) {
        self.id = id
        self.text = text
        self.exercises = exercises
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
