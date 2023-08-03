//
//  DetailView.swift
//  gymtracker Watch App
//
//  Created by Olof Jonsson on 2023-08-01.
//

import SwiftUI
import SwiftUI_Apple_Watch_Decimal_Pad

struct DetailView: View {
    
    @State var exercise: Exercise
    let count: Int
    let index: Int
    
    @State var sets: [Set]
    @State  var repsText: String = ""
    @State  var weightText: String = ""
    @State  var repRoll: Int = 4
    @State  var weightRoll: Int = 4
    
    @State  var presentingModal: Bool = false
    
    
    @State private var isCreditsPresented: Bool = false
    
    func loadList() {
        sets = exercise.sets
    }
    
    func save() {
        dump(exercise)
        do {
            let data = try JSONEncoder().encode(exercise)
            let url = getDocumentDirectory().appendingPathComponent("exercise\(exercise.id)")
            try data.write(to: url)
            
            
        } catch {
            print("Saving data has failed")
        }
    }
    
    func load() {
        DispatchQueue.main.async {
            do {
                let url = getDocumentDirectory().appendingPathComponent("exercise\(exercise.id)")
                let data = try Data(contentsOf: url)
                exercise = try JSONDecoder().decode(Exercise.self, from: data)
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
            exercise.sets.remove(atOffsets: offsets)
            save()
        }
    }
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 3) {
            
            HeaderView(title: "\(exercise.text)")
            
            Spacer()
            
            HStack {
                //TextField("Reps", text: $repsText)
                DigiTextView(placeholder: "Reps",
                             text: $repsText,
                             presentingModal: presentingModal
                )
                DigiTextView(placeholder: "Vikt",
                             text: $weightText,
                             presentingModal: presentingModal
                )
                //                    .frame(width: 60)
                
                //                TextField("Vikt", text: $weightText)
                //                Picker("Reps", selection: $repRoll) {
                //                    ForEach((4...40), id: \.self) {
                //                        Text("\($0)")
                //                    }
                //                }
                //                .pickerStyle(.navigationLink)
                //
                //
                //                Picker("Vikt", selection: $weightRoll) {
                //                    ForEach((4...100), id: \.self) {
                //                        Text("\($0)")
                //                    }
                //                }
                //                .pickerStyle(.navigationLink)
                
                
                
                
                Button {
                    guard repsText.isEmpty == false else { return }
                    let set = Set(id: UUID(), name: "", reps: Int(repsText)!, weight: Int(weightText)!)
                    print("Creating set")
                    exercise.sets.append(set)
                    repRoll = 0
                    weightRoll = 0
                    save()
                    
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 20, weight: .semibold))
                }
            }
            Spacer()
            if exercise.sets.count >= 1 {
                List {
                    ForEach(0..<exercise.sets.count, id: \.self) { i in
                        HStack {
                            HStack {
                                Capsule()
                                    .frame(width: 4)
                                    .foregroundColor(.accentColor)
                                Text("\(exercise.sets[i].reps) reps")
                                    .lineLimit(1)
                            }
                            HStack {
                                Capsule()
                                    .frame(width: 4)
                                    .foregroundColor(.accentColor)
                                Text("\(exercise.sets[i].weight) kg")
                                    .lineLimit(1)
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
        .padding(3)
        .onAppear(perform: {
            load()
            loadList()
        })
        
    }
    
}

struct StringListView: View {
    let strings = ["1234", "5678"]
    
    var body: some View {
        List(strings, id: \.self) { string in
            Text(string)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var sampleData: Exercise = Exercise(id: UUID(), text: "Bänkpress", sets: [Set(id: UUID(), name: "namn", reps: 10, weight: 30),Set(id: UUID(), name: "namn", reps: 10, weight: 30)])
    static var previews: some View {
        DetailView(exercise: sampleData, count: 5, index: 1, sets: [Set(id: UUID(), name: "namn", reps: 10, weight: 20)])
    }
}
