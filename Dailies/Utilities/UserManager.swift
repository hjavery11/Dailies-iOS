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
        case lastResetDate
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
    
    func addDailyGame(_ game: Game) {
        var games = getDailyGames()
        games.append(game)
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(games)
            UserDefaults.standard.setValue(data, forKey: Keys.dailies.rawValue)
            print("set data to \(games)")
        } catch {
            print("Error during encoding of updated games")
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
    
    func completeGame(_ game: Game, win: Bool) {
        var games = getDailyGames()
        
        if let index = games.firstIndex(where: { $0.name == game.name }) {
            games[index].completed = true
            games[index].won = win
            
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(games)
                UserDefaults.standard.setValue(data, forKey: Keys.dailies.rawValue)
                print("set data to \(games)")
            } catch {
                print("Error during encoding of updated games")
            }
        }
    }
    
    func resetDailyGames() {
           var games = getDailyGames()
           
           for i in 0..<games.count {
               games[i].completed = false
               games[i].won = nil
           }
           
           let encoder = JSONEncoder()
           do {
               let data = try encoder.encode(games)
               UserDefaults.standard.setValue(data, forKey: Keys.dailies.rawValue)
               print("Daily games have been reset")
           } catch {
               print("Error during encoding of reset games")
           }
           
           // Save the current date as the last reset date
           UserDefaults.standard.setValue(Date(), forKey: Keys.lastResetDate.rawValue)
       }
       
       func shouldResetDailyGames() -> Bool {
           guard let lastResetDate = UserDefaults.standard.object(forKey: Keys.lastResetDate.rawValue) as? Date else {
               return true // No reset has ever occurred, so it should reset
           }
           
           // Check if the last reset date is on a different day than today
           let calendar = Calendar.current
           return !calendar.isDateInToday(lastResetDate)
       }
       
       func scheduleDailyReset() {
           let now = Date()
           let calendar = Calendar.current
           
           // Calculate the next midnight
           if let nextMidnight = calendar.nextDate(after: now, matching: DateComponents(hour: 0, minute: 0, second: 0), matchingPolicy: .nextTime) {
               let timer = Timer(fireAt: nextMidnight, interval: 0, target: self, selector: #selector(resetDailyGamesIfNeeded), userInfo: nil, repeats: false)
               RunLoop.main.add(timer, forMode: .common)
           }
       }
       
       @objc private func resetDailyGamesIfNeeded() {
           if shouldResetDailyGames() {
               resetDailyGames()
           }
           
           // Schedule the next reset
           scheduleDailyReset()
       }
    
    
}
