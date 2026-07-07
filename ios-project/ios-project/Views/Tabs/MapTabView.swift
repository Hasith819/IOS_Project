//
//  MapTab.swift
//  ios-project
//
//  Created by student6 on 2026-07-06.
//
import SwiftUI
import MapKit


struct MapTabView: View {
    
    @State private var sessions: [GameSession] = []
    
    
    @StateObject private var locationService =
        LocationService.shared
    
    
    var body: some View {
        
        NavigationStack {
            
            Map {
                
                ForEach(sessions) { session in
                    
                    Marker(
                        session.mode.displayName,
                        coordinate: session.coordinate
                    )
                }
            }
   
            .onAppear {
                
                sessions =
                GameSessionStore.shared.loadSessions()
                
                locationService.requestPermission()
            }
        }
    }
}

#Preview {
    MapTabView()
}
