//
//  ContentView.swift
//  ios-project
//
//  Created by student6 on 2026-06-06.
//

import SwiftUI

struct TapFrenzyView: View {
    
    @StateObject private var vm = TapFrenzyVM()
    
    var body: some View {
        VStack {
            
            Text("Score: \(vm.score)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 50)
            
            
        
            Spacer()
            
            Button("TAP") {
                vm.handleTap()
            }
            .font(Font.largeTitle)
            .fontWeight(.bold)
            .frame(width:200, height:200)
            .foregroundStyle(.white)
            .background(vm.buttonColor)
            .clipShape(Circle())
            .offset(x: vm.xOffset, y: vm.yOffset)

            Spacer()
            
            Text("Time: \(vm.time)")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.top, 20)
            
        }
        
        .onReceive(vm.timer) { _ in
            vm.handleTimerTick()
        }
    
    
        .alert("Game Over", isPresented: $vm.showGameOver) {
            
            Button("Restart") {
                vm.restartGame()
            }
            
            Button("Exit") {
                vm.goToMenu = true
            }
            
        } message: {
            Text("Your score: \(vm.score) \nHighscore: \(vm.highscore)")
        }
        
        .navigationDestination(isPresented: $vm.goToMenu) {
                      HomeTabView()
                  }
        
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    TapFrenzyView()
}
