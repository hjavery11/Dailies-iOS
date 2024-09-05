//
//  History.swift
//  Gamedles
//
//  Created by Harrison Javery on 9/4/24.
//

import Foundation

struct History: Codable, Identifiable {
    let date: String
    var scores: [String: String]
    
    var id: String { return date }
}


struct HistoryData {
    let mockData: [History] = [
        History(date: "3, 9, 2024", scores: ["Bandle": "won", "Daily Dozen Trivia": "2/9", "Relatle": "lost", "Food Guessr": "won", "Acted": "won", "Movie to Movie": "lost", "Framed": "won", "Movie Grid": "0/9"]),
        History(date: "25, 12, 2023", scores: ["Movie Grid": "5/9", "Connections": "won", "Box Office Game": "lose", "Food Guessr": "won", "Acted": "won", "Framed": "won", "Pokedoku": "3/9"]),
        History(date: "28, 8, 2024", scores: ["Costcodle": "won", "Connections": "won", "Box Office Game": "lost", "Food Guessr": "won", "Acted": "won", "Daily Dozen Trivia": "8/9", "Framed": "won", "Pokedoku": "3/9"]),
        History(date: "4, 9, 2024", scores: ["Bandle": "lost", "Daily Dozen Trivia": "6/9", "Relatle": "won", "Food Guessr": "won", "Acted": "won", "Movie to Movie": "won", "Framed": "won", "Movie Grid": "5/9"]),
        History(date: "18, 8, 2024", scores: ["Costcodle": "lost", "Connections": "lost", "Box Office Game": "won", "Food Guessr": "won", "Acted": "won", "Daily Dozen Trivia": "8/9", "Framed": "won", "Pokedoku": "3/9", "Travle": "won", "Guess the Game": "lost"]),
    ]
}
