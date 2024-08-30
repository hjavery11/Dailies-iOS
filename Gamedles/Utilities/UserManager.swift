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
    }
    
    func getDailyGames() -> [Game] {
        if let savedData = UserDefaults.standard.data(forKey: Keys.dailies.rawValue) {
            do {
                let decoder =  JSONDecoder()
                // Decode the data into an array of Game objects
                let games = try decoder.decode([Game].self, from: savedData)
                return games
            } catch {
                print("Failed to decode games: \(error)")
            }
        } else {
            var initialGames: [Game] = GameData().games
            initialGames[0].isDailyGame = true
            initialGames[2].isDailyGame = true
            initialGames[9].isDailyGame = true
            initialGames[5].isDailyGame = true
            initialGames[18].isDailyGame = true
            initialGames[8].isDailyGame = true
            
            return initialGames
        }
        print("returning empty array for daily games. Shouldnt happen, needs investigation")
        return []
    }
    
}
