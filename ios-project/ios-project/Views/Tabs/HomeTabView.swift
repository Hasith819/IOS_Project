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
                    homeCard(title: "Tap Frenzy", subtitle: "Quick taps, fast score.", color: .blue)
                }

                NavigationLink {
                    LightItUpView()
                } label: {
                    homeCard(title: "Light It Up", subtitle: "Find the lit tile before time runs out.", color: .cyan)
                }

                NavigationLink {
                    QuizRushView()
                } label: {
                    homeCard(title: "Quiz Rush", subtitle: "Answer fast and build streaks.", color: .indigo)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("High Scores")
                        .font(.headline)

                    Text("Tap Frenzy: \(highScore1)")
                    Text("Light It Up: \(highScore2)")
                    Text("Quiz Rush: \(highScore3)")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            .padding()
        }
        .navigationTitle("Home")
    }

    private func homeCard(title: String, subtitle: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title2.bold())
                .foregroundStyle(.white)
            Text(subtitle)
                .foregroundStyle(.white.opacity(0.9))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(color.gradient, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

#Preview {
    HomeTabView()
}
