//
//  AnimatedBackground.swift
//  ios-project
//
//  Created by student6 on 2026-07-04.
//

import SwiftUI


struct AnimatedBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.white,
                    Color(red: 0.05, green: 0.05, blue: 0.05)
        ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
                )
            .ignoresSafeArea()
            
            Circle()
                .fill(Color.purple.opacity(0.35))
                .frame(width: 300, height: 300)
                .blur(radius: 60)
                .offset(x: animate ? -120 : 120, y: -200)
            
            Circle()
                .fill(Color.blue.opacity(0.35))
                .frame(width: 350, height: 350)
                .blur(radius: 70)
                .offset(x: animate ? 150 : -150, y: 250)
            
            Circle()
                .fill(Color.pink.opacity(0.25))
                .frame(width: 280, height: 280)
                .blur(radius: 50)
                .offset(x: animate ? -180 : 180, y: 100)
               
                }
        .onAppear {
            withAnimation(.easeInOut(duration: 6)
                .repeatForever(autoreverses: true)){
                animate.toggle()
            }
        }
        }
}
