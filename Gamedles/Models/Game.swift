//
//  Game.swift
//  Dailies
//
//  Created by Harrison Javery on 8/26/24.
//

import Foundation

struct Game: Hashable, Codable, Identifiable {
    let name: String
    let url: String
    let description: String
    let category: String
    let background: String?
    var completed: Bool = false
    var won: Bool? = nil
    var isDailyGame: Bool = false
    
    var id: String { name }
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
             description: "Guess the movies from a specific box office week",
             category: "movies",
             background: "boxoffice-bg"),
        
        Game(name: "Costcodle",
             url: "https://costcodle.com",
             description: "Guess the cost of Costco items",
             category: "retail",
             background: "costcodle-bg"),
        
        Game(name: "Movie to Movie",
             url: "https://movietomovie.com",
             description: "Connect two movies using actors",
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
             description: "Guess the travel destination between two countries",
             category: "travel",
             background: "travle-bg"),
        
        Game(name: "Puckdoku",
             url: "https://puckdoku.com",
             description: "Complete the Hockey-themed grid",
             category: "sports",
             background: "puckdoku-bg"),
        
        Game(name: "Movie Grid",
             url: "https://moviegrid.io",
             description: "Complete the movie-themed grid",
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
             description: "Guess the movie based on actors",
             category: "movies",
             background: "acted-bg"),
        
        Game(name: "Thrice",
             url: "https://thrice.geekswhodrink.com",
             description: "Guess the answer within 3 clues",
             category: "trivia",
             background: "thrice-bg"),
        
        Game(name: "Relatle",
             url: "https://relatle.io",
             description: "Navigate from one artist to another",
             category: "words",
             background: "relatle-bg"),
        
        Game(name: "Disorderly",
             url: "https://playdisorderly.com",
             description: "Sort the answers in the correct order",
             category: "puzzle",
             background: "disorderly-bg"),
        
        Game(name: "Bandle",
             url: "https://bandle.app",
             description: "Guess the song played by the band",
             category: "music",
             background: "bandle-bg")
    ]
    
    var gamesByName: [String: Game] {
        Dictionary(uniqueKeysWithValues: games.map { ($0.name, $0) })
    }
    
    func getGame(forName name: String) -> Game? {
        gamesByName[name]
    }
    
    func getJavascript(forGame name: String) -> String? {
        switch name.lowercased() {
        case "acted":
            return """
(function() {
    function checkPuzzleOutcome() {
        // Check if the text "The answer was:" is on the page
        const answerText = document.body.textContent.includes('The answer was:');
        
        if (answerText) {
            // Select all <p> elements on the page
            const elements = document.querySelectorAll('p');
            
            // Check if any of these elements contain the green square (🟩)
            let hasGreenSquare = false;
            for (let element of elements) {
                if (element.textContent.includes('🟩')) {
                    hasGreenSquare = true;
                    break;
                }
            }
            
            // Send the appropriate message based on the presence of the green square
            if (hasGreenSquare) {
                window.webkit.messageHandlers.puzzleCompleted.postMessage(true);
            } else {
                window.webkit.messageHandlers.puzzleFailed.postMessage(true);
            }
            return true; // Stop further checks once the outcome is determined
        }
        
        return false; // The puzzle is not yet complete
    }

    // Check immediately on load
    if (!checkPuzzleOutcome()) {
        // If not complete, create a MutationObserver to monitor changes in the DOM
        const observer = new MutationObserver((mutationsList, observer) => {
            if (checkPuzzleOutcome()) {
                observer.disconnect(); // Stop observing once the outcome is determined
            }
        });

        // Start observing the entire document for changes in child elements, subtree, and attributes
        observer.observe(document.body, {
            childList: true,   // Monitor changes to child elements
            subtree: true,     // Monitor the entire subtree
            characterData: true // Also observe text changes
        });
    }
})();
"""
        case "framed":
            return """
            (function() {
                let timeoutId;

                // Function to check for specific text content for success or failure
                function checkPuzzleStatus(observer) {
                    // Only look for text outside the input field (search bar)
                    const elements = document.querySelectorAll('p, div:not(.relative), span');  // Exclude the input container
                    elements.forEach(element => {
                        if (element.textContent.includes('You got it!')) {
                            // Notify the native code that the puzzle is completed successfully
                            window.webkit.messageHandlers.puzzleCompleted.postMessage(true);
                            
                            // Disconnect the MutationObserver to stop further checks
                            observer.disconnect();
                        } else if (element.textContent.includes('THE ANSWER WAS')) {
                            // Notify the native code that the puzzle failed
                            window.webkit.messageHandlers.puzzleFailed.postMessage(true);
                            
                            // Disconnect the MutationObserver to stop further checks
                            observer.disconnect();
                        }
                    });
                }

                // Throttled mutation handler
                function throttledMutationHandler(mutationsList, observer) {
                    if (timeoutId) {
                        clearTimeout(timeoutId);
                    }

                    // Throttle the DOM checks to avoid impacting performance
                    timeoutId = setTimeout(() => {
                        checkPuzzleStatus(observer);
                    }, 200); // Delay in milliseconds, adjust as needed
                }

                // Use MutationObserver to watch for changes in the DOM outside the input field
                const observer = new MutationObserver(throttledMutationHandler);

                // Start observing the body but exclude changes in the form containing the search bar
                observer.observe(document.body, {
                    childList: true,
                    subtree: true,
                    characterData: true,
                    attributes: false
                });

                // Initial check in case the text is already present
                checkPuzzleStatus(observer);
            })();
            """
        case "pokedoku":
            return """
(function() {
    let lastInvocationTime = 0;
    const throttleDelay = 200; // 200 ms throttle delay

    // Function to check for success or failure within the targeted modal areas
    function checkPuzzleStatus(observer) {
        const modalSections = document.querySelectorAll('section.chakra-modal__content');
        
        modalSections.forEach(section => {
            const textContent = section.textContent;

            if (textContent.includes('Congrats! You solved them all!')) {
                // Notify the native code that the puzzle is completed successfully
                window.webkit.messageHandlers.puzzleCompleted.postMessage(true);
                
                // Disconnect the MutationObserver to stop further checks
                observer.disconnect();
            } else if (textContent.includes('You have run out of guesses')) {
                // Notify the native code that the puzzle failed
                window.webkit.messageHandlers.puzzleFailed.postMessage(true);
                
                // Disconnect the MutationObserver to stop further checks
                observer.disconnect();
            }
        });
    }

    // Throttled mutation handler
    function throttledMutationHandler(mutationsList, observer) {
        const now = Date.now();

        // Check if sufficient time has passed since the last invocation
        if (now - lastInvocationTime > throttleDelay) {
            checkPuzzleStatus(observer);
            lastInvocationTime = now;
        }
    }

    // Use MutationObserver to watch for changes in the DOM specifically within the modal sections
    const observer = new MutationObserver(throttledMutationHandler);

    // Start observing the body but target only modal sections for changes
    observer.observe(document.body, {
        childList: true,
        subtree: true,
        characterData: true,
        attributes: false
    });

    // Initial check in case the text is already present
    checkPuzzleStatus(observer);
})();
"""
        case "bandle":
            return """
(function() {
    // Function to check for the win or loss messages
    function checkGameEnded() {
        const victoryText = document.body.textContent || "";
        const lossText = document.body.textContent || "";

        if (victoryText.includes("You got it!")) {
            // Game won, send puzzleCompleted message
            window.webkit.messageHandlers.puzzleCompleted.postMessage(true);
        } else if (lossText.includes("Better luck tomorrow!")) {
            // Game lost, send puzzleFailed message
            window.webkit.messageHandlers.puzzleFailed.postMessage(false);
        }
    }

    // Use MutationObserver to watch for changes in the DOM
    const observer = new MutationObserver(function(mutationsList, observer) {
        for (let mutation of mutationsList) {
            if (mutation.type === 'childList' || mutation.type === 'subtree' || mutation.type === 'characterData') {
                checkGameEnded(); // Check if the game has ended
            }
        }
    });

    // Start observing the entire document for changes
    observer.observe(document.body, { childList: true, subtree: true, characterData: true });

    // Initial check in case the text is already present
    checkGameEnded();
})();
"""
        case "daily dozen trivia":
            return """
(function() {
    function checkGameCompletion() {
        // Select all buttons on the page
        const buttons = document.querySelectorAll('button');
        
        // Iterate through the buttons to find one with the text "view results"
        for (let button of buttons) {
            // Normalize the text content
            const buttonText = button.textContent.trim().toLowerCase().replace(/\\s+/g, ' ');
            
            if (buttonText.includes('view results')) {
                console.log('The game is complete.');
                // Send a message back to the app using the correct method
                window.webkit.messageHandlers.puzzleCompleted.postMessage(true);
                return true; // Stop observing once the game is detected as complete
            }
        }
        
        return false; // Game is not complete yet
    }

    // Check immediately on load
    if (!checkGameCompletion()) {
        // If not complete, create a MutationObserver to monitor changes in the DOM
        const observer = new MutationObserver((mutationsList, observer) => {
            if (checkGameCompletion()) {
                observer.disconnect(); // Stop observing if the game is complete
            }
        });

        // Start observing the entire document for changes in child elements, subtree, and attributes
        observer.observe(document.body, {
            childList: true,   // Monitor changes to child elements
            subtree: true,     // Monitor the entire subtree
            characterData: true // Also observe text changes
        });
    }
})();
"""
        case "globle":
            return """
(function() {
    function checkForMysteryCountry() {
        // Select all <p> elements on the page
        const elements = document.querySelectorAll('p');
        
        // Iterate through the elements to find the text "The Mystery Country is"
        for (let element of elements) {
            const textContent = element.textContent.trim();
            
            if (textContent.includes('The Mystery Country is')) {
                console.log('The Mystery Country is found.');
                // Send a message back to the app
                window.webkit.messageHandlers.puzzleCompleted.postMessage(true);
                return true; // Stop further checks once the text is found
            }
        }
        
        return false; // The text is not found yet
    }

    // Check immediately on load
    if (!checkForMysteryCountry()) {
        // If not complete, create a MutationObserver to monitor changes in the DOM
        const observer = new MutationObserver((mutationsList, observer) => {
            if (checkForMysteryCountry()) {
                observer.disconnect(); // Stop observing once the text is found
            }
        });

        // Start observing the entire document for changes in child elements, subtree, and attributes
        observer.observe(document.body, {
            childList: true,   // Monitor changes to child elements
            subtree: true,     // Monitor the entire subtree
            characterData: true // Also observe text changes
        });
    }
})();
"""
        default:
            return nil
            
        }
    }

}
