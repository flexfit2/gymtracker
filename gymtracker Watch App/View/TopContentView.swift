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
    
    
    @State private var text: String = ""
    @State private var height: CGFloat = 300

    let dateFormatter = DateFormatter()
    let helper = Helper()
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var gympassents: FetchedResults<GymPassEnt>
    
    func whereIsMySQLite() {
        let path = NSPersistentContainer
            .defaultDirectoryURL()
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding
        
        print(path ?? "Not found")
    }
    
    func updateHeight() {
        height = 50 * CGFloat(gympassents.count)
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
                    let gympassEnt = GymPassEnt(context: moc)
                    gympassEnt.id = UUID()
                    gympassEnt.date = Date()
                    gympassEnt.text = "\(dateFormatter.string(from: gympassEnt.date!))"
                    try? moc.save()
                    updateHeight()

                    dump(gympassEnt)
                } label: {
                    Text("Lägg till ny träning!")
                        
                       
                }
                .buttonStyle(BorderedButtonStyle(tint: .white))
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(Color.green)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .contentShape(Rectangle())
                    .lineLimit(1)
                    .padding(.leading, 5)
                    .padding(.trailing, 5)

                if gympassents.count >= 1 {
                    List {
                        ForEach(0..<gympassents.count, id: \.self) { i in
                            NavigationLink(destination: GymPassCoreView(gympassent: gympassents[i])
                                .environment(\.managedObjectContext, self.moc), label: {
                                    Text(gympassents[i].text ?? "")
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 40)
                                    
                                    .contentShape(Rectangle())
                                        .lineLimit(1)
                                        .padding(.leading, 5)
                                        .padding(.trailing, 5)
                                        .background(
                                            LinearGradient(gradient:
                                                                    Gradient(colors: [Color(gympassents[i].colorstring ?? "blue"),
                                                                                      Color(gympassents[i].colorstring ?? "blue").opacity(0.8),
                                                                                      Color(gympassents[i].colorstring ?? "blue")]),
                                                                                      startPoint: .top, endPoint: .bottom
                                                                                     )
                                            .cornerRadius(5)
                                        )
                                }
                            )
                            //{
                                //HStack {
                                    ///Capsule()
                                       // .frame(width: 4)
                                        //.foregroundColor(.accentColor)

                                    
                                //}

                           // }
                        }
                        .onDelete(perform: deleteGympassEnt)
                    }
                   // .listStyle(.carousel)
                    .frame(height: 500)

                    
                    
                }
            }
            .foregroundColor(.accentColor)
            
            .onAppear(perform: {
                //               loadList()
                whereIsMySQLite()
                updateHeight()

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

