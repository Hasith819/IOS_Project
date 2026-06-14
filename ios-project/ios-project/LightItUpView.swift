//
//  GameView.swift
//  ios-project
//
//  Created by student6 on 2026-06-13.
//

import SwiftUI
import Combine

struct LightItUpView: View {
    
    @State private var score = 0
    @State private var timeRemaining = 60
    
    @State private var litCardIndex = 0

    @State private var showGameOver = false
    @State private var highScore = 0
    
    let timer = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()
    let gameTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    func restartGame(){
        score = 0
        timeRemaining = 60
        showGameOver = false
    }
    
    
    
    var body: some View {
        
        VStack(spacing: 30) {
            
            Text("Light It Up")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Score: \(score)")
                .font(.title)
            
            Text("Time Remaining: \(timeRemaining)")
                .font(.title2)
            
            HStack {
                
                ForEach(0..<3) { index in
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(index == litCardIndex ? Color.yellow : Color.gray)
                        .frame(width: 90, height: 90)
                        .onTapGesture {
                            
                            if index == litCardIndex {
                                score += 1
                            }
                        }

                    
                    
                }
                
            }
            
            Text("Level 1")
                .font(.title2)
                .fontWeight(.semibold)
            
            .onReceive(timer) { _ in
                litCardIndex = Int.random(in: 0..<3)
            }
            
            .onReceive(gameTimer) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                }
                
                if timeRemaining == 0 {
                    showGameOver = true
                    
                    if score > highScore {
                        highScore = score
                    }
                }
            }
            
            .alert("Game Over", isPresented: $showGameOver){
                
                Button("Restart") {
                    restartGame()
                }
            } message: {
                Text("Score: \(score) \nHigh Score: \(highScore)")
            }
            
           
        }
        .padding()
    }
}

#Preview {
    LightItUpView()
}
