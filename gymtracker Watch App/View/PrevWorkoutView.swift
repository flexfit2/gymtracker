//
//  PrevWorkoutView.swift
//  gymtracker Watch App
//
//  Created by Olof Jonsson on 2023-08-15.
//

import SwiftUI

struct PrevWorkoutView: View {
    
    @State var exercise: ExerciseEnt
    @State var date: Date = Date()
    let dateFormatter = DateFormatter()
    @State var dateString: String = ""

    
//    init(exercise: ExerciseEnt) {
//        self.exercise = exercise
//    }
    
    func getDate() {
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.short
        date = (exercise.origin?.date)!
        dateString = dateFormatter.string(from: date)
        
    }

    var body: some View {
        List {
            Text("Sets från \(dateString)")
                .font(.subheadline)
                .fontWeight(.bold)
                .onAppear(perform: {
                    getDate()
                })
            ForEach(0..<exercise.exerciseSetArray.count, id: \.self) { i in
                HStack {
                    HStack {
                        Text("\(exercise.exerciseSetArray[i].reps) reps  ")
                            .lineLimit(1)
                    }
                    Capsule()
                        .frame(width: 4)
                        .foregroundColor(.brown)
                    Text("    \(exercise.exerciseSetArray[i].weight, specifier: "%.2f") kg")
                        .lineLimit(1)
                }
            }
        }
    }
}

//struct PrevWorkoutView_Previews: PreviewProvider {
//    static var previews: some View {
//        PrevWorkoutView()
//    }
//}
