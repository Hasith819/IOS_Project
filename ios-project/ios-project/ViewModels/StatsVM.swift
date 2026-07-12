//
//  StatsVM.swift
//  ios-project
//
//  Created by student6 on 2026-07-12.
//

import SwiftUI
import Combine

class StatsVM: ObservableObject {
    @Published var sessions: [GameSession] = []

    @AppStorage("TapFrenzyHighScore") private var tapFrenzyHighScore = 0
    @AppStorage("LightItUpHighScore") private var lightItUpHighScore = 0
    @AppStorage("QuizRushHighScore") private var quizRushHighScore = 0

    var sortedSessions: [GameSession] {
        sessions.sorted { $0.timestamp > $1.timestamp }
    }

    var totalSessions: Int {
        sessions.count
    }

    var overallBestScore: Int {
        max(tapFrenzyHighScore, max(lightItUpHighScore, quizRushHighScore))
    }

    var bestScoresByMode: [(mode: GameMode, score: Int)] {
        return [
            (.tapFrenzy, tapFrenzyHighScore),
            (.lightItUp, lightItUpHighScore),
            (.quizRush, quizRushHighScore)
        ]
    }

    func refreshSessions() {
        sessions = GameSessionStore.shared.loadSessions()
    }
}
