//
//  GameOverView.swift
//  ios-project
//
//  Created by student6 on 2026-07-07.
//

import SwiftUI

struct GameOverView: View {
    var title: String = "Game Over"
    var gameName: String
    let score: Int
    let highScore: Int
    let onRestart: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text(title)
                    .font(.system(.title, design: .rounded))
                    .bold()
                    .foregroundColor(.white)
                
                
                VStack(spacing: 6) {
                    Text("Score")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("\(score)")
                        .font(.system(size: 54, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 6) {
                        Image(systemName: "trophy.fill")
                        Text("High Score: \(highScore)")
                    }
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                    .padding(.top, 4)
                }
                .padding(.vertical, 4)
                
           
                VStack(spacing: 10) {
                 
                    Button(action: onRestart) {
                        Text("Restart")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.blue.gradient)
                            .cornerRadius(12)
                    }
                    
                  
                    ShareLink(item: "I just scored \(score) on \(gameName) — beat that!") {
                        HStack(spacing: 6) {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share")
                        }
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.green.gradient)
                        .cornerRadius(12)
                    }
                    
                 
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Exit")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.red.gradient)
                            .cornerRadius(12)
                    }
                }
            }
            .padding(24)
            .frame(maxWidth: 300) 
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.black.opacity(0.85))
            )
            .cornerRadius(24)
            .shadow(color: Color.black.opacity(0.35), radius: 25, x: 0, y: 10)
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    GameOverView(gameName: "Quiz Rush", score: 120, highScore: 150) {
        print("Restart tapped")
    }
}
