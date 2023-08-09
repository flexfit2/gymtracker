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
    
    let helper = Helper()
    @Environment(\.managedObjectContext) var moc
   // @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var gympassents: FetchedResults<GymPassEnt>
    @FetchRequest(sortDescriptors: []) var gympassents: FetchedResults<GymPassEnt>

    
    func whereIsMySQLite() {
        let path = NSPersistentContainer
            .defaultDirectoryURL()
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding

        print(path ?? "Not found")
    }
    
    func deleteGympassEnt(at offsets: IndexSet) {
        for offset in offsets {
            let gympassent = gympassents[offset]
            // delete it from the context
            moc.delete(gympassent)
        }        
        try? moc.save()
    }
    
    
    var body: some View {
        ScrollView {
            VStack {
                HeaderView(title: "Träningspass")
                    Button {
                        dateFormatter.dateStyle = DateFormatter.Style.medium
                        dateFormatter.timeStyle = DateFormatter.Style.short
                        // COREDATA STUFF
                        let gympassEnt = GymPassEnt(context: moc)
                        print("created gymPassEnt")
                        gympassEnt.id = UUID()
                        print("set the id")
                        gympassEnt.date = Date()
                        gympassEnt.text = "\(dateFormatter.string(from: gympassEnt.date!))"
                        print("set the text")
                        try? moc.save()
                        print("saved")
                        dump(gympassEnt)
                    } label: {
                        Text("Lägg till ny träning")
                    }
    //                .fixedSize()
                    .buttonStyle(BorderedButtonStyle(tint: .white))
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(Color.green)
    //            }

                Spacer()
                if gympassents.count >= 1 {
                    List {
                        ForEach(0..<gympassents.count, id: \.self) { i in
                            NavigationLink(destination: GymPassCoreView(gympassent:  gympassents[i])
                                .environment(\.managedObjectContext, self.moc)
                            ) {
                                HStack {
                                    Capsule()
                                        .frame(width: 4)
                                        .foregroundColor(.accentColor)
                                    Text(gympassents[i].text ?? "")
                                        .lineLimit(1)
                                        .padding(.leading, 5)
                                }
                            }
                        }
                        .onDelete(perform: deleteGympassEnt)
                    }
                    .listStyle(.carousel)
                    .frame(height: 224)
                }
            }
            .foregroundColor(.accentColor)
            .onAppear(perform: {
    //               loadList()
                whereIsMySQLite()
           //     helper.dostuff()
        })
        }
    }
}


struct TopContentView_Preview: PreviewProvider {
    static var sampleExercise: Exercise = Exercise(id: UUID(), text: "herru word", sets: [GymSet(id: UUID(), reps: 10, weight: 30)])
    static var sampleExerciseEnt: ExerciseEnt = ExerciseEnt()
    static var sampleExercise2: Exercise = Exercise(id: UUID(), text: "herru herru", sets: [GymSet(id: UUID(), reps: 10, weight: 30)])
    
    static var sampleGymPass: GymPassEnt = GymPassEnt()
    static var previews: some View {
        TopContentView()
    }
}

