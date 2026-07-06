//
//  HomeTab.swift
//  ios-project
//
//  Created by student6 on 2026-07-06.
//
import SwiftUI

struct HomeTabView: View {
    @AppStorage("TapFrenzyHighScore") var highScore1 = 0
    @AppStorage("LightItUpHighScore") var highScore2 = 0
    @AppStorage("QuizRushHighScore") var highScore3 = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("PlayHub")
                        .font(.largeTitle.bold())

                    Text("Crazy games. One polished shell.")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 20)

        
                NavigationLink {
                    TapFrenzyView()
                } label: {
                    homeCard(title: "Tap Frenzy", subtitle: "Quick taps, fast score.", icon: "hand.tap.fill", color: .blue)
                }

                NavigationLink {
                    LightItUpView()
                } label: {
                    homeCard(title: "Light It Up", subtitle: "Find the lit tile before time runs out.", icon: "lightbulb.fill", color: .cyan)
                }

                NavigationLink {
                    QuizRushView()
                } label: {
                    homeCard(title: "Quiz Rush", subtitle: "Answer fast and build streaks.", icon: "text.book.closed.fill", color: .indigo)
                }

                    
                
                    HStack(spacing: 12) {
                        scoreTile(gameName: "Tap Frenzy", score: highScore1, icon: "hand.tap.fill", color: .blue)
                        scoreTile(gameName: "Light It Up", score: highScore2, icon: "lightbulb.fill", color: .cyan)
                        scoreTile(gameName: "Quiz Rush", score: highScore3, icon: "text.book.closed.fill", color: .indigo)
                    }
                .frame(maxWidth: .infinity)
            }
            .padding()
        }
    }

    
    private func homeCard(title: String, subtitle: String, icon: String, color: Color) -> some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                Text(subtitle)
                    .foregroundStyle(.white.opacity(0.9))
                    .font(.subheadline)
            }
            
            Spacer()
            
      
            Image(systemName: icon)
                .font(.title)
                .bold()
                .foregroundStyle(.white)
                .padding(.trailing, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(color.gradient, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private func scoreTile(gameName: String, score: Int, icon: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            
            Text(gameName)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
            
            Text("\(score)")
                .font(.title2.bold())
                .foregroundColor(.primary)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 4)
        .frame(maxWidth: .infinity)
        .aspectRatio(1.0, contentMode: .fit)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    HomeTabView()
}
