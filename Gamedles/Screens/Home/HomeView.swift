//
//  HomeView.swift
//  Dailies
//
//  Created by Harrison Javery on 8/28/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.scenePhase) var scenePhase
    
    @State var showGamesList: Bool = false
    @EnvironmentObject var userManager: UserManager
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        let columns = [
            GridItem(.adaptive(minimum: 150))
        ]
        
        let dailyGames = userManager.games.filter(\.isDailyGame).sorted(by: { $0.name < $1.name })
        
        NavigationStack {
            VStack {
                HStack {
                    Text(formattedDate)
                        .font(.subheadline)
                        .fontWeight(.light)
                    Spacer()
                }
                .padding(.leading, 18)
            }
            
            
            if userManager.games.filter(\.isDailyGame).count == 0 {
                VStack {
                    Spacer()
                    Text("You have not selected any daily games. Add any games you want to play each day to have them appear here and track your scores.")
                        .padding()
                    Spacer()
                }
            }
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(dailyGames.indices, id:\.self) { index in
                        let game = dailyGames[index]
                        if game.isDailyGame {
                            NavigationLink(value: index) {
                                GameGridItem2(game: game, size: .large, showCompleted: true, result: nil)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationDestination(for: Int.self) { index in
                WebViewScreen(index: index, dailiesOnly: true)
            }
            .navigationTitle("Daily Games")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showGamesList = true
                    } label: {
                        Image(systemName: "pencil")
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showGamesList) {
            OnboardingView()
        }
        .onAppear {
            if userManager.showOnboarding{
                showGamesList = true
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                userManager.checkResetGames()
            }
        }
        
        
        
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let userManager = UserManager()
        userManager.games = GameData().games
        userManager.games[0].isDailyGame = true
        userManager.games[1].isDailyGame = true
        userManager.games[2].isDailyGame = true
        
        
        return HomeView()
            .environmentObject(userManager)
    }
    
}
