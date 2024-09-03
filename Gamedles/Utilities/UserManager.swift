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
    
}
