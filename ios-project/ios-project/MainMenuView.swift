//
//  MainMenuView.swift
//  ios-project
//
//  Created by student6 on 2026-06-13.
//

import SwiftUI

struct MainMenuView: View {
    
    
    @AppStorage("TapFrenzyHighScore")
    var highScore1 = 0
    
    @AppStorage("LightItUpHighScore")
    var highScore2 = 0
    
    @AppStorage("QuizRushHighScore")
    var highScore3 = 0
    
    
    
    
    
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
                .background(Color.cyan)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                
                
                NavigationLink("Quiz Rush") {
                    QuizRushView()
                }
                .font(.title2)
                .padding()
                .frame(width: 250)
                .background(Color.indigo)
                .foregroundColor(Color.white)
                .cornerRadius(10)
            
            }
            
            Spacer().frame(height: 70)
            
            
            Text("Tap Frenzy High Score: \(highScore1)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("Light It Up High Score: \(highScore2)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("Quiz Rush High Score: \(highScore3)")
                .font(.subheadline)
                .foregroundColor(.gray)

        }
    }
}

#Preview {
    MainMenuView()
}
