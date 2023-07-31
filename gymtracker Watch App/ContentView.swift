//
//  ContentView.swift
//  gymtracker Watch App
//
//  Created by Olof Jonsson on 2023-07-29.
//

import SwiftUI
import UIKit


struct ContentView: View {
    // @EnvironmentObject var workoutManager: WorkoutManager
    
    @State private var notes: [Note] = [Note]()
    @State private var text: String = ""
    
    // current date and time
    let date = Date()

    // Calender dateComponents
   // let components = Calendar.current.dateComponents([.hour,.minute], from: date)
   // let hour = components.hour
   // let minute = components.minute

    // DateFormatter
    let dateFormatter = DateFormatter()
    //dateFormatter.dateFormat = "hh:mm"
  //  let hoursMinutesString = dateFormatter.string(from: date)
    
    func save() {
        dump(notes)
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 6) {
                TextField("Nytt inlägg", text: $text)
                Button {
                    guard text.isEmpty == false else { return }
                    let note = Note(id: UUID(), text: text)
                    notes.append(note)
                    text = ""
                    save()
                    
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 42, weight: .semibold))
                }
            }
            .fixedSize()
            //.buttonStyle(BorderedButtonStyle(tint: .accentColor))
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(.accentColor)
            Spacer()
            Text("\(date)")
            //Text("\(notes.count)")
            ForEach(notes) { note in
                Text("\(note.text)")
            }
                
        }
        .navigationTitle("Övningar")
        .foregroundColor(.accentColor)
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

