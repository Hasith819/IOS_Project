//
//  LocationGroup.swift
//  ios-project
//
//  Created by student6 on 2026-07-12.
//

import Foundation
import MapKit

struct LocationGroup: Identifiable, Hashable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
    let sessions: [GameSession]
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func == (lhs: LocationGroup, rhs: LocationGroup) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
