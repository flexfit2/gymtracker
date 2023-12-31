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
    @State private var isTrophy: Bool = false

    @State var previousExc: ExerciseEnt = ExerciseEnt()
    @State var indForThisExercise: Int = 0
    private static let topId = "topIdHere"
    
    @State var indForExerciseEnt: Int = 0
    @State var recordWeight: Float = 0
    @State var recordReps: Int32 = 0



  
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
                print("found \(object.text!) from \(object.origin?.date!)")
                previousExercises.append(object)
            }
        }
        
        for exc in previousExercises {
            sets = exc.exerciseSetArray
            for sett in sets {
                print("Reps:  \(sett.reps)")
                print("Weight: \(sett.weight)")
                if sett.weight > recordWeight {
                    print("record weight: \(sett.weight)")
                    recordWeight = sett.weight
                    recordReps = sett.reps
                }
                    if sett.weight == recordWeight {

                    if sett.reps > recordReps {
                        print("record reps on record weight: \(sett.reps) on \(sett.weight) kg")
                        recordReps = sett.reps

                        isTrophy = true
                    }
                }
            }
            if exc.id == exerciseent.id {
                print("This exercise is from \(exc.origin?.date!)")
                indForExerciseEnt = previousExercises.firstIndex(of: exerciseent)!
                print("Place in array from this exercise is \(indForExerciseEnt)")
            }
        }
        
        if indForExerciseEnt > 0 {
            print("PREVIOUS EXERCISE OF THIS TYPE BY INDEX")
            print(previousExercises[indForExerciseEnt - 1].origin!.date!)
            previousExc = previousExercises[indForExerciseEnt - 1]

        } else {
            previousExc = exerciseent
        }

//        indForThisExercise = previousExercises.endIndex - 1
//        print("indForThisExcercise is \(indForThisExercise)" )
//        print("PREVIOUS EXERCISE OF THIS TYPE BY LAST AFTER DROP LAST:")
//        previousExc = previousExercises.dropLast().last ?? exerciseent
//        print(previousExc.origin!.date!)

//        if indForThisExercise > 0 {
//            print("PREVIOUS EXERCISE OF THIS TYPE BY INDEX")
//            print(previousExercises[indForThisExercise - 1].origin!.date!)
//            print(previousExercises[indForThisExercise - 1].text!)
//            previousExc = previousExercises[indForThisExercise - 1]
//
//            previousExc = previousExercises.dropLast().last ?? exerciseent
//        }
        

        
        print("####DUMP OF SETS#####")
        sets = exerciseent.exerciseSetArray
        let tempArray = exercisenames
        exercisenames_sorted = tempArray.sorted(by: { $0.text < $1.text })
        nameString = exerciseent.text!
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
            ScrollViewReader { scrollProxy in
                
                VStack(alignment: .center, spacing: 3) {
                    HeaderView(title: nameString).id(Self.topId)
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
                            if exercisesetent.weight > recordWeight {
                                print("new record weight: \(exercisesetent.weight)")
                                recordWeight = exercisesetent.weight
                                recordReps = exercisesetent.reps
                                isTrophy = true
                            }
                            if exercisesetent.weight == recordWeight {
                                if exercisesetent.reps > recordReps {
                                    print("new record reps on record weight: \(exercisesetent.reps) on \(exercisesetent.weight) kg")
                                    recordReps = exercisesetent.reps
                                    isTrophy = true
                                }
                            }
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
                                    if sets[i].weight == recordWeight
                                        && sets[i].reps == recordReps{
                                        Capsule()
                                            .frame(width: 4)
                                            .foregroundColor(.blue)
                                    }
                                    Capsule()
                                        .frame(width: 4)
                                        .foregroundColor(.accentColor)
                                    Text("    \(sets[i].weight, specifier: "%.1f") kg")
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
                    scrollProxy.scrollTo(Self.topId, anchor: .top)
                } label: {
                    Text("OK")
                    
                }
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
