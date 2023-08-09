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
    @State  var repsText: String = ""
    @State  var weightText: String = ""
    @State var update: String = ""
    @State  var presentingModal: Bool = false
    @State var sets: [ExerciseSetEnt] = [ExerciseSetEnt] ()
    @State var text = ""
    
    func loadList() {
        sets = exerciseent.exerciseSetArray
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
//        Button {
//            exerciseent.text=text
//
//        } label: {
//            Text("edit name")
//            
//        }
        VStack(alignment: .center, spacing: 3) {
            HeaderView(title: exerciseent.text!)
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
                    // COREDATA STUFF
                    let exercisesetent = ExerciseSetEnt(context: moc)
                    exercisesetent.id = UUID()
//                    exercisesetent.name = String(name)
                    exercisesetent.reps = Int32(repsText)!
                    exercisesetent.weight = Float(weightText)!
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
                                Capsule()
                                    .frame(width: 0)
                                    .foregroundColor(.accentColor)
                                Text("\(sets[i].reps) reps  ")
                                    .lineLimit(1)
                            }
                            HStack {
                                Capsule()
                                    .frame(width: 4)
                                    .foregroundColor(.accentColor)
                                Text("    \(sets[i].weight, specifier: "%.2f") kg")
                                    .lineLimit(1)
                            }
                        }
                    }
                                        .onDelete(perform: deleteExerciseSetEnt)
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
            loadList()
        })
    }
}

//struct ExerciseView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExerciseView()
//    }
//}
