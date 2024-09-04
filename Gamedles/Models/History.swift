//
//  History.swift
//  Gamedles
//
//  Created by Harrison Javery on 9/4/24.
//

import Foundation

struct History: Codable, Identifiable {
    let date: String
    let scores: [String: String]
    
    var id: String { return date }
}
