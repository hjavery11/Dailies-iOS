//
//  Game.swift
//  Dailies
//
//  Created by Harrison Javery on 8/26/24.
//

import Foundation

struct Game: Hashable {
    let name: String
    let url: String
    let description: String
    let category: String
    let background: String?
  
}

struct GameData {
    let games = [
        Game(name: "Pokedoku",
             url: "https://pokedoku.com",
             description: "Sudoku-style game with Pokémon characters",
             category: "puzzle",
             background: "pokedoku-bg"),
        
        Game(name: "Framed",
             url: "https://framed.wtf",
             description: "Guess the movie from a single frame",
             category: "movies",
             background: "framed-bg"),
        
        Game(name: "Daily Dozen Trivia",
             url: "https://dailydozentrivia.com",
             description: "Test your knowledge with 12 daily trivia questions",
             category: "trivia",
             background: "dailydozen-bg"),
        
        Game(name: "Connections",
             url: "https://www.nytimes.com/games/connections",
             description: "Group related words together",
             category: "words",
             background: "connections-bg"),
        
        Game(name: "Globle",
             url: "https://globle-game.com",
             description: "Guess the mystery country in this geography challenge",
             category: "geography",
             background: "globle-bg"),
        
        Game(name: "Box Office Game",
             url: "https://boxofficega.me",
             description: "Guess the box office revenue of movies",
             category: "movies",
             background: "boxoffice-bg"),
        
        Game(name: "Costcodle",
             url: "https://costcodle.com",
             description: "Guess items found at Costco",
             category: "retail",
             background: "costcodle-bg"),
        
        Game(name: "Movie to Movie",
             url: "https://movietomovie.com",
             description: "Connect actors between movies",
             category: "movies",
             background: "movietomovie-bg"),
        
        Game(name: "Guess the Game",
             url: "https://guessthe.game",
             description: "Identify the video game from a single screenshot",
             category: "games",
             background: "guessthegame-bg"),
        
        Game(name: "Gamedle",
             url: "https://gamedle.wtf",
             description: "Guess the game from clues",
             category: "games",
             background: "gamedle-bg"),
        
        Game(name: "Travle",
             url: "https://travle.earth",
             description: "Guess the travel destination",
             category: "travel",
             background: "travle-bg"),
        
        Game(name: "Puckdoku",
             url: "https://puckdoku.com",
             description: "Hockey-themed puzzle game",
             category: "sports",
             background: "puckdoku-bg"),
        
        Game(name: "Movie Grid",
             url: "https://moviegrid.io",
             description: "Complete the movie-related grid",
             category: "movies",
             background: "moviegrid-bg"),
        
        Game(name: "Spellcheck",
             url: "https://spellcheckgame.com",
             description: "Test your spelling skills in this word game",
             category: "words",
             background: "spellcheck-bg"),
        
        Game(name: "Food Guessr",
             url: "https://foodguessr.com",
             description: "Guess the food item from the clues",
             category: "food",
             background: "foodguessr-bg"),
        
        Game(name: "Acted",
             url: "https://acted.wtf",
             description: "Guess the actor based on clues",
             category: "movies",
             background: "acted-bg"),
        
        Game(name: "Thrice",
             url: "https://thrice.geekswhodrink.com",
             description: "Guess the answer within 3 clues",
             category: "trivia",
             background: "thrice-bg"),
        
        Game(name: "Relatle",
             url: "https://relatle.io",
             description: "Guess the related word",
             category: "words",
             background: "relatle-bg"),
        
        Game(name: "Disorderly",
             url: "https://playdisorderly.com",
             description: "Solve puzzles with disorderly words",
             category: "puzzle",
             background: "disorderly-bg"),
        
        Game(name: "Bandle",
             url: "https://bandle.app",
             description: "Guess the song played by the band",
             category: "music",
             background: "bandle-bg")
    ]

}
