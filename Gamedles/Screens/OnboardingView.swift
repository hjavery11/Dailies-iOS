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
    
    //@State var selectAllButton = true

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing:25) {
                    ForEach(Category.allCases) { category in
                        let games = userManager.games.filter {$0.category == category}
                        HStack(alignment: .bottom) {
                            Text(category.rawValue)
                                .bold()
                                .font(.title2)
                                .alignmentGuide(.bottom) { d in d[.lastTextBaseline] } // Align the Text to its last baseline

//                            Button {
//                                for g in games {
//                                    if let index = userManager.games.firstIndex(where: {$0.name == g.name}) {
//                                        userManager.games[index].isDailyGame = selectAllButton
//                                    }
//                                    selectAllButton.toggle()
//                                }
//                            } label: {
//                                Text("\(selectAllButton ? "Select":"Unselect") All")
//                                    .font(.caption2)
//                                    .alignmentGuide(.bottom) { d in d[.lastTextBaseline] } // Align the Button to its last baseline
//                            }
                            Spacer()
                        }
                            
                            ScrollView(.horizontal) {
                                HStack(spacing: 16) {
                                    Spacer()
                                        .frame(width:4)
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
            .padding()
            .navigationTitle("Choose Your Dailies")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                        userManager.showOnboarding = false
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
