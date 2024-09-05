//
//  UserManager.swift
//  Dailies
//
//  Created by Harrison Javery on 8/28/24.
//

import Foundation

enum Keys: String {
    case dailies
    case lastResetDate
    case history
}

class UserManager: ObservableObject {
    @Published var showOnboarding: Bool = false
    @Published var games = [Game]() {
        didSet {
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(games)
                UserDefaults.standard.setValue(data, forKey: Keys.dailies.rawValue)
                print("saved games to user defaults")
            } catch {
                print("error during encoding of daily games to user defaults")
                return
            }
        }
    }
    
    init() {
        //get the daily games from user defaults, or create user defaults if it doesnt exist
        games = getDailyGames()
        cleanUpHistory()
        checkResetGames()
    }
    
    func getDailyGames() -> [Game] {
        if let savedData = UserDefaults.standard.data(forKey: Keys.dailies.rawValue) {
            do {
                let decoder = JSONDecoder()
                // Decode the data into an array of Game objects
                var savedGames = try decoder.decode([Game].self, from: savedData)
                let dailyCount = savedGames.filter { $0.isDailyGame }.count
                if dailyCount == 0 {
                    showOnboarding = true
                }
                
                // Check for new games and add them
                let newGames = getNewGames(savedGames: savedGames)
                if !newGames.isEmpty {
                    savedGames.append(contentsOf: newGames)
                    print("Added new games: \(newGames.map { $0.name })")
                }
                
                // Check for deleted games and remove them
                let deletedGames = getDeletedGames(savedGames: savedGames)
                if !deletedGames.isEmpty {
                    savedGames.removeAll { game in deletedGames.contains { $0.name == game.name } }
                    print("Removed deleted games: \(deletedGames.map { $0.name })")
                }
                
                // Save the updated games list to UserDefaults if there are any changes
                if !newGames.isEmpty || !deletedGames.isEmpty {
                    saveGamesToUserDefaults(games: savedGames)
                }
                
                return savedGames
            } catch {
                print("Failed to decode games: \(error)")
            }
        } else {
            // If no saved data, show onboarding and return the default games
            showOnboarding = true
            return GameData().games
        }
        
        print("Returning empty array for daily games. Shouldn't happen, needs investigation.")
        return []
    }

    
    // Helper function to find new games not in saved data
    func getNewGames(savedGames: [Game]) -> [Game] {
        return GameData().games.filter { newGame in
            !savedGames.contains { savedGame in savedGame.name == newGame.name }
        }
    }

    // Helper function to find games that no longer exist in GameData
    func getDeletedGames(savedGames: [Game]) -> [Game] {
        return savedGames.filter { savedGame in
            !GameData().games.contains { game in game.name == savedGame.name }
        }
    }

    // Helper function to save games to UserDefaults
    func saveGamesToUserDefaults(games: [Game]) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(games)
            UserDefaults.standard.setValue(data, forKey: Keys.dailies.rawValue)
            print("Saved updated games list to UserDefaults.")
        } catch {
            print("Failed to encode updated games list.")
        }
    }
    
    func checkResetGames() {
        let calendar = Calendar.current
        
        if let lastReset = UserDefaults.standard.object(forKey: Keys.lastResetDate.rawValue) as? Date {
            //uncomment this to test reset
            //lastReset.addTimeInterval(60 * 60 * 24)
            let isSameDay = calendar.isDate(lastReset, inSameDayAs: .now)
            if isSameDay {
                print("same day of last reset, so dont do anything")
            } else {
                print("different day than last reset. Resetting game completions and updating reset date")
                
                //Add History Entry
                createHistoryForDay(date: lastReset)
                
                for g in games.indices {
                    games[g].completed = false
                    games[g].won = nil
                }
                
                UserDefaults.standard.setValue(Date(), forKey: Keys.lastResetDate.rawValue)
                
            }
        } else {
            print("no reset date found in user defaults. Setting it to current time")
            UserDefaults.standard.setValue(Date(), forKey: Keys.lastResetDate.rawValue)
        }
    }
    
    func createHistoryForDay(date: Date) {
        var scores = [String: String]()
        for g in games {
            if g.completed {
                if g.hasScore {
                    //store score
                    scores[g.id] = g.score
                } else if g.won != nil {
                    //only store win/loss
                    var outcome: String = ""
                    if g.won == true {
                        outcome = "won"
                    } else if g.won == false {
                        outcome = "lost"
                    }
                    if outcome != "" {
                        scores[g.id] = outcome
                    }
                }
            }
        }
        
        if scores.isEmpty {
            return
        }
        
        let historyDateComponents = date.get(.day, .month, .year)
        
        if let day = historyDateComponents.day, let month = historyDateComponents.month, let year = historyDateComponents.year {          
            let historyDateFormatted = "\(day), \(month), \(year)"
            let newHistoryEntry = History(date: historyDateFormatted, scores: scores)
            
            
            if let oldHistoryData = UserDefaults.standard.data(forKey: Keys.history.rawValue) {
                //if history already exists, append this to existing data
                var oldHistory = try? JSONDecoder().decode([History].self, from: oldHistoryData)
                if oldHistory?.first(where: {$0.date == historyDateFormatted}) != nil {
                    //already exists, dont add it again
                    return
                }
                
                oldHistory?.append(newHistoryEntry)
                let encoder = JSONEncoder()
                do {
                    let data = try encoder.encode(oldHistory)
                    UserDefaults.standard.setValue(data, forKey: Keys.history.rawValue)
                    print("added new history entry to user defaults")
                } catch {
                    print("Error during encoding of updated history into user defaults")
                }
            } else {
                //no previous history data, so create first entry in array and save
                var history = [History]()
                history.append(newHistoryEntry)
                let encoder = JSONEncoder()
                do {
                    let data = try encoder.encode(history)
                    UserDefaults.standard.setValue(data, forKey: Keys.history.rawValue)
                    print("Added initial history to user defaults")
                } catch {
                    print("Error during encoding of initial history into user defaults")
                }
            }
        }
    }
    
    func deleteHistory(_ date: String) {
        UserDefaults.standard.removeObject(forKey: Keys.history.rawValue)
    }
    
    func cleanUpHistory() {
        // Load history from UserDefaults
        if let oldHistoryData = UserDefaults.standard.data(forKey: Keys.history.rawValue) {
            do {
                var oldHistory = try JSONDecoder().decode([History].self, from: oldHistoryData)
                let gameDataGames = GameData().games
                
                // Iterate through each history entry and remove references to deleted games
                for index in oldHistory.indices {
                    oldHistory[index].scores = oldHistory[index].scores.filter { gameID, _ in
                        gameDataGames.contains { $0.id == gameID }
                    }
                }
                
                // Save the cleaned-up history back to UserDefaults
                let encoder = JSONEncoder()
                let data = try encoder.encode(oldHistory)
                UserDefaults.standard.setValue(data, forKey: Keys.history.rawValue)
                print("Cleaned up history references to deleted games")
            } catch {
                print("Failed to clean up history: \(error)")
            }
        }
    }
    
}
