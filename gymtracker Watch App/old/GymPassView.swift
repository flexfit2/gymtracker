//
//  TopNoteContentsView.swift
//  gymtracker Watch App
//
//  Created by Olof Jonsson on 2023-08-01.
//

import SwiftUI

struct GymPassView: View {
    
    @State var gympass: GymPass
    
    //@State var exercises_local: [Exercise]
    @State private var text: String = "Placeholder"
    @State private var exercises_reversed: [Exercise] = [Exercise]()
    //@State var exercises_sorted: [Exercise]
    @State var exercisenames_sorted: [ExerciseName] = [ExerciseName]()



    
    
    func loadList() {
  //      exercises_local = gympass.exercises
        let tempArray = exercisenames
        exercisenames_sorted = tempArray.sorted(by: { $0.text < $1.text })

    }
    
    func save() {
        dump(gympass)
        do {
            let data = try JSONEncoder().encode(gympass)
            let url = getDocumentDirectory().appendingPathComponent("topnotescontents_\(gympass.id)")
            try data.write(to: url)
        } catch {
            print("Saving data has failed")
        }
    }
    
    func load() {
        DispatchQueue.main.async {
            do {
                let url = getDocumentDirectory().appendingPathComponent("topnotescontents_\(gympass.id)")
                let data = try Data(contentsOf: url)
                gympass = try JSONDecoder().decode(GymPass.self, from: data)
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
            gympass.exercises.remove(atOffsets: offsets)
            save()
        }
    }
    
    func saveToFile() {
        
        let stringIWantToSave = "\(dump(gympass))"
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)[0].appendingPathComponent("gymtracker_data.json")
print("printing to file:\n \(stringIWantToSave)")
        
        if let stringData = stringIWantToSave.data(using: .utf8) {
            try? stringData.write(to: path)
        }
    }
    
    var body: some View {
        VStack {
            HeaderView(title: "Övningar")

            
            Picker(selection: $text,label: Text("")) {
                if text == "Placeholder" {
                  Text("Välj övning").tag("Placeholder")
                }
              
                ForEach(0..<exercisenames_sorted.count, id: \.self) { i in
                    Text(exercisenames_sorted[i].text).font(.subheadline).tag("\(exercisenames_sorted[i].text)")
                }
            }
            .onChange(of: text) { print($0) }
            .pickerStyle(.navigationLink)
            
            HStack {
                
                Button {
                    guard text.isEmpty == false || text == "Placeholder" else { print("text is empty")
                        return }
                    let note = Exercise(id: UUID(), text: text, sets: [GymSet]())
                    gympass.exercises.append(note)
                    exercises_reversed = gympass.exercises.reversed()
                    text = "Placeholder"
                    save()
                    saveToFile()
                } label: {
                    Text("+Lägg till")
                }
                
            }
            
            Spacer()
            HStack {
                if gympass.exercises.count >= 1 {
                    List {
                        ForEach(0..<gympass.exercises.count, id: \.self) { i in
                            NavigationLink(destination: DetailView(exercise: gympass.exercises[i], count: gympass.exercises.count, index: i, sets: [GymSet(id: UUID(), reps: 10, weight: 30)])) {
                                HStack {
                                    Capsule()
                                        .frame(width: 4)
                                        .foregroundColor(.accentColor)
                                    Text(gympass.exercises[i].text)
                                        .lineLimit(1)
                                        .padding(.leading, 5)
                                }
                            }
                        }
                        .onDelete(perform: delete)
                    }
                    .listStyle(.carousel)
                }
                else {
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
            .onAppear(perform: {
                load()
                loadList()
                saveToFile()
            })
            
        }
        //.fixedSize()
        //.buttonStyle(BorderedButtonStyle(tint: .accentColor))
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(.accentColor)
    }
}


struct TopNoteContentsView_Previews: PreviewProvider {
    static var sampleNote: Exercise = Exercise(id: UUID(), text: exercisenames[0].text, sets: [GymSet(id: UUID(),  reps: 10, weight: 30)])
    static var sampleNote2: Exercise = Exercise(id: UUID(), text: exercisenames[8].text,sets: [GymSet(id: UUID(), reps: 10, weight: 30)])
    
    static var sampleData: GymPass = GymPass(id: UUID(), text: "datum", exercises: [sampleNote, sampleNote2])
    static var previews: some View {
        GymPassView(gympass: sampleData)
    }
}
