//
//  Note.swift
//  gymtracker Watch App
//
//  Created by Olof Jonsson on 2023-07-31.
//

import Foundation

struct Exercise: Identifiable, Codable {
    let id: UUID
    let text: String
    var sets: [Set]
    
}
