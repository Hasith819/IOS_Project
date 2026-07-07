//
//  GameSessionStore.swift
//  ios-project
//
//  Created by student6 on 2026-07-06.
//
import Foundation
import CoreLocation

final class GameSessionStore {
    static let shared = GameSessionStore()

    private let sessionsKey = "GameSessions"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private init() {
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }

    func loadSessions() -> [GameSession] {
        guard let data = UserDefaults.standard.data(forKey: sessionsKey) else {
            return []
        }

        return (try? decoder.decode([GameSession].self, from: data)) ?? []
    }

    func appendSession(mode: GameMode, score: Int, location: CLLocation?) {
        var sessions = loadSessions()

        let newSession = GameSession(
            id: UUID(),
            mode: mode,
            score: score,
            timestamp: Date(),
            latitude: location?.coordinate.latitude ?? 0,
            longitude: location?.coordinate.longitude ?? 0
        )

        sessions.append(newSession)
        save(sessions)
    }

    private func save(_ sessions: [GameSession]) {
        guard let data = try? encoder.encode(sessions) else {
            return
        }

        UserDefaults.standard.set(data, forKey: sessionsKey)
    }
    
    func resetAllStats() {
        UserDefaults.standard.removeObject(forKey: sessionsKey)
    }
}
