//
//  GameGridItem.swift
//  Dailies
//
//  Created by Harrison Javery on 8/26/24.
//

import SwiftUI

struct GameGridItem: View {
    
    let game: Game
    let titleHeight: CGFloat = 70
    
    var body: some View {
        VStack(spacing: 0) {
                  
                  // Title section with fixed height
                  Text(game.name)
                      .font(.headline)
                      .multilineTextAlignment(.center)
                      .frame(maxWidth: .infinity)
                      .frame(height: titleHeight) // Fixed height for title
                  
                  // Description section with fixed height
                  Text(game.description)
                      .font(.caption)
                      .multilineTextAlignment(.center)
                      .padding([.leading, .trailing], 8)
                  
                  Spacer() // Fills remaining space to align everything consistently
              }
        .foregroundStyle(.black)
        .frame(width: gridItemWidth, height: gridItemHeight)
        .background(
            Image(game.background ?? "placeholder-bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: gridItemWidth, height: gridItemHeight)
                .opacity(0.45)
        )
        .clipped()
        .border(Color(.secondaryLabel))
    }
    
}

#Preview {
    GameGridItem(game: GameData().games.first!)
}
