//
//  ContentView.swift
//  ios-project
//
//  Created by student6 on 2026-06-06.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @State private var score = 0
    @State private var time = 10
    @State private var gamestarted = false
    @State private var highscore = 0
    @State private var showGameOver = false
    
    @State private var combo = 1
    @State private var lastTapTime = Date()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func restartGame() {
        time = 10
        score = 0
        gamestarted=false
        combo = 1
        lastTapTime = Date()
    }
    
    var body: some View {
        VStack {
            
            Text("Score: \(score)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 50)
            
        
            Spacer()
            
            Button("Tap") {
                
                let now = Date()
                let diff = now.timeIntervalSince(lastTapTime)
                
                if diff <= 0.5 {
                    combo += 1
                } else {
                    combo = 1
                }
                
                lastTapTime = now
                
                if !gamestarted {
                    gamestarted = true
                }
                
                if time > 0 {
                    score += combo
                }
                
            }
            .font(Font.largeTitle)
            .fontWeight(.bold)
            .frame(width:200, height:200)
            .foregroundStyle(.white)
            .background(.green)
            .clipShape(Circle())

            Spacer()
            
            Text("Time: \(time)")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.top, 20)
            
        }
        
        .onReceive(timer) { _ in
            if gamestarted && time > 0 {
                time -= 1
            }
            
            if time == 0 && gamestarted {
                
                gamestarted = false
                showGameOver = true
                
                if score > highscore {
                    highscore = score
                }
                
                
            }
        }
    
    
        .alert("Game Over", isPresented: $showGameOver) {
            
            Button("Restart") {
                restartGame()
            }
            
        } message: {
            Text("Your score: \(score) \nHighscore: \(highscore)")
        }
        
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    ContentView()
}
