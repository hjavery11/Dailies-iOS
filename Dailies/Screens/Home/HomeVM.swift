//
//  HomeVM.swift
//  Dailies
//
//  Created by Harrison Javery on 8/28/24.
//

import SwiftUI
import Combine

class HomeVM: ObservableObject {
  
    @Published var dailyGames: [Game]
    @Published var showGamesList: Bool = false
    
    init() {
        dailyGames = UserManager.shared.getDailyGames()
        print("init homeVM with daily games of: \(dailyGames)")
    }
    
}
