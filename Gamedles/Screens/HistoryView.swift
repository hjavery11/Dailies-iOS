//
//  HistoryView.swift
//  Gamedles
//
//  Created by Harrison Javery on 9/4/24.
//

import SwiftUI

struct HistoryView: View {
    
    @EnvironmentObject var userManager: UserManager
    
    @State var gameHistory = [History]()
    @State var dateSelected: Date = .now
    @State var showCalendar: Bool = false
    @State var calendarId: UUID = UUID()
    
    var dateSelectedID: String {
        let historyDateComponents = dateSelected.get(.day, .month, .year)
        
        if let day = historyDateComponents.day, let month = historyDateComponents.month, let year = historyDateComponents.year {
            let historyDateFormatted = "\(day), \(month), \(year)"
            return historyDateFormatted
        }
        return ""
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: dateSelected)
    }
    
    var body: some View {
        let columns = [
            GridItem(.adaptive(minimum: 100))
        ]
        
        NavigationStack {
            VStack(spacing:16) {
                HStack {
                    Text(formattedDate)
                        .font(.subheadline)
                        .fontWeight(.light)
                    
                    Button {
                        showCalendar = true
                    } label: {
                        Image(systemName: "calendar")
                    }
                    Spacer()
                }
                .padding(.leading, 18)
                LazyVGrid(columns: columns, spacing: 16) {
                    let historyForDaySelected = gameHistory.filter {$0.date == dateSelectedID}.first
                    if let history = historyForDaySelected {
                        ForEach(history.scores.sorted(by: {$0.key < $1.key}), id:\.key) { gameID, result in
                            if let originalGame = GameData().games.first(where: { $0.name == gameID }) {
                                GameGridItem2(game: originalGame, size: .small, showCompleted: true, result: result)
                            }
                            
                        }
                    } else {
                        Text("No history found for this date")
                            .font(.subheadline)
                    }
                }
                Spacer()
                .navigationTitle("Score History")
                .toolbar {
                    ToolbarItem(placement:.principal) {
                        Button("Delete History") {
                            userManager.deleteHistory(dateSelectedID)
                        }
                    }
                }
            }
        }
        .onAppear {
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
        }
        .sheet(isPresented: $showCalendar) {
            DatePicker("Start Date", selection:$dateSelected, displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .labelsHidden()
                .id(calendarId)
                .onChange(of: dateSelected) { _ in
                        showCalendar = false
                }
        }
        
    }
    
}

#Preview {
    HistoryView()
}
