//
//  MenuBackground.swift
//  ios-project
//
//  Created by AI Collaborator on 2026-07-12.
//

import SwiftUI

struct MenuBackground: View {
    var body: some View {
        ZStack {
            // 1. Base dark background
            LinearGradient(
                colors: [
                    Color.black,
                    Color(red: 0.03, green: 0.03, blue: 0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // 2. Top-right Purple/Pink ambient glow
            LinearGradient(
                colors: [Color.purple.opacity(0.25), Color.clear],
                startPoint: .topTrailing,
                endPoint: .center
            )
            
            // 3. Bottom-left Blue/Cyan ambient glow
            LinearGradient(
                colors: [Color.blue.opacity(0.22), Color.clear],
                startPoint: .bottomLeading,
                endPoint: .center
            )
            
            // 4. Center-right Pink highlight layer for depth
            RadialGradient(
                colors: [Color.pink.opacity(0.15), Color.clear],
                center: .init(x: 0.8, y: 0.6),
                startRadius: 0,
                endRadius: 400
            )
            .blendMode(.plusLighter) // Makes the overlap look organic and vibrant
        }
        .ignoresSafeArea()
    }
}

// Preview provider so you can check it out in Xcode
struct MenuBackground_Previews: PreviewProvider {
    static var previews: some View {
        MenuBackground()
    }
}
