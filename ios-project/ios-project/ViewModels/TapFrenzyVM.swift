//
//  TapFrenzyVM.swift
//  ios-project
//
//  Created by student6 on 2026-07-06.
//

import SwiftUI
import Combine

class TapFrenzyVM: ObservableObject {
    
    @Published var score = 0
    @Published var time = 10
    @Published var gamestarted = false
    
    @Published var highscore: Int = UserDefaults.standard.integer(forKey: "TapFrenzyHighScore") {
        didSet {
            UserDefaults.standard.set(highscore, forKey: "TapFrenzyHighScore")
        }
    }
    
    @Published var showGameOver = false
    
    @Published var combo = 1
    @Published var lastTapTime = Date()
    
    @Published var xOffset: CGFloat = 0
    @Published var yOffset: CGFloat = 0
    
    @Published var buttonColor: Color = .blue
    
    @Published var goToMenu = false
    
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func restartGame() {
        time = 10
        score = 0
        gamestarted = false
        combo = 1
        lastTapTime = Date()
        xOffset = 0
        yOffset = 0
        buttonColor = .blue
    }
    
    func handleTap() {
        
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
    
    func handleTimerTick() {
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
}

