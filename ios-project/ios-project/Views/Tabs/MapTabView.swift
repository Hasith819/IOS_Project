//
//  MapTab.swift
//  ios-project
//
//  Created by student6 on 2026-07-06.
//

import SwiftUI

struct MapTabView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Hello, World!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Map")
                .font(.title)
                .foregroundStyle(.cyan)

            Text("Fixy Automobiles")
                .font(.title3)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

#Preview {
    MapTabView()
}
