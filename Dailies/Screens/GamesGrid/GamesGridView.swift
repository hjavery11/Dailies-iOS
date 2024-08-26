//
//  ContentView.swift
//  Dailies
//
//  Created by Harrison Javery on 8/26/24.
//

import SwiftUI

let gridItemWidth: CGFloat = 150
let gridItemHeight: CGFloat = 130

struct GamesGridView: View {
    
    let viewModel = GamesGridVM()
   
    var body: some View {
        let columns = [
            GridItem(.adaptive(minimum: gridItemWidth))
        ]

        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.allGames, id: \.self) { game in
                        NavigationLink(destination: WebViewScreen(game: game)) {
                           GameGridItem(game: game)                               
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Games")
        }
    }
}

#Preview {
    GamesGridView()
}




