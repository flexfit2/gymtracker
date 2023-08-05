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
    
    @State private var notes: [Exercise] = [Exercise]()
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
        do {
            let data = try JSONEncoder().encode(notes)
            let url = getDocumentDirectory().appendingPathComponent("notes")
            try data.write(to: url)
            
        } catch {
            print("Saving data has failed")
        }
    }
    
    func load() {
        DispatchQueue.main.async {
            do {
                let url = getDocumentDirectory().appendingPathComponent("notes")
                let data = try Data(contentsOf: url)
                notes = try JSONDecoder().decode([Exercise].self, from: data)
            } catch  {
                // Do nothing
            }
        }
    }
    
    func getDocumentDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    func delete(offsets: IndexSet) {
        withAnimation {
            notes.remove(atOffsets: offsets)
            save()
        }
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 6) {
                TextField("Nytt inlägg", text: $text)
                Button {
                    guard text.isEmpty == false else { return }
                    let note = Exercise(id: UUID(), text: text, sets: [GymSet(id: UUID(), reps: 10, weight: 30)])
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
            if notes.count >= 1 {
                List {
                    ForEach(0..<notes.count, id: \.self) { i in
                        NavigationLink(destination: DetailView(exercise: notes[i], count: notes.count, index: i, sets: [GymSet(id: UUID(), reps: 10, weight: 30)])) {
                            HStack {
                                Capsule()
                                    .frame(width: 4)
                                    .foregroundColor(.accentColor)
                                Text(notes[i].text)
                                    .lineLimit(1)
                                    .padding(.leading, 5)
                            }
                        }
                    }
                    .onDelete(perform: delete)
    //            Text("\(date)")
                }
            } else {
                Spacer()
                Image(systemName: "note.text")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
                    .opacity(0.25)
                    .padding(25)
                Spacer()
            }
        }
        .navigationTitle("Övningar")
        .foregroundColor(.accentColor)
        .onAppear(perform: {
            load()
        })
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

