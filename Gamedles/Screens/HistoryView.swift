//
//  HistoryView.swift
//  Gamedles
//
//  Created by Harrison Javery on 9/4/24.
//

import SwiftUI

struct HistoryView: View {
    
    @EnvironmentObject var userManager: UserManager
    
    @State var dateSelected: Date = .now
    @State var formattedDateDictionary = [Date: History]()
    @State var isLoading = true
    @State var currentIndex: Int = 0
    
    var body: some View {
        let sortedHistoryDictionary =  formattedDateDictionary.sorted { $0.key > $1.key }
        let columns = [
            GridItem(.adaptive(minimum: 100))
        ]        
       
        
        NavigationStack {
            HStack {
                Image(systemName: "chevron.left")
                    .imageScale(.medium)
                    .foregroundStyle(.blue)
                    .onTapGesture {
                        goToPreviousHistory()
                    }
                    .opacity(currentIndex == formattedDateDictionary.count - 1 ? 0:1)
                   
                
                if !isLoading {
                    Text(sortedHistoryDictionary[currentIndex].key, format: Date.FormatStyle().weekday(.wide).month(.wide).day())
                        .font(.subheadline)
                        .fontWeight(.light)
                }
                
                Image(systemName: "chevron.right")
                    .imageScale(.medium)
                    .foregroundStyle(.blue)
                    .onTapGesture {
                        goToNextHistory()
                    }
                    .opacity(currentIndex == 0 ? 0:1)
                
                Spacer()
            }
            .padding(.leading, 18)
            VStack(spacing:16) {
                if !isLoading {
                    LazyVGrid(columns: columns, spacing: 16) {
                        let historyForDaySelected = sortedHistoryDictionary[currentIndex].value
                        ForEach(historyForDaySelected.scores.sorted(by: {$0.key < $1.key}), id:\.key) { gameID, result in
                            if let originalGame = GameData().games.first(where: { $0.name == gameID }) {
                                GameGridItem2(game: originalGame, size: .small, showCompleted: true, result: result)
                            }
                            
                        }
                    }
                }
                Spacer()
                .navigationTitle("Score History")
            }
            .padding()
        }
        .onAppear {
            var gameHistory = [History]()
            #if targetEnvironment(simulator)
            gameHistory = HistoryData().mockData
            #else
            if let data = UserDefaults.standard.data(forKey: Keys.history.rawValue) {
                let decoder = JSONDecoder()
                do {
                    let historyArray = try decoder.decode([History].self, from: data)
                    gameHistory = historyArray
                } catch {
                    print("Error during decoding of history array")
                }
            } else {
                print("No history data found")
            }
            #endif
            //set date to latest available with history
            convertDates(gameHistory)
            isLoading = false
        }
        
    }
    
    func convertDates(_ gameHistory:[History]) {
        let calendar = Calendar.current
        for history in gameHistory {
            let dateString = history.date
            let dateComponents = dateString.components(separatedBy: ", ").compactMap {Int($0)}
            if dateComponents.count == 3 {
                let day = dateComponents[0]
                let month = dateComponents[1]
                let year = dateComponents[2]
                
                var components = DateComponents()
                components.day = day
                components.month = month
                components.year = year
                
                if let date = calendar.date(from: components) {
                    formattedDateDictionary.updateValue(history, forKey: date)
                } else {
                    print("Invalid date")
                }
            } else {
                print("Invalid date format")
            }
        }
    }
    
    func goToPreviousHistory() {
        //because of sort order, we go up an index to go back in time
        if currentIndex + 1 < formattedDateDictionary.count {
            currentIndex += 1
        }
    }
    
    func goToNextHistory() {
        if currentIndex - 1 >= 0 {
            currentIndex -= 1
        }
    }
    
}

#Preview {
    HistoryView()
}
