//
//  ContentView.swift
//  gymtracker Watch App
//
//  Created by Olof Jonsson on 2023-07-29.
//

import SwiftUI
import UIKit
import CoreData


struct TopContentView: View {
    
    
    let date = Date()
    @State private var gympasses: [GymPass] = [GymPass]()
    @State private var gympasses_reversed: [GymPass] = [GymPass]()
    @State private var text: String = ""
    let dateFormatter = DateFormatter()
    
    @Environment(\.managedObjectContext) var moc
    
    func save() {
        dump(gympasses)
        do {
            let data = try JSONEncoder().encode(gympasses)
            let url = getDocumentDirectory().appendingPathComponent("topnotes")
            try data.write(to: url)
            
        } catch {
            print("Saving data has failed")
        }
    }
    
    func load() {
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        DispatchQueue.main.async {
            do {
                let url = getDocumentDirectory().appendingPathComponent("topnotes")
                let data = try Data(contentsOf: url)
                gympasses = try JSONDecoder().decode([GymPass].self, from: data)
                //gympasses_reversed = gympasses.reversed()
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
            //gympasses_reversed = gympasses.reversed()
            gympasses.remove(atOffsets: offsets)
            save()
        }
    }
    
    func dumpData(anArray: [Any]) {
        ForEach(0..<anArray.count, id: \.self) { i in
            let theData = "\(dump(anArray[i]))"
            
        }
    }
    
    func saveToFileAtTopLevel() {
        
        let stringIWantToSave = "\(dump(gympasses))"
        
        ForEach(0..<gympasses.count, id: \.self) { i in
            //let gympass_data=dumpData(anArray: gympasses)
//            gympasses[i].saveToFile()
            dump(gympasses[i])
            let gympass_exercises=gympasses[i].exercises
            ForEach(0..<gympass_exercises.count, id: \.self) { item in
                gympass_exercises[item].saveToFile()
//                let gympass_exercises_data="\(dump(gympasses[item].exercises))"
                let gympass_exercises_sets=gympass_exercises[item].sets
                ForEach(0..<gympass_exercises_sets.count, id: \.self) { aset in
                    gympass_exercises_sets[aset].saveToFile()
//                    let gympass_exercises_sets_data = dumpData(anArray: gympass_exercises_sets)
                }
            }
        }
        
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)[0].appendingPathComponent("gymtracker_data.json")
        print("printing to file:\n \(stringIWantToSave)")
        
        if let stringData = stringIWantToSave.data(using: .utf8) {
            try? stringData.write(to: path)
        }
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .center, spacing: 6) {
                //Text("\(dateFormatter.string(from: date))")
                Button {
                    // guard text.isEmpty == false else { return }
                    let gympass = GymPass(id: UUID(), text: "\(dateFormatter.string(from: date))", exercises: [Exercise]())
                    print(gympass)
                    gympasses.append(gympass)
                    //gympasses_reversed = gympasses.reversed()
                    text = ""
                    save()
                    saveToFileAtTopLevel()
                    
                    
                } label: {
                    Text("Lägg till ny träning")
                }
            }
            .fixedSize()
            .buttonStyle(BorderedButtonStyle(tint: .white))
            .buttonStyle(PlainButtonStyle())
            // .foregroundColor(.accentColor)
            .foregroundColor(Color.green)
            .onAppear(perform: {
                load()
                saveToFileAtTopLevel()
            })
            
            Spacer()
            if gympasses.count >= 1 {
                List {
                    ForEach(0..<gympasses.count, id: \.self) { i in
                        NavigationLink(destination: GymPassView(gympass: gympasses[i], count: gympasses.count, index: i)) {
                            HStack {
                                Capsule()
                                    .frame(width: 4)
                                    .foregroundColor(.accentColor)
                                Text(gympasses[i].text)
                                    .lineLimit(1)
                                    .padding(.leading, 5)
                            }
                        }
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(.carousel)
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
        .foregroundColor(.accentColor)
        .onAppear(perform: {
            load()
        })
    }
}


struct TopContentView_Preview: PreviewProvider {
    static var sampleExercise: Exercise = Exercise(id: UUID(), text: "herru word", sets: [GymSet(id: UUID(), reps: 10, weight: 30)])
    static var sampleExercise2: Exercise = Exercise(id: UUID(), text: "herru herru", sets: [GymSet(id: UUID(), reps: 10, weight: 30)])
    
    static var sampleGymPass: GymPass = GymPass(id: UUID(), text: "herru word", exercises: [sampleExercise, sampleExercise2])
    static var previews: some View {
        TopContentView()
    }
}

