//
//  ContentView.swift
//  ios-project
//
//  Created by student6 on 2026-06-06.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            
            Text("Score:0")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 50)
            
            Spacer()
            
            Button("Tap") {
                
            }
            .font(Font.largeTitle)
            .fontWeight(.bold)
            .frame(width:200, height:200)
            .foregroundStyle(.white)
            .background(.blue)
            .clipShape(Circle())

            Spacer()
            
            Text("Time:10")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.top, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    ContentView()
}
