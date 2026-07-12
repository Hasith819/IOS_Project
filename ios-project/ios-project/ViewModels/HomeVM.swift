//
//  HomeVM.swift
//  ios-project
//
//  Created by student6 on 2026-07-12.
//


import SwiftUI
import Combine

final class HomeViewModel: ObservableObject {

    @Published var dailyChallengeCompleted = false

    func checkDailyChallenge(
        dailyChallengeDateStr: inout String,
        dailyChallengeModeRaw: inout String
    ) {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let today = formatter.string(from: Date())

        if dailyChallengeDateStr != today {
            dailyChallengeDateStr = today
            dailyChallengeModeRaw = GameMode.allCases.randomElement()!.rawValue
            dailyChallengeCompleted = false
        }

        let challengeMode = GameMode(rawValue: dailyChallengeModeRaw) ?? .tapFrenzy

        let sessions = GameSessionStore.shared.loadSessions()

        let hasPlayedToday = sessions.contains { session in
            session.mode == challengeMode &&
            formatter.string(from: session.timestamp) == today
        }

        dailyChallengeCompleted = hasPlayedToday
    }
}
