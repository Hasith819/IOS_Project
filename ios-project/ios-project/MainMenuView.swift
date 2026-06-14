//
//  MainMenuView.swift
//  ios-project
//
//  Created by student6 on 2026-06-13.
//

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationStack {
            VStack (spacing: 30) {
                
                Text("Mini Games")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                NavigationLink("Tap Frenzy") {
                    TapFrenzyView()
                }
                .font(.title2)
                .padding()
                .frame(width: 250)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                
                
                NavigationLink("Light It Up") {
                    LightItUpView()
                }
                .font(.title2)
                .padding()
                .frame(width: 250)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                
            
            }
        }
    }
}

#Preview {
    MainMenuView()
}
