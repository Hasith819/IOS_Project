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
        
        VStack{
            
            VStack(spacing: 20) {

                 Text("Light It Up")
                     .font(.largeTitle)
                     .fontWeight(.bold)
                     .frame(maxWidth: .infinity)
                     .multilineTextAlignment(.center)

                 HStack {
                     Text("High Score: \(vm.highScore)")
                         .font(.subheadline)
                         .foregroundColor(.orange)
                         .fontWeight(.semibold)

                     Spacer()

                     Text("Time: \(vm.timeRemaining)")
                         .font(.subheadline)
                         .foregroundColor(.blue)
                         .fontWeight(.semibold)
                 }
                 .padding(.horizontal)

                 HStack {
                     Text("Score: \(vm.score)")
                         .font(.title2)
                         .fontWeight(.semibold)

                     Spacer()

                     Text(vm.levelName)
                         .font(.title2)
                         .fontWeight(.semibold)
                 }
                 .padding(.horizontal)
             }
             .padding(.top)

           
             Spacer()
            
            
            LazyVGrid(columns: vm.columns, spacing: 15) {
                
                ForEach(vm.cards) { card in
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(card.isLit ? Color.yellow : Color.black)
                        .scaleEffect(card.isLit ? 1.15 : 1)
                        .animation(.easeInOut, value: card.isLit)
                        .frame(width: 90, height: 90)
                    
                        .onTapGesture {
                            vm.tapCard(card)
                        }
                }
            }
            
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
        
        .alert("Game Over", isPresented: $vm.showGameOver){
            
            Button("Restart") {
                vm.restartGame()
            }
            
            Button("Exit") {
                vm.goToMenu = true
            }
            
            
        } message: {
            Text("Score: \(vm.score) \nHigh Score: \(vm.highScore)")
        }
        
        
        .navigationDestination(isPresented: $vm.goToMenu) {
                      HomeTabView()
                  }
        
        
        .onAppear{
            vm.setLevel(.L1)
        }
        
    }
}

#Preview {
    LightItUpView()
}
