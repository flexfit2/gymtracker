//
//  TopNoteContentsView.swift
//  gymtracker Watch App
//
//  Created by Olof Jonsson on 2023-08-01.
//

import SwiftUI

struct TopNoteContentsView: View {
    
    @State var gympass: GymPass
    let count: Int
    let index: Int
    //let topnote: TopNote

    
    @State var exercises: [Exercise]

    @State private var text: String = ""
    
    func loadList() {
        exercises = gympass.exercises
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
                //notes = topnote.notes
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
    
    var body: some View {
        
        VStack {
            HeaderView(title: "\(gympass.text)")
            HStack {
                TextField("Ny övning", text: $text)
                Button {
                    guard text.isEmpty == false else { return }
                    let note = Exercise(id: UUID(), text: text, sets: [Set]())
                    gympass.exercises.append(note)
                    text = ""
                    save()
                    
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 42, weight: .semibold))
                }
            }
            
        Spacer()
            HStack {
                if gympass.exercises.count >= 1 {
                   // Text("\(topnote.notes.count)")
                    List {
                        ForEach(0..<gympass.exercises.count, id: \.self) { i in
                            NavigationLink(destination: DetailView(exercise: gympass.exercises[i], count: gympass.exercises.count, index: i, sets: [Set(id: UUID(), name: "namn", reps: 10, weight: 30)])) {
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
                        //            Text("\(date)")
                    }
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
            })
            
        }
        //.fixedSize()
        //.buttonStyle(BorderedButtonStyle(tint: .accentColor))
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(.accentColor)
        }
    }


struct TopNoteContentsView_Previews: PreviewProvider {
    static var sampleNote: Exercise = Exercise(id: UUID(), text: "Bänkpress", sets: [Set(id: UUID(), name: "namn", reps: 10, weight: 30)])
    static var sampleNote2: Exercise = Exercise(id: UUID(), text: "Lats",sets: [Set(id: UUID(), name: "namn", reps: 10, weight: 30)])

    static var sampleData: GymPass = GymPass(id: UUID(), text: "herru word", exercises: [sampleNote, sampleNote2])
    static var previews: some View {
        TopNoteContentsView(gympass: sampleData, count: 2, index: 1, exercises: [sampleNote,sampleNote2])
    }
}
