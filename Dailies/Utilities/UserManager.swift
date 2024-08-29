//
//  UserManager.swift
//  Dailies
//
//  Created by Harrison Javery on 8/28/24.
//

import Foundation

class UserManager {
    
    static let shared = UserManager()
    
    private init() {}
    
    enum Keys: String {
        case dailies
    }
    
    func setDailyGames() {
        if getDailyGames().isEmpty {
            let initialGames: [Game] = Array(GameData().games[0...5])
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(initialGames)
                UserDefaults.standard.setValue(data, forKey: Keys.dailies.rawValue)
            } catch {
                print("error during encoding of daily games")
                return
            }
        }
    }
    
    func getDailyGames() -> [Game] {
        let decoder =  JSONDecoder()
        if let savedData = UserDefaults.standard.data(forKey: Keys.dailies.rawValue) {
            do {
                // Decode the data into an array of Game objects
                let games = try decoder.decode([Game].self, from: savedData)
                return games
            } catch {
                print("Failed to decode games: \(error)")
            }
        }
        
        return []
    }
    
    func completeGame(_ game: Game) {
        var games = getDailyGames()
        
        if let index = games.firstIndex(where: { $0.name == game.name }) {
            games[index].completed = true
            
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(games)
                UserDefaults.standard.setValue(data, forKey: Keys.dailies.rawValue)
                //print("set data to \(games)")
            } catch {
                print("Error during encoding of updated games")
            }
        }
    }
    
    
}
