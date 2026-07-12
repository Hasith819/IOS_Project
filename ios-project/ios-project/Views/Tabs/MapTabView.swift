//
//  MapTab.swift
//  ios-project
//
//  Created by student6 on 2026-07-06.
//

import SwiftUI
import MapKit

struct MapTabView: View {
    
    @StateObject private var vm = MapVM()
    
    var body: some View {
        NavigationStack {
            Map(selection: $vm.selectedGroup) {
                ForEach(vm.groupedSessions) { group in
                    Marker("Play Hub", systemImage: "gamecontroller.fill", coordinate: group.coordinate)
                        .tag(group)
                        .tint(.purple)
                }
            }
            .sheet(item: $vm.selectedGroup) { group in
                LocationDetailsView(group: group)
                    .presentationDetents([.medium, .large])
            }
            .onAppear {
                vm.loadData()
            }
            .navigationTitle("Play Map")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)        }
    }
}

struct LocationDetailsView: View {
    let group: LocationGroup
    
    var body: some View {
        NavigationStack {
            ZStack {
                MenuBackground()
                
                List {
                    ForEach(group.sessions.sorted(by: { $0.timestamp > $1.timestamp })) { session in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(session.mode.displayName)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Text(session.timestamp, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            
                            Spacer()
                            
                            Text("\(session.score)")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.cyan)
                        }
                        .padding(.vertical, 4)
                        .listRowBackground(Color.white.opacity(0.08))
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Played Here")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    MapTabView()
}
