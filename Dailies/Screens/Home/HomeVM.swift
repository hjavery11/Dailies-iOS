//
//  HomeVM.swift
//  Dailies
//
//  Created by Harrison Javery on 8/28/24.
//

import SwiftUI

class HomeVM: ObservableObject {
    
    @Published var dailyGames: [String: Bool]?
    
    init() {
        if let userGames = UserManager.shared.getDailyGames() {
            self.dailyGames = userGames
        }
    }   
    
}
