//
//  ContentView.swift
//  ios-project
//
//  Created by student6 on 2026-06-06.
//

import SwiftUI
import Combine

struct TapFrenzyView: View {
    
    @State private var score = 0
    @State private var time = 10
    @State private var gamestarted = false
    
    @AppStorage("TapFrenzyHighScore")
    var highscore = 0
    
    @State private var showGameOver = false
    
    @State private var combo = 1
    @State private var lastTapTime = Date()
    
    @State private var xOffset: CGFloat = 0
    @State private var yOffset: CGFloat = 0
    
    @State private var buttonColor: Color = .blue
    
    @State private var goToMenu = false
    
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func restartGame() {
        time = 10
        score = 0
        gamestarted=false
        combo = 1
        lastTapTime = Date()
        xOffset = 0
        yOffset = 0
        buttonColor = .blue
    }
    
    var body: some View {
        VStack {
            
            Text("Score: \(score)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 50)
            
            
        
            Spacer()
            
            Button("TAP") {
                
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
                    
                    if buttonColor == .green {
                        score += combo + 2
                    }
                    else if buttonColor == .gray {
                        score -= 2
                    }
                    else {
                        score += combo
                    }
                }
                
            }
            .font(Font.largeTitle)
            .fontWeight(.bold)
            .frame(width:200, height:200)
            .foregroundStyle(.white)
            .background(buttonColor)
            .clipShape(Circle())
            .offset(x: xOffset, y: yOffset)

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
            
            if gamestarted && time > 0 && time % 2 == 0 {
                withAnimation {
                    xOffset = CGFloat.random(in: -120...120)
                    yOffset = CGFloat.random(in: -120...120)
                }
            }
            
            if time == 0 && gamestarted {
                
                gamestarted = false
                showGameOver = true
                
                if score > highscore {
                    highscore = score
                }

            }
            
            if gamestarted && time > 0 && time % 2 == 0 {
                let random = Int.random(in: 0...2)
                withAnimation {
                    if random == 0 {
                        buttonColor = .blue
                    } else if random == 1 {
                        buttonColor = .green
                    } else {
                        buttonColor = .gray
                    }
                }
                
            }
            
            
        }
    
    
        .alert("Game Over", isPresented: $showGameOver) {
            
            Button("Restart") {
                restartGame()
            }
            
            Button("Exit") {
                goToMenu = true
            }
            
        } message: {
            Text("Your score: \(score) \nHighscore: \(highscore)")
        }
        
        .navigationDestination(isPresented: $goToMenu) {
                      MainMenuView()
                  }
        
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    TapFrenzyView()
}
