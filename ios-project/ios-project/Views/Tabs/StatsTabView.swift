//
//  StatsTab.swift
//  ios-project
//
//  Created by student6 on 2026-07-06.
//
import SwiftUI
import Charts

struct StatsTabView: View {
    @StateObject private var viewModel = StatsVM()

    var body: some View {
        ZStack {
            MenuBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    Text("Statistics")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .padding(.top, 20)

                    HStack(spacing: 12) {
                        StatCard(title: "Total Plays", value: "\(viewModel.totalSessions)")

                        StatCard(
                            title: "Best Score",
                            value: "\(viewModel.overallBestScore)"
                        )
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Best by Games")
                            .font(.headline)
                            .foregroundColor(.white)

                        VStack(spacing: 10) {
                            ForEach(viewModel.bestScoresByMode, id: \.mode) { item in
                                HStack {
                                    Text(item.mode.displayName)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(item.score)")
                                        .foregroundColor(.white)
                                        .fontWeight(.semibold)
                                }
                                .padding()
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Game Sessions")
                            .font(.headline)
                            .foregroundColor(.white)

                        if viewModel.sortedSessions.isEmpty {
                            Text("No games played yet. Play a game to populate this chart.")
                                .foregroundStyle(.white.opacity(0.6))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                        } else {
                            Chart(Array(viewModel.sortedSessions.reversed().enumerated()), id: \.element.id) { index, session in
                                BarMark(
                                    x: .value("Session", index),
                                    y: .value("Score", session.score)
                                )
                                .foregroundStyle(by: .value("Mode", session.mode.displayName))
                            }
                            .chartXAxis(.hidden)
                            .frame(height: 240)
                            .chartLegend(position: .bottom, alignment: .leading)
                            .colorScheme(.dark)
                            .padding()
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Games")
                            .font(.headline)
                            .foregroundColor(.white)

                        if viewModel.sortedSessions.isEmpty {
                            Text("No completed games yet.")
                                .foregroundStyle(.white.opacity(0.6))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.sortedSessions.prefix(10)) { session in
                                    HStack(alignment: .top) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(session.mode.displayName)
                                                .font(.headline)
                                                .foregroundColor(.white)

                                            Text(session.timestamp, style: .date)
                                                .font(.caption)
                                                .foregroundStyle(.white.opacity(0.6))
                                        }

                                        Spacer()

                                        Text("\(session.score)")
                                            .font(.title3)
                                            .foregroundColor(.white)
                                            .fontWeight(.semibold)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                                }
                            }
                        }
                    }

                    if let latest = viewModel.sortedSessions.first {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Latest Played")
                                .font(.headline)
                                .foregroundColor(.white)

                            Text("\(latest.mode.displayName) - Score \(latest.score)")
                                .foregroundColor(.white)
                            Text(latest.timestamp, style: .date)
                                .foregroundStyle(.white.opacity(0.6))
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    }

                    Spacer(minLength: 0)
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .onAppear {
            viewModel.refreshSessions()
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
                .foregroundStyle(.white.opacity(0.7))

            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    StatsTabView()
}
