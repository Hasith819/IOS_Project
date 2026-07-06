//
//  LightItUpVM.swift
//  ios-project
//
//  Created by student6 on 2026-07-06.
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

class LightItUpVM: ObservableObject {
    
    @Published var score = 0
    @Published var timeRemaining = 60
    @Published var gameStarted = false
    
    @Published var showGameOver = false
    
    @Published var currentLevel: GameLevel = .L1
    @Published var cardInterval = 1.5
    @Published var lastTick = Date()
    
    @Published var goToMenu = false
    
    
    @Published var highScore: Int = UserDefaults.standard.integer(forKey: "LightItUpHighScore") {
        didSet {
            UserDefaults.standard.set(highScore, forKey: "LightItUpHighScore")
        }
    }
    
    
    
    @Published var cards: [Card] = (0..<3).map { Card(id: $0, isLit: false)}

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
    
    
    func startGame() {
        gameStarted = true
        lastTick = Date()
    }
    
    
    func tapCard(_ card: Card) {
        guard timeRemaining > 0 else { return }
        
        if card.isLit {
            score += 1
        } else {
            score -= 1
        }
    }
    
    
    func handleGameTick() {
        
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
    
    
    func handleTickTimer() {
        
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
