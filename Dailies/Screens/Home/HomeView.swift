//
//  HomeView.swift
//  Dailies
//
//  Created by Harrison Javery on 8/28/24.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeVM()
    
    var body: some View {
        let columns = [
            GridItem(.adaptive(minimum: 100))
        ]
        
        
        NavigationStack {
            VStack {  // Use VStack to organize the button and scroll view vertically
                Button {
                    viewModel.showGamesList = true
                } label: {
                    Text("Add Game")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 150)
                }
                .background(Color.green)
                .cornerRadius(8)
                .padding(.horizontal)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(Array(viewModel.dailyGames.enumerated()), id: \.element) { index, game in
                            ZStack {
                                HStack {
                                    NavigationLink(destination: WebViewScreen(games: $viewModel.dailyGames, currentIndex: index)) {
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
                        .navigationTitle("Daily Games")
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            viewModel.dailyGames = UserManager.shared.getDailyGames()
        }
        .sheet(isPresented: $viewModel.showGamesList) {
            GameListView(viewModel: viewModel)
        }
    }
    
}

#Preview {
    HomeView()
}
