//
//  HomeView.swift
//  Dailies
//
//  Created by Harrison Javery on 8/28/24.
//

import SwiftUI

struct HomeView: View {
    
    @State var showGamesList: Bool = false
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        let columns = [
            GridItem(.adaptive(minimum: 100))
        ]
        
        NavigationStack {
            VStack {
                Button {
                    showGamesList = true
                } label: {
                    Text("Add Game")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 150)
                }
                .padding(.horizontal)
                .background(Color.green)
                .cornerRadius(8)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(userManager.games.indices, id:\.self) { index in
                            let game = userManager.games[index]
                            if game.isDailyGame {
                                ZStack {
                                    HStack {
                                        NavigationLink(value: index) {
                                            GameGridItem2(game: game, size: .small, completed: game.completed)
                                        }
                                    }
                                    
                                    if (game.completed) {
                                        Image(systemName: game.won ?? true ?  "checkmark" : "xmark")
                                            .foregroundStyle(game.won ?? true ? Color(.systemGreen) : Color(.systemRed))
                                            .fontWeight(.semibold)
                                            .font(.title)
                                            .background(Color.clear)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationDestination(for: Int.self) { index in
                WebViewScreen(index: index)
            }
            .navigationTitle("Daily Games")            
        }
        .fullScreenCover(isPresented: $showGamesList) {
            //GameListView(viewModel: viewModel)
        }
       
    }
    
}

#Preview {
    HomeView()
}
