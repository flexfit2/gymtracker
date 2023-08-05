//
//  Note.swift
//  gymtracker Watch App
//
//  Created by Olof Jonsson on 2023-07-31.
//

import Foundation

struct Exercise: Identifiable, Codable, Hashable {
    var id: UUID
    var text: String
    var sets: [GymSet] = [GymSet]()
    
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
