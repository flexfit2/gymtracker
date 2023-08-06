//
//  HeaderView.swift
//  gymtracker Watch App
//
//  Created by Olof Jonsson on 2023-08-01.
//

import SwiftUI

struct HeaderView: View {
    
    var title: String = ""
    
    var body: some View {
        VStack {
            if title != "" {
                Text(title.uppercased())
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.accentColor)
                
            }
              HStack {
                Capsule()
                      .frame(height: 0.5)
                  Image(systemName: "note.text")
                      .imageScale(.small)
                Capsule()
                      .frame(height: 0.5)
              
            }
            .accentColor(.accentColor)
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
            HeaderView(title: "Credits")
    }
}
