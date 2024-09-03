//
//  OnboardingView.swift
//  Gamedles
//
//  Created by Harrison Javery on 9/3/24.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var userManager: UserManager

    var body: some View {
        ScrollView {
            VStack(spacing:25) {
                ForEach(Category.allCases) { category in
                    let games = userManager.games.filter {$0.category == category}
                    VStack {
                        HStack {
                            Text(category.rawValue)
                                .bold()
                                .font(.title2)
                            Spacer()
                        }
                        
                        ScrollView(.horizontal) {
                            HStack(spacing: 15) {
                                ForEach(games) { game in
                                    GameGridItem2(game: game, size: .small, showCompleted: false)
                                }
                            }
                        }
                    }
                    
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView().environmentObject(UserManager())

    }
}
