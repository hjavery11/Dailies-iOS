//
//  GameGridItem2.swift
//  Dailies
//
//  Created by Harrison Javery on 8/28/24.
//

import SwiftUI

struct GameGridItem2: View {
    let game: Game
    
    enum Size {
        case small,large
    }
    
    let size: Size
    
    let showCompleted: Bool
    let forceCompleted: Bool
    
    var side: CGFloat {
        switch size {
        case .small:
            return 100
        case .large:
            return 175
        }
    }
    
    var titleFont: Font {
        switch size {
        case .small:
            return .caption2
        case .large:
            return .subheadline
        }
    }
    
    var padding: CGFloat {
        switch size {
        case .small:
            return 4
        case .large:
            return 8
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.tertiaryLabel), lineWidth: 1)
               
            if ((game.completed && showCompleted) || forceCompleted) {
                Image(systemName: game.won ?? true ?  "checkmark" : "xmark")
                    .foregroundStyle(game.won ?? true ? Color(.systemGreen) : Color(.systemRed))
                    .fontWeight(.semibold)
                    .font(.title)
                    .background(Color.clear)
            }
            
            VStack(spacing:0) {
                Image(game.background ?? "placeholder-bg")
                    .resizable()
                    .mask(RoundedCornerMask(corners: [.topLeft, .topRight], radius: 8))
                    .opacity((showCompleted && game.completed) || forceCompleted ? 0.3:1)
                
               
               
                Rectangle()
                    .fill(Color(.tertiaryLabel))
                    .frame(height:1)
                
                HStack {
                    Text(game.name)
                        .font(titleFont)
                        .fontWeight(.regular)
                        .padding(EdgeInsets(top: padding, leading: 8, bottom: padding, trailing: 0))
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if size == .large {
                        Image(systemName: "chevron.right")
                            .font(titleFont)
                            .fontWeight(.light)
                            .padding(.trailing, 10)
                    }
                }
                .foregroundStyle(Color(.label))
            }
            
        }
        .frame(width: side, height: side)
    }
}

struct RoundedCornerMask: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

