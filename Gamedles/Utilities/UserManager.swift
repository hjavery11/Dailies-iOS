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
        checkResetGames()
    }
    
    func getDailyGames() -> [Game] {
        if let savedData = UserDefaults.standard.data(forKey: Keys.dailies.rawValue) {
            do {
                let decoder =  JSONDecoder()
                // Decode the data into an array of Game objects
                let games = try decoder.decode([Game].self, from: savedData)
                let dailyCount = games.filter {$0.isDailyGame}.count
                if dailyCount == 0 {
                    showOnboarding = true
                }
                return games
            } catch {
                print("Failed to decode games: \(error)")
            }
        } else {
            showOnboarding = true
            return GameData().games
        }
        print("returning empty array for daily games. Shouldnt happen, needs investigation")
        return []
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
    
}
