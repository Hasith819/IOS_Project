//
//  MenuBackground.swift
//  ios-project
//
//  Created by student6 on 2026-07-04.
//

import SwiftUI

struct MenuBackground: View {
    var body: some View {
        ZStack {
        
            LinearGradient(
                colors: [
                    Color.black,
                    Color(red: 0.03, green: 0.03, blue: 0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
           
            LinearGradient(
                colors: [Color.purple.opacity(0.25), Color.clear],
                startPoint: .topTrailing,
                endPoint: .center
            )
            
       
            LinearGradient(
                colors: [Color.blue.opacity(0.22), Color.clear],
                startPoint: .bottomLeading,
                endPoint: .center
            )
            
       
            RadialGradient(
                colors: [Color.pink.opacity(0.15), Color.clear],
                center: .init(x: 0.8, y: 0.6),
                startRadius: 0,
                endRadius: 400
            )
            .blendMode(.plusLighter)
        }
        .ignoresSafeArea()
    }
}

struct MenuBackground_Previews: PreviewProvider {
    static var previews: some View {
        MenuBackground()
    }
}
