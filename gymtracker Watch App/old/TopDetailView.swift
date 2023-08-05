//
//  TopDetailView.swift
//  gymtracker Watch App
//
//  Created by Olof Jonsson on 2023-08-01.
//

import SwiftUI

struct TopDetailView: View {
    
    let topnote: GymPass
    let count: Int
    let index: Int
    
    @State private var isCreditsPresented: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 3) {
            HeaderView(title: "")
            Spacer()
            ScrollView(.vertical) {
                Text(topnote.text)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
              //  DetailView()
                
            }
            Spacer()
            HStack(alignment: .center) {
                Image(systemName: "gear")
                    .imageScale(.large)
                Spacer()
                Text("\(count) / \(index + 1)")
                Spacer()
                Image(systemName: "info.circle")
                    .imageScale(.large)
                    .onTapGesture {
                        isCreditsPresented.toggle()
                    }
                    .sheet(isPresented: $isCreditsPresented, content: {
                        CreditsView()
                    })
                
            }
            .foregroundColor(.secondary)
            
        }
        .padding(3)
    }
}

struct TopDetailView_Previews: PreviewProvider {
    static var sampleNote: Exercise = Exercise(id: UUID(), text: "herru word", sets: [GymSet(id: UUID(), reps: 10, weight: 30)])
    static var sampleNote2: Exercise = Exercise(id: UUID(), text: "herru herru", sets: [GymSet(id: UUID(), reps: 10, weight: 30)])

    static var sampleData: GymPass = GymPass(id: UUID(), text: "herru word", exercises: [sampleNote, sampleNote2])
    static var previews: some View {
        TopDetailView(topnote: sampleData, count: 5, index: 1)
    }
}
