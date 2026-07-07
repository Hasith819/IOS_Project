//
//  StatsTab.swift
//  ios-project
//
//  Created by student6 on 2026-07-06.
//
import SwiftUI
import Charts

struct StatsTabView: View {
    @State private var sessions: [GameSession] = GameSessionStore.shared.loadSessions()

    @AppStorage("TapFrenzyHighScore") private var tapFrenzyHighScore = 0
    @AppStorage("LightItUpHighScore") private var lightItUpHighScore = 0
    @AppStorage("QuizRushHighScore") private var quizRushHighScore = 0

    private var sortedSessions: [GameSession] {
        sessions.sorted { $0.timestamp > $1.timestamp }
    }

    private var totalSessions: Int {
        sessions.count
    }

    private var overallBestScore: Int {
        max(tapFrenzyHighScore, max(lightItUpHighScore, quizRushHighScore))
    }

    private var bestScoresByMode: [(mode: GameMode, score: Int)] {
        return [
            (.tapFrenzy, tapFrenzyHighScore),
            (.lightItUp, lightItUpHighScore),
            (.quizRush, quizRushHighScore)
        ]
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                 

                }

                HStack(spacing: 12) {
                    StatCard(title: "Total Plays", value: "\(totalSessions)")

                    StatCard(
                        title: "Best",
                        value: "\(overallBestScore)"
                    )
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Best by Games")
                        .font(.headline)

                    VStack(spacing: 10) {
                        ForEach(bestScoresByMode, id: \.mode) { item in
                            HStack {
                                Text(item.mode.displayName)
                                Spacer()
                                Text("\(item.score)")
                                    .fontWeight(.semibold)
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Game Sessions")
                        .font(.headline)

                    if sortedSessions.isEmpty {
                        Text("No games played yet. Play a game to populate this chart.")
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
                    } else {
                        Chart(Array(sortedSessions.reversed().enumerated()), id: \.element.id) { index, session in
                            BarMark(
                                x: .value("Session", index),
                                y: .value("Score", session.score)
                            )
                            .foregroundStyle(by: .value("Mode", session.mode.displayName))
                        }
                        .chartXAxis(.hidden)
                        .frame(height: 240)
                        .chartLegend(position: .bottom, alignment: .leading)
                        .padding()
                        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent Games")
                        .font(.headline)

                    if sortedSessions.isEmpty {
                        Text("No completed games yet.")
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(sortedSessions.prefix(10)) { session in
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(session.mode.displayName)
                                            .font(.headline)

                                        Text(session.timestamp, style: .date)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }

                                    Spacer()

                                    Text("\(session.score)")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14))
                            }
                        }
                    }
                }

                if let latest = sortedSessions.first {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Latest Played")
                            .font(.headline)

                        Text("\(latest.mode.displayName) - Score \(latest.score)")
                        Text(latest.timestamp, style: .date)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
                }

                Spacer(minLength: 0)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.white)
        .onAppear {
            sessions = GameSessionStore.shared.loadSessions()
        }
    }
}

private struct StatCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    StatsTabView()
}
