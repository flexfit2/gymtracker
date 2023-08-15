//
//  ExerciseView.swift
//  gymtracker Watch App
//
//  Created by Olof Jonsson on 2023-08-05.
//

import SwiftUI
import SwiftUI_Apple_Watch_Decimal_Pad
import CoreData

struct ExerciseView: View {
    
    @Environment(\.managedObjectContext) var moc
    @State var exerciseent: ExerciseEnt
    @State var repsText: String = ""
    @State var weightText: String = ""
    @State var update: String = ""
    @State var presentingModal: Bool = false
    @State var sets: [ExerciseSetEnt] = [ExerciseSetEnt] ()
    @State var text = ""
    @State var exercisenames_sorted: [ExerciseName] = [ExerciseName]()
    @State var nameString: String = ""
    let gympassDateText: String
    @State private var isPrevWorkoutPresented: Bool = false
    @State var previousExc: ExerciseEnt = ExerciseEnt()
    @State var indForThisExercise: Int = 0

  
    func loadList() {
        // Create a fetch request for a specific Entity type
        let fetchRequest: NSFetchRequest<ExerciseEnt> = ExerciseEnt.fetchRequest()
        // Fetch all objects of one Entity type
        let objects = try? moc.fetch(fetchRequest)
        //dump(objects)
        var previousExercises: [ExerciseEnt] = [ExerciseEnt] ()
        for object in objects! {
            //print(object.text!)
            if object.text! == exerciseent.text {
                print("found \(object.text!)")
                previousExercises.append(object)
            }
        }
        
        indForThisExercise = previousExercises.endIndex - 1
        print("indofrthosedxceprise is \(indForThisExercise)" )
        print("PREVIOUS EXERCISE OF THIS TYPE:")
        previousExc = previousExercises.dropLast().last ?? exerciseent

        if indForThisExercise > 0 {
            print(previousExercises[indForThisExercise - 1].origin!.date!)
            print(previousExercises[indForThisExercise - 1].text!)
//            previousExc = previousExercises[indForThisExercise - 1]
//            
//            previousExc = previousExercises.dropLast().last ?? exerciseent
        }
        sets = exerciseent.exerciseSetArray
        let tempArray = exercisenames
        exercisenames_sorted = tempArray.sorted(by: { $0.text < $1.text })
        nameString = exerciseent.text!
        print("####DUMP OF SETS#####")
        //dump(sets)
        //print(sets.)
        print(exerciseent.origin?.date!)
        print(exerciseent.text!)
        for sett in sets {
            print("Reps:  \(sett.reps)")
            print("Weight: \(sett.weight)")
        }
        print("#########")
    }
    
    func deleteExerciseSetEnt(at offsets: IndexSet) {
        for offset in offsets {
            let exerciseSetentToDelete = exerciseent.exerciseSetArray[offset]
            
            // delete it from the context
            moc.delete(exerciseSetentToDelete)
        }
        try? moc.save()
        //  sizeOfExerciseArray = gympassent.exerciseArray.count
        
    }
    
    
    var body: some View {
        //        TextField("new name", text: $text)
        // pickerForEditView(exerciseent: exerciseent)
        //  .environment(\.managedObjectContext, self.moc)
        
        ScrollView {
            VStack(alignment: .center, spacing: 3) {
                HeaderView(title: nameString)
                if exerciseent != previousExc {
                    Image(systemName: "info.circle")
                        .onTapGesture {
                            isPrevWorkoutPresented.toggle()
                        }
                        .sheet(isPresented: $isPrevWorkoutPresented, content: {
                            PrevWorkoutView(exercise: previousExc)
                        })
                }
                Text(gympassDateText)
                    .font(.system(size: 8, weight: .light))
                Spacer()
                HStack {
                    DigiTextView(placeholder: "Reps",
                                 text: $repsText,
                                 presentingModal: presentingModal
                    )
                    .frame(width: 70)
                    DigiTextView(placeholder: "Vikt",
                                 text: $weightText,
                                 presentingModal: presentingModal
                    )
                    Button {
                        guard repsText.isEmpty == false else { return }
                        print("Creating set")
                        let exercisesetent = ExerciseSetEnt(context: moc)
                        exercisesetent.id = UUID()
                        exercisesetent.reps = Int32(repsText)!
                        exercisesetent.weight = Float(weightText)!
                        exercisesetent.name = String(Date().timeIntervalSince1970)
                        // Link
                        exercisesetent.exercise = exerciseent
                        try? moc.save()
                        //workaround for view to load
                        sets = exerciseent.exerciseSetArray
                        print("#########exerciseETDUMP###########")
                        dump(exercisesetent)
                        print("COUNT IS \(exerciseent.exerciseSetArray.count)")
                        repsText = ""
                        weightText = ""
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 20, weight: .semibold))
                    }
                }
                Spacer()
                if sets.count >= 1 {
                    List {
                        ForEach(0..<sets.count, id: \.self) { i in
                            HStack {
                                HStack {
                                    Text("\(sets[i].reps) reps  ")
                                        .lineLimit(1)
                                }
                                Capsule()
                                    .frame(width: 4)
                                    .foregroundColor(.accentColor)
                                Text("    \(sets[i].weight, specifier: "%.2f") kg")
                                    .lineLimit(1)
                            }
                        }
                        .onDelete(perform: { offsets in deleteExerciseSetEnt(at: offsets)})
                    }
                    .frame(height: 450)
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
            .padding(3)
            //            .onAppear(perform: {
            //                loadList()
            //            })
            Picker(selection: $text,label: Text("")
            ) {
                Text("Byt namn")
                    .tag(exerciseent.text)
                    .foregroundColor(.cyan)
                // .font(.system(size: 15, weight: .semibold))
                ForEach(0..<exercisenames_sorted.count, id: \.self) { i in
                    Text(exercisenames_sorted[i].text).font(.subheadline).tag("\(exercisenames_sorted[i].text)")
                }
            }
            .onChange(of: text) { print($0) }
            .pickerStyle(.navigationLink)
            .onAppear(perform: loadList)
            Button {
                print("changing name to \(text)")
                exerciseent.text=text
                nameString = exerciseent.text!
                try? moc.save()
            } label: {
                Text("OK")
                
            }
        }
    }
}

struct pickerForEditView: View {
    @State private var text: String = "Placeholder"
    @State var exercisenames_sorted: [ExerciseName] = [ExerciseName]()
    var exerciseent: ExerciseEnt
    @Environment(\.managedObjectContext) var moc
    
    func loadList() {
        let tempArray = exercisenames
        exercisenames_sorted = tempArray.sorted(by: { $0.text < $1.text })
        //  sizeOfExerciseArray = gympassent.exerciseArray.count
    }
    
    var body: some View {
        Picker(selection: $text,label: Text("")
        ) {
            //  if text == "Placeholder" {
            Text("Välj övning")
                .tag("Placeholder")
                .foregroundColor(.cyan)
                .font(.system(size: 25, weight: .semibold))
            
            
            //    }
            ForEach(0..<exercisenames_sorted.count, id: \.self) { i in
                Text(exercisenames_sorted[i].text).font(.subheadline).tag("\(exercisenames_sorted[i].text)")
            }
        }
        
        .onChange(of: text) { print($0) }
        .pickerStyle(.navigationLink)
        .onAppear().onAppear(perform: loadList)
        Button {
            print("changing name to \(text)")
            exerciseent.text=text
            try? moc.save()
            
        } label: {
            Text("edit name")
            
        }
    }
}

//struct ExerciseView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExerciseView()
//    }
//}
