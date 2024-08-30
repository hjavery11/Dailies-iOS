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
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    Text(game.name)
                        .font(.headline)
                        .foregroundStyle(Color(.label))
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding([.top, .leading])
                
                
                Image(game.background ?? "placeholder-bg")
                    .resizable()
                    .aspectRatio((gridItemWidth / gridItemHeight) , contentMode: .fit)
                    .frame(width: gridItemWidth, height: gridItemHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .padding([.top,.bottom],8)
                
                
                Divider()
                
                
                Text(game.description)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color(.label))
                    .lineLimit(2, reservesSpace: true)
                    .padding([.leading, .trailing, .top, .bottom], 8)
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.secondarySystemFill))
            )
        }        
    }
}

#Preview {
    GameGridItem(game: GameData().games.first!)
}
