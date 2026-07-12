//
//  GameView.swift
//  ios-project
//
//  Created by student6 on 2026-06-13.
//

import SwiftUI

struct LightItUpView: View {
    
    @StateObject private var vm = LightItUpVM()
    
    var body: some View {
        ZStack {
            
            GameBackground()
                .ignoresSafeArea()
            
            VStack{
                
                VStack(spacing: 14) {

                    Text("Light It Up")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)

                    HStack(spacing: 12) {
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("High Score")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text("\(vm.highScore)")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.yellow)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.white.opacity(0.12))
                        )

                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Time")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text("\(vm.timeRemaining)s")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.cyan)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.white.opacity(0.12))
                        )
                    }


                    HStack(spacing: 12) {
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Score")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text("\(vm.score)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.white.opacity(0.12))
                        )


                        VStack(alignment: .leading, spacing: 4) {
                            Text("Level")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text(vm.levelName)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.white.opacity(0.12))
                        )
                    }
                }
                .padding(.top)
               
                 Spacer()
                
                 LazyVGrid(columns: vm.columns, spacing: 16) {
                    ForEach(vm.cards) { card in
                        Button(action: {
                            vm.tapCard(card)
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        card.isLit ?
                                        Color.yellow.opacity(0.85) :
                                        Color.white.opacity(0.25)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(
                                                card.isLit ? Color.yellow : Color.white.opacity(0.2),
                                                lineWidth: 1.5
                                            )
                                    )
                                    .shadow(
                                        color: card.isLit ? Color.yellow.opacity(0.5) : Color.clear,
                                        radius: 12
                                    )
                                
                                if card.isLit {
                                    Image(systemName: "lightbulb.fill")
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .shadow(radius: 2)
                                }
                            }
                            .aspectRatio(1, contentMode: .fit)
                        }
                        .buttonStyle(CardButtonStyle())
                        .scaleEffect(card.isLit ? 1.05 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: card.isLit)
                    }
                 }
                 .padding(.horizontal, 24)
                
                 Spacer()

                 if !vm.gameStarted {
                     Button("Start Game") {
                         vm.startGame()
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
             .onReceive(vm.gameTimer) { _ in
                 vm.handleGameTick()
             }
             .onReceive(vm.tickTimer) { _ in
                 vm.handleTickTimer()
             }
             .onAppear{
                 vm.setLevel(.L1)
             }
             
             if vm.showGameOver {
                 GameOverView(gameName: "Light It Up", score: vm.score, highScore: vm.highScore) {
                     vm.restartGame()
                 }
             }
         }
        
        .toolbar(.hidden, for: .tabBar)
    }
}

struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    LightItUpView()
}
