//
//  OnboardingView.swift
//  Gamedles
//
//  Created by Harrison Javery on 9/3/24.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userManager: UserManager

    var body: some View {
        NavigationStack {
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
                                        ZStack {
                                            GameGridItem2(game: game, size: .small, showCompleted: false)
                                                .opacity(game.isDailyGame ? 0.5:1)
                                                .onTapGesture {
                                                    if let index = userManager.games.firstIndex(where: { $0.name == game.name }) {
                                                        userManager.games[index].isDailyGame.toggle()
                                                    }
                                                }
                                            
                                            if game.isDailyGame {
                                                Image(systemName: "checkmark" )
                                                    .foregroundStyle(Color(.systemGreen))
                                                    .fontWeight(.semibold)
                                                    .font(.title)
                                                    .background(Color.clear)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
            .padding()
            .navigationTitle("Choose Your Dailies")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Text("Done")
                            Image(systemName: "chevron.right")
                                .imageScale(.medium)
                        }
                    }
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView().environmentObject(UserManager())

    }
}
