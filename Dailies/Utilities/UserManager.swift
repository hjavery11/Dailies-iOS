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
        let initialGames = GameData().games.prefix(6)
        var games = [String: Bool]()
        
        for game in initialGames {
            games[game.name] = false
        }
        
        UserDefaults.standard.setValue(games, forKey: Keys.dailies.rawValue)
    }
    
    func getDailyGames() -> [String: Bool]? {
        UserDefaults.standard.dictionary(forKey: Keys.dailies.rawValue) as? [String: Bool]
    }
    
    func completeGame(game: Game) {
        var games = UserDefaults.standard.dictionary(forKey: Keys.dailies.rawValue)
        games?[game.name] = true
        
        UserDefaults.standard.setValue(games, forKey: Keys.dailies.rawValue)
    }
    
}
