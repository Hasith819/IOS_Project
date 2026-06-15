//
//  GameView.swift
//  ios-project
//
//  Created by student6 on 2026-06-13.
//

import SwiftUI
import Combine


struct Card: Identifiable {
    var id: Int
    var isLit: Bool
}

struct LightItUpView: View {
    
    @State private var score = 0
    @State private var timeRemaining = 60
    @State private var gameStarted = false
    
    @State private var showGameOver = false
    
    @State private var currentLevel = 1
    @State private var cardInterval = 1.5
    @State private var lastTick = Date()
    
    
    @AppStorage("HighScore")
    var highScore = 0
    
    
    
    @State private var cards: [Card] = [
        Card(id: 0, isLit: false),
        Card(id: 1, isLit: false),
        Card(id: 2, isLit: false),
    ]

    let gameTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var columns: [GridItem] {
        
        if currentLevel == 1 {
            return Array(repeating: GridItem(.flexible()), count: 3 )
        }
        else if currentLevel == 2 {
            return Array(repeating: GridItem(.flexible()), count: 4 )
        }
        else {
            return Array(repeating: GridItem(.flexible()), count: 3)
        }
    }
    
    
    
    var body: some View {
        
        VStack(spacing: 30) {
            
            Text("Light It Up")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Score: \(score)")
                .font(.title)
            
            Text("High Score: \(highScore)")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.orange)
            
            
            Text("Time Remaining: \(timeRemaining)")
                .font(.title2)
            
            
            LazyVGrid(columns: columns, spacing: 20) {
                
                ForEach(cards) { card in
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(card.isLit ? Color.yellow : Color.gray)
                        .scaleEffect(card.isLit ? 1.1 : 1)
                        .animation(.easeInOut, value: card.isLit)
                        .frame(width: 90, height: 90)
                    
                        .onTapGesture {
                            
                            gameStarted = true
                            
                            if timeRemaining > 0{
                                
                                
                                if card.isLit {
                                    score += 1
                                } else {
                                    score -= 1
                                }
                            }
                        }
                }
            }
            
            Text("Level \(currentLevel)")
                .font(.title2)
                .fontWeight(.semibold)
            
        }
        
        .padding()
        
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
            
            guard gameStarted && timeRemaining > 0 else { return }
            
            if Date().timeIntervalSince(lastTick) >= cardInterval {
                lastTick = Date()
                
                for i in cards.indices {
                    cards[i].isLit = false
                }
                
                let index = Int.random(in: 0..<cards.count)
                cards[index].isLit = true
                
            }
        }
        
        
        
        
        .onReceive(gameTimer) { _ in
            
            guard gameStarted && timeRemaining > 0 else { return }
           
        
                timeRemaining -= 1
            
            if timeRemaining == 45 {
                
                currentLevel = 2
                cardInterval = 1.2
                
                cards = [
                    Card(id: 0, isLit: false),
                    Card(id: 1, isLit: false),
                    Card(id: 2, isLit: false),
                    Card(id: 3, isLit: false),
                    
                ]
            }
            
            if timeRemaining == 30 {
                currentLevel = 3
                cardInterval = 1
                
                cards = [
                    Card(id: 0, isLit: false),
                    Card(id: 1, isLit: false),
                    Card(id: 2, isLit: false),
                    Card(id: 3, isLit: false),
                    Card(id: 4, isLit: false),
                    Card(id: 5, isLit: false)
                    
                ]
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
    
    func restartGame() {
        score = 0
        timeRemaining = 60
        showGameOver = false
        
        gameStarted = false
        
        currentLevel = 1
        cardInterval = 1.5
        lastTick = Date()
        
        cards = [
                Card(id: 0, isLit: false),
                Card(id: 1, isLit: false),
                Card(id: 2, isLit: false)
            ]
    }
}

#Preview {
    LightItUpView()
}
