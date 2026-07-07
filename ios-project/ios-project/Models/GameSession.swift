//
//  GameSession.swift
//  ios-project
//
//  Created by student6 on 2026-07-06.
//

import Foundation
import CoreLocation

enum GameMode: String, Codable, CaseIterable, Identifiable {
    
    case tapFrenzy
    case lightItUp
    case quizRush
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .tapFrenzy:
            return "Tap Frenzy"
        case .lightItUp:
            return "Light It Up"
        case .quizRush:
            return "Quiz Rush"
        }
    }
    
}

struct GameSession: Codable, Identifiable {
    var id: UUID
    var mode: GameMode
    let score: Int
    let timestamp: Date
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
    }
}
