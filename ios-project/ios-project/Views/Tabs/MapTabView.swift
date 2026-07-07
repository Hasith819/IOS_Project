//
//  MapTab.swift
//  ios-project
//
//  Created by student6 on 2026-07-06.
//
import SwiftUI
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

struct MapTabView: View {
    @State private var sessions: [GameSession] = []
    @State private var selectedGroup: LocationGroup?
    
    @StateObject private var locationService = LocationService.shared
    
    private var groupedSessions: [LocationGroup] {
        let dict = Dictionary(grouping: sessions) { session in
            "\(session.latitude),\(session.longitude)"
        }
        return dict.map { (key, group) in
            LocationGroup(latitude: group[0].latitude, longitude: group[0].longitude, sessions: group)
        }
    }
    
    var body: some View {
        NavigationStack {
            Map(selection: $selectedGroup) {
                ForEach(groupedSessions) { group in
                    Marker("Play Hub", systemImage: "gamecontroller.fill", coordinate: group.coordinate)
                        .tag(group)
                }
            }
            .sheet(item: $selectedGroup) { group in
                LocationDetailsView(group: group)
                    .presentationDetents([.medium, .large])
            }
            .onAppear {
                sessions = GameSessionStore.shared.loadSessions()
                locationService.requestPermission()
            }
            .navigationTitle("Play Map")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct LocationDetailsView: View {
    let group: LocationGroup
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(group.sessions.sorted(by: { $0.timestamp > $1.timestamp })) { session in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(session.mode.displayName)
                                .font(.headline)
                            Text(session.timestamp, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text("\(session.score)")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Played Here")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    MapTabView()
}
