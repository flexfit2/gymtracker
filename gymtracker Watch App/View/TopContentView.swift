//
//  ContentView.swift
//  gymtracker Watch App
//
//  Created by Olof Jonsson on 2023-07-29.
//

import SwiftUI
import UIKit


struct TopContentView: View {
    // @EnvironmentObject var workoutManager: WorkoutManager
    
    let date = Date()
    @State private var topnotes: [GymPass] = [GymPass]()
    @State private var text: String = ""
    
    // current date and time


    // Calender dateComponents


    // DateFormatter
    let dateFormatter = DateFormatter()
    //dateFormatter.dateFormat = "hh:mm"
  //  let hoursMinutesString = dateFormatter.string(from: date)
    
    func save() {
        dump(topnotes)
        do {
            let data = try JSONEncoder().encode(topnotes)
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
                topnotes = try JSONDecoder().decode([GymPass].self, from: data)
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
            topnotes.remove(atOffsets: offsets)
            save()
        }
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .center, spacing: 6) {
                Text("Lägg till ny träning!")
                //Text("\(dateFormatter.string(from: date))")
                Button {
                    print("hrh")
                    //guard text.isEmpty == false else { return }
                    let topnote = GymPass(id: UUID(), text: "\(dateFormatter.string(from: date))", exercises: [Exercise]())
                    print("hrh")
                    print(topnote)
                    topnotes.append(topnote)
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
            if topnotes.count >= 1 {
                List {
                    ForEach(0..<topnotes.count, id: \.self) { i in
                        NavigationLink(destination: TopNoteContentsView(gympass: topnotes[i], count: topnotes.count, index: i, exercises: topnotes[i].exercises)) {
                            HStack {
                                Capsule()
                                    .frame(width: 4)
                                    .foregroundColor(.accentColor)
                                Text(topnotes[i].text)
                                    .lineLimit(1)
                                    .padding(.leading, 5)
                            }
                        }
                    }
                    .onDelete(perform: delete)
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
        //.navigationTitle("Datum")
        .foregroundColor(.accentColor)
        .onAppear(perform: {
            load()
        })
    }
}

struct TopContentView_Preview: PreviewProvider {
    static var sampleNote: Exercise = Exercise(id: UUID(), text: "herru word", sets: [Set(id: UUID(), name: "namn", reps: 10, weight: 30)])
    static var sampleNote2: Exercise = Exercise(id: UUID(), text: "herru herru", sets: [Set(id: UUID(), name: "namn", reps: 10, weight: 30)])

    static var sampleData: GymPass = GymPass(id: UUID(), text: "herru word", exercises: [sampleNote, sampleNote2])
    static var previews: some View {
        TopContentView()
    }
}

