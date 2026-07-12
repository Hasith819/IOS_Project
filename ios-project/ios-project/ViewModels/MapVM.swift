//
//  MapVM.swift
//  ios-project
//
//  Created by student6 on 2026-07-12.
//

import SwiftUI
import MapKit
import Combine

class MapVM: ObservableObject {
    
    @Published var sessions: [GameSession] = []
    @Published var selectedGroup: LocationGroup?
    
    var groupedSessions: [LocationGroup] {
        let dict = Dictionary(grouping: sessions) { session in
            "\(session.latitude),\(session.longitude)"
        }
        return dict.map { (key, group) in
            LocationGroup(latitude: group[0].latitude, longitude: group[0].longitude, sessions: group)
        }
    }
    
    func loadData() {
        sessions = GameSessionStore.shared.loadSessions()
        LocationService.shared.requestPermission()
    }
}
