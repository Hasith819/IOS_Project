//
//  HomeTab.swift
//  ios-project
//
//  Created by student6 on 2026-07-06.
//
import SwiftUI

struct HomeTabView: View {

    @StateObject private var viewModel = HomeViewModel()

    @AppStorage("TapFrenzyHighScore") private var tapFrenzyHighScore = 0
    @AppStorage("LightItUpHighScore") private var lightItUpHighScore = 0
    @AppStorage("QuizRushHighScore") private var quizRushHighScore = 0

    @AppStorage("dailyChallengeDate") private var dailyChallengeDateStr = ""
    @AppStorage("dailyChallengeModeRaw") private var dailyChallengeModeRaw = GameMode.tapFrenzy.rawValue

    private var challengeMode: GameMode {
        GameMode(rawValue: dailyChallengeModeRaw) ?? .tapFrenzy
    }

    var body: some View {
        ZStack {
            
            MenuBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {

                    headerView

                    dailyChallengeView

                    NavigationLink {
                        TapFrenzyView()
                    } label: {
                        homeCard(
                            title: "Tap Frenzy",
                            subtitle: "Quick taps, fast score.",
                            icon: "hand.tap.fill",
                            color: .blue
                        )
                    }

                    NavigationLink {
                        LightItUpView()
                    } label: {
                        homeCard(
                            title: "Light It Up",
                            subtitle: "Find the lit tile before time runs out.",
                            icon: "lightbulb.fill",
                            color: .cyan
                        )
                    }

                    NavigationLink {
                        QuizRushView()
                    } label: {
                        homeCard(
                            title: "Quiz Rush",
                            subtitle: "Answer fast and build streaks.",
                            icon: "text.book.closed.fill",
                            color: .indigo
                        )
                    }

                    HStack(spacing: 12) {

                        scoreTile(
                            gameName: "Tap Frenzy",
                            score: tapFrenzyHighScore,
                            icon: "hand.tap.fill",
                            color: .blue
                        )

                        scoreTile(
                            gameName: "Light It Up",
                            score: lightItUpHighScore,
                            icon: "lightbulb.fill",
                            color: .cyan
                        )

                        scoreTile(
                            gameName: "Quiz Rush",
                            score: quizRushHighScore,
                            icon: "text.book.closed.fill",
                            color: .indigo
                        )
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.checkDailyChallenge(
                dailyChallengeDateStr: &dailyChallengeDateStr,
                dailyChallengeModeRaw: &dailyChallengeModeRaw
            )
        }
    }

    @ViewBuilder
    private var dailyChallengeView: some View {

        if viewModel.dailyChallengeCompleted {

            HStack(spacing: 12) {

                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.green)
                    .font(.largeTitle)

                VStack(alignment: .leading, spacing: 4) {

                    Text("Daily Challenge Completed!")
                        .font(.headline)
                        .foregroundColor(.white)

                    Text("Great job playing \(challengeMode.displayName) today.")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }

                Spacer()
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))

        } else {

            VStack(alignment: .leading, spacing: 12) {

                HStack {

                    Image(systemName: "star.fill")
                        .foregroundColor(.orange)

                    Text("Daily Challenge")
                        .font(.headline)
                        .foregroundColor(.white)
                }

                Text("Play a game of \(challengeMode.displayName) to complete today's challenge!")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))

                NavigationLink {

                    switch challengeMode {

                    case .tapFrenzy:
                        TapFrenzyView()

                    case .lightItUp:
                        LightItUpView()

                    case .quizRush:
                        QuizRushView()
                    }

                } label: {

                    Text("Play Now")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.orange.gradient)
                        .cornerRadius(12)
                }
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        }
    }

    private var headerView: some View {

        VStack(spacing: 8) {

            Text("PlayHub")
                .font(.largeTitle.bold())
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 20)
    }

    private func homeCard(
        title: String,
        subtitle: String,
        icon: String,
        color: Color
    ) -> some View {

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
        .background(
            color.gradient.opacity(0.85),
            in: RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
        )
    }

    private func scoreTile(
        gameName: String,
        score: Int,
        icon: String,
        color: Color
    ) -> some View {

        VStack(spacing: 8) {

            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)

            Text(gameName)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)

            Text("\(score)")
                .font(.title2.bold())
                .foregroundColor(.white)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 4)
        .frame(maxWidth: .infinity)
        .aspectRatio(1.0, contentMode: .fit)
        .background(
            .ultraThinMaterial, 
            in: RoundedRectangle(
                cornerRadius: 16,
                style: .continuous
            )
        )
    }
}

#Preview {
    HomeTabView()
}
