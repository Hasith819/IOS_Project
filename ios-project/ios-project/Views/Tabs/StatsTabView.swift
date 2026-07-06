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

    private var sortedSessions: [GameSession] {
        sessions.sorted { $0.timestamp > $1.timestamp }
    }

    private var totalSessions: Int {
        sessions.count
    }

    private var bestSession: GameSession? {
        sessions.max { left, right in
            if left.score == right.score {
                return left.timestamp < right.timestamp
            }

            return left.score < right.score
        }
    }

    private var bestScoresByMode: [(mode: GameMode, score: Int)] {
        GameMode.allCases.map { mode in
            let best = sessions
                .filter { $0.mode == mode }
                .map(\.score)
                .max() ?? 0

            return (mode: mode, score: best)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Game Stats")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Track totals, best runs, and recent sessions.")
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 12) {
                    StatCard(title: "Sessions", value: "\(totalSessions)")

                    StatCard(
                        title: "Best",
                        value: bestSession.map { "\($0.score)" } ?? "0"
                    )
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Best by Mode")
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
                    Text("Sessions by Mode")
                        .font(.headline)

                    if sortedSessions.isEmpty {
                        Text("No sessions yet. Play a game to populate this chart.")
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
                    } else {
                        Chart(sortedSessions.reversed()) { session in
                            BarMark(
                                x: .value("Mode", session.mode.displayName),
                                y: .value("Score", session.score)
                            )
                            .foregroundStyle(by: .value("Mode", session.mode.displayName))
                            .position(by: .value("Session", session.id.uuidString))
                        }
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
                        Text("Latest Session")
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
