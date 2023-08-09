//
//  TopNoteContentsView.swift
//  gymtracker Watch App
//
//  Created by Olof Jonsson on 2023-08-01.
//

import SwiftUI

struct GymPassCoreView: View {
    
    @State var gympassent: GymPassEnt
    @State private var text: String = "Placeholder"
    @Environment(\.managedObjectContext) var moc
    @State var exercisenames_sorted: [ExerciseName] = [ExerciseName]()
    @State var sizeOfExerciseArray: Int = 0

//    init() {
//        self.sizeOfExerciseArray = gympassent.exerciseArray.count
//    }
    
    func loadList() {
        let tempArray = exercisenames
        exercisenames_sorted = tempArray.sorted(by: { $0.text < $1.text })
        sizeOfExerciseArray = gympassent.exerciseArray.count
    }
    
    func deleteExerciseEnt(at offsets: IndexSet) {
        for offset in offsets {
            let exerciseentToDelete = gympassent.exerciseArray[offset]

            // delete it from the context
            moc.delete(exerciseentToDelete)
        }
        try? moc.save()
        sizeOfExerciseArray = gympassent.exerciseArray.count

    }
    
    var body: some View {
        ScrollView {
            VStack {
                HeaderView(title: "Övningar")
                HStack {
                    Picker(selection: $text,label: Text("")
                    ) {
                        if text == "Placeholder" {
                            Text("Välj övning")
                                .tag("Placeholder")
                                .foregroundColor(.cyan)
                                .font(.system(size: 25, weight: .semibold))

                            
                        }
                        ForEach(0..<exercisenames_sorted.count, id: \.self) { i in
                            Text(exercisenames_sorted[i].text).font(.subheadline).tag("\(exercisenames_sorted[i].text)")
                        }
                    }
                    
                    .onChange(of: text) { print($0) }
                    .pickerStyle(.navigationLink)


                    
                    Button {
                        guard text.isEmpty == false || text == "Placeholder" else { print("text is empty")
                            return }
                        // COREDATA STUFF
                        let exerciseent = ExerciseEnt(context: moc)
                        exerciseent.id = UUID()
                        exerciseent.text = text
                        exerciseent.origin = gympassent
                        try? moc.save()
                        sizeOfExerciseArray = gympassent.exerciseArray.count
                        print("#########GYMSETDUMP###########")
                        dump(exerciseent)
                        print("#########GYMPASSDUMP###########")
                        dump(gympassent)
                        //dump(gymsetents)
                        text = "Placeholder"
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30, weight: .semibold))
                            .padding(.top, 16)
                    }
                    //.buttonStyle(BorderedButtonStyle(tint: .white))
                    //  .buttonStyle(PlainButtonStyle())
                    .foregroundColor(Color.green)
                }
                Spacer()
//                Text("size is: \(sizeOfExerciseArray)")

                HStack {
                    if sizeOfExerciseArray >= 1 {
                        List {
                            ForEach(gympassent.exerciseArray, id: \.self) { exerciseEnt in
                                NavigationLink(destination: ExerciseView(exerciseent: exerciseEnt)                            .environment(\.managedObjectContext, self.moc)
                                ) {
                                    HStack {
                                        Capsule()
                                            .frame(width: 4)
                                            .foregroundColor(.accentColor)
                                        Text(exerciseEnt.wrappedText)
//                                            padding(.leading, 5)
                                    }
                                }
                            }
                            .onDelete(perform: { offsets in deleteExerciseEnt(at: offsets)})
                        }
                        .listStyle(.carousel)
                        .frame(height: 224)
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
                
            }
            //.fixedSize()
            //.buttonStyle(BorderedButtonStyle(tint: .accentColor))
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(.accentColor)
            .onAppear(perform: {
                loadList()
            })
        }
    }
}

struct pickerView: View {
    @State private var text: String = "Placeholder"
    @State var exercisenames_sorted: [ExerciseName] = [ExerciseName]()

    var body: some View {
        Picker(selection: $text,label: Text("")
        ) {
            if text == "Placeholder" {
                Text("Välj övning")
                    .tag("Placeholder")
                    .foregroundColor(.cyan)
                    .font(.system(size: 25, weight: .semibold))
                
                
            }
            ForEach(0..<exercisenames_sorted.count, id: \.self) { i in
                Text(exercisenames_sorted[i].text).font(.subheadline).tag("\(exercisenames_sorted[i].text)")
            }
        }
        
        .onChange(of: text) { print($0) }
        .pickerStyle(.navigationLink)
    }
}

struct GymPassCoreViewPreviews: PreviewProvider {
    static var sampleNote: Exercise = Exercise(id: UUID(), text: exercisenames[0].text, sets: [GymSet(id: UUID(),  reps: 10, weight: 30)])
    static var sampleNote2: Exercise = Exercise(id: UUID(), text: exercisenames[8].text,sets: [GymSet(id: UUID(), reps: 10, weight: 30)])
    
    static var sampleData: GymPassEnt = GymPassEnt()
    //    sampleData.
    
    static var previews: some View {
        GymPassCoreView(gympassent: sampleData)
    }
}
