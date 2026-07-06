//
//  GameView.swift
//  ios-project
//
//  Created by student6 on 2026-06-13.
//

import SwiftUI
import Combine

enum GameLevel {
    case L1, L2, L3, L4
}


struct Card: Identifiable {
    var id: Int
    var isLit: Bool
}

struct LightItUpView: View {
    
    @State private var score = 0
    @State private var timeRemaining = 60
    @State private var gameStarted = false
    
    @State private var showGameOver = false
    
    @State private var currentLevel: GameLevel = .L1
    @State private var cardInterval = 1.5
    @State private var lastTick = Date()
    
    @State private var goToMenu = false
    
    
    @AppStorage("LightItUpHighScore")
    var highScore = 0
    
    
    
    @State private var cards: [Card] = (0..<3).map { Card(id: $0, isLit: false)}

    let gameTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let tickTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    
    var columns: [GridItem] {
        
        switch currentLevel {
        case .L1:
            return Array(repeating: GridItem(.flexible()), count: 3)
        case .L2:
            return Array(repeating: GridItem(.flexible()), count: 2)
        case .L3:
            return Array(repeating: GridItem(.flexible()), count: 3)
        case .L4:
            return Array(repeating: GridItem(.flexible()), count: 3)
        }
    }
    
    var levelName: String {
        switch currentLevel {
        case .L1:
            return "Level 1"
        case .L2:
            return "Level 2"
        case .L3:
            return "Level 3"
        case .L4:
            return "Level 4"
        }
    }
    
    
    
    var body: some View {
        
        VStack{
            
            VStack(spacing: 20) {

                 Text("Light It Up")
                     .font(.largeTitle)
                     .fontWeight(.bold)
                     .frame(maxWidth: .infinity)
                     .multilineTextAlignment(.center)

                 HStack {
                     Text("High Score: \(highScore)")
                         .font(.subheadline)
                         .foregroundColor(.orange)
                         .fontWeight(.semibold)

                     Spacer()

                     Text("Time: \(timeRemaining)")
                         .font(.subheadline)
                         .foregroundColor(.blue)
                         .fontWeight(.semibold)
                 }
                 .padding(.horizontal)

                 HStack {
                     Text("Score: \(score)")
                         .font(.title2)
                         .fontWeight(.semibold)

                     Spacer()

                     Text(levelName)
                         .font(.title2)
                         .fontWeight(.semibold)
                 }
                 .padding(.horizontal)
             }
             .padding(.top)

           
             Spacer()
            
            
            LazyVGrid(columns: columns, spacing: 15) {
                
                ForEach(cards) { card in
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(card.isLit ? Color.yellow : Color.black)
                        .scaleEffect(card.isLit ? 1.15 : 1)
                        .animation(.easeInOut, value: card.isLit)
                        .frame(width: 90, height: 90)
                    
                        .onTapGesture {
                                                        
                            guard timeRemaining > 0 else { return }
                                
                                
                                if card.isLit {
                                    score += 1
                                } else {
                                    score -= 1
                                }
                            }
                        }
                }
            
             Spacer()

             if !gameStarted {
                 Button("Start Game") {
                     gameStarted = true
                     lastTick = Date()
                 }
                 .font(.title2)
                 .padding()
                 .frame(width: 200)
                 .background(Color.blue)
                 .foregroundColor(.white)
                 .cornerRadius(12)
                 .padding(.bottom)
             }
         }
         .padding()
            
        
        
        .onReceive(gameTimer) { _ in
            
            guard gameStarted && timeRemaining > 0 else { return }
           
            timeRemaining -= 1
            
            if timeRemaining == 45 { setLevel(.L2)}
            if timeRemaining == 30 { setLevel(.L3)}
            if timeRemaining == 15 { setLevel(.L4)}
            
            if timeRemaining == 0 {
                showGameOver = true
                
                if score > highScore {
                    highScore = score
                }
            }
        }
        
        
        
        .onReceive(tickTimer) { _ in
            
            guard gameStarted && timeRemaining > 0 else { return }
            
            if Date().timeIntervalSince(lastTick) >= cardInterval {
                lastTick = Date()
                
                for i in cards.indices {
                    cards[i].isLit = false
                }
                
                switch currentLevel {
                    
                case .L4:
                    let first = Int.random(in: 0..<cards.count)
                    var second = Int.random(in: 0..<cards.count)
                    
                    while second == first {
                        
                        second = Int.random(in: 0..<cards.count)
                    }
                    
                    cards[first].isLit = true
                    cards[second].isLit = true
                    
                default:
                    let index = Int.random(in: 0..<cards.count)
                    cards[index].isLit = true
                }
            }
        }
        
        .alert("Game Over", isPresented: $showGameOver){
            
            Button("Restart") {
                restartGame()
            }
            
            Button("Exit") {
                goToMenu = true
            }
            
            
        } message: {
            Text("Score: \(score) \nHigh Score: \(highScore)")
        }
        
        
        .navigationDestination(isPresented: $goToMenu) {
                      HomeTabView()
                  }
        
        
        .onAppear{
            setLevel(.L1)
        }
        
    }
    
    
    func setLevel(_ level: GameLevel) {
            
            currentLevel = level
        
        for i in cards.indices {
            cards[i].isLit = false
        }
            
            switch level {
            case .L1:
                cardInterval = 1.5
                cards = (0..<3).map { Card(id: $0, isLit: false) }
                
            case .L2:
                cardInterval = 1.2
                cards = (0..<4).map { Card(id: $0, isLit: false) }
                
            case .L3:
                cardInterval = 1.0
                cards = (0..<6).map { Card(id: $0, isLit: false) }
                
            case .L4:
                cardInterval = 0.8
                cards = (0..<9).map { Card(id: $0, isLit: false) }
            }
        }
    
    
    
    func restartGame() {
        score = 0
        timeRemaining = 60
        gameStarted = false
        currentLevel = .L1
        cardInterval = 1.5
        lastTick = Date()
        showGameOver = false
        cards = ( 0..<3).map { Card(id: $0, isLit: false)}
    }
}

#Preview {
    LightItUpView()
}
