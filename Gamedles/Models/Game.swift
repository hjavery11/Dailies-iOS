//
//  Game.swift
//  Dailies
//
//  Created by Harrison Javery on 8/26/24.
//

import Foundation

enum Category: String, Codable, CaseIterable, Identifiable {
    case movies_and_tv = "Movies & TV"
    case trivia = "Trivia"
    case music = "Music"
    case words = "Words"
    case geography = "Geography"
    case video_games = "Video Games"
    case sports = "Sports"
    case miscellaneous = "Miscellaneous"
  
    var id: String {self.rawValue}
}

struct Game: Hashable, Codable, Identifiable {
    let name: String
    let url: String
    let description: String
    let category: Category
    let background: String?
    var completed: Bool = false
    var won: Bool? = nil
    var isDailyGame: Bool = false
    var hasScore: Bool
    var score: String?

    var id: String { name }
}

struct GameData {       
    let games = [
        Game(name: "Pokedoku",
             url: "https://pokedoku.com",
             description: "Sudoku-style game with Pokémon characters",
             category: .miscellaneous,
             background: "pokedoku-bg",
             hasScore: true),

        Game(name: "Framed",
             url: "https://framed.wtf",
             description: "Guess the movie from a single frame",
             category: .movies_and_tv,
             background: "framed-bg",
             hasScore: false),

        Game(name: "Daily Dozen Trivia",
             url: "https://dailydozentrivia.com",
             description: "Test your knowledge with 12 daily trivia questions",
             category: .trivia,
             background: "dailydozen-bg",
             hasScore: true),

        Game(name: "Connections",
             url: "https://www.nytimes.com/games/connections",
             description: "Group related words together",
             category: .words,
             background: "connections-bg",
             hasScore: false),

        Game(name: "Globle",
             url: "https://globle-game.com",
             description: "Guess the mystery country in this geography challenge",
             category: .geography,
             background: "globle-bg",
             hasScore: false),

        Game(name: "Box Office Game",
             url: "https://boxofficega.me",
             description: "Guess the movies from a specific box office week",
             category: .movies_and_tv,
             background: "boxoffice-bg",
             hasScore: false),

        Game(name: "Costcodle",
             url: "https://costcodle.com",
             description: "Guess the cost of Costco items",
             category: .miscellaneous,
             background: "costcodle-bg",
             hasScore: false),

        Game(name: "Movie to Movie",
             url: "https://movietomovie.com",
             description: "Connect two movies using actors",
             category: .movies_and_tv,
             background: "movietomovie-bg",
             hasScore: false),

        Game(name: "Guess the Game",
             url: "https://guessthe.game",
             description: "Identify the video game from a single screenshot",
             category: .video_games,
             background: "guessthegame-bg",
             hasScore: false),

        Game(name: "Travle",
             url: "https://travle.earth",
             description: "Guess the travel destination between two countries",
             category: .geography,
             background: "travle-bg",
             hasScore: false),

        Game(name: "Movie Grid",
             url: "https://moviegrid.io",
             description: "Complete the movie-themed grid",
             category: .movies_and_tv,
             background: "moviegrid-bg",
             hasScore: true),

        Game(name: "Food Guessr",
             url: "https://foodguessr.com",
             description: "Guess the food item from the clues",
             category: .miscellaneous,
             background: "foodguessr-bg",
             hasScore: false),

        Game(name: "Acted",
             url: "https://acted.wtf",
             description: "Guess the movie based on actors",
             category: .movies_and_tv,
             background: "acted-bg",
             hasScore: false),

        Game(name: "Thrice",
             url: "https://thrice.geekswhodrink.com",
             description: "Guess the answer within 3 clues",
             category: .trivia,
             background: "thrice-bg",
             hasScore: true),

        Game(name: "Relatle",
             url: "https://relatle.io",
             description: "Navigate from one artist to another",
             category: .music,
             background: "relatle-bg",
             hasScore: false),

        Game(name: "Disorderly",
             url: "https://playdisorderly.com",
             description: "Sort the answers in the correct order",
             category: .trivia,
             background: "disorderly-bg",
             hasScore: false),

        Game(name: "Bandle",
             url: "https://bandle.app",
             description: "Guess the song played by the band",
             category: .music,
             background: "bandle-bg",
             hasScore: false),
        
        Game(name: "Puckdoku",
             url: "https://www.puckdoku.com/",
             description: "Guess NHL players based on team, season, and stats.",
             category: .sports,
             background: "puckdoku-bg",
             hasScore: true),
    ]
    
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
    function checkForGameOver() {
        const paragraphs = document.querySelectorAll('p');
        
        // Iterate through the paragraphs to find the game over message
        for (let p of paragraphs) {
            if (p.textContent.includes('You have run out of guesses!')) {
                console.log('Game over detected.');
                
                // Now find the score
                const h2Elements = document.querySelectorAll('h2');
                
                for (let i = 0; i < h2Elements.length; i++) {
                    if (h2Elements[i].textContent.trim() === 'PTS') {
                        // Check if there's an h2 element after the one with 'PTS'
                        if (h2Elements[i + 1]) {
                            const score = h2Elements[i + 1].textContent.trim();
                            console.log('Score found:', score);
                            
                            // Format the score as "{score}/9"
                            const formattedScore = `${score}/9`;
                            console.log('Formatted Score:', formattedScore);

                            // Send the formatted score to the app
                            window.webkit.messageHandlers.puzzleScore.postMessage(formattedScore);
                            break;
                        }
                    }
                }
                
                observer.disconnect(); // Stop observing after the game is over
                return true; // Stop further checks
            }
        }
        
        return false; // Game is not over yet
    }

    // MutationObserver to monitor changes in the DOM
    const observer = new MutationObserver((mutationsList, observer) => {
        mutationsList.forEach(mutation => {
            // Skip any mutations inside iframes
            if (!mutation.target.closest('iframe')) {
                if (checkForGameOver()) {
                    observer.disconnect();
                }
            }
        });
    });

    // Start observing the document for changes
    observer.observe(document.body, {
        childList: true,
        subtree: true,
        characterData: true
    });

    // Initial check in case the game over message is already present
    checkForGameOver();
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
    function checkForScoreElement() {
        // Look for the h6 element with the class "text-correctNumber" anywhere in the document
        const scoreElement = document.querySelector('h6.text-correctNumber');
        
        if (scoreElement) {
            console.log('Score element detected.');

            // Extract the number from the h6 element
            let score = scoreElement.textContent.trim();

            // Format the score as "{score}/9"
            const formattedScore = `${score}/9`;

            // Send a message back to the app with the formatted score
            window.webkit.messageHandlers.puzzleScore.postMessage(formattedScore);

            return true; // Stop observing once the score is detected
        }
        
        return false; // The score element is not found yet
    }

    // Check immediately on load
    if (!checkForScoreElement()) {
        // If the score element is not found, create a MutationObserver to monitor changes in the DOM
        const observer = new MutationObserver((mutationsList, observer) => {
            // Skip any mutations inside iframes
            mutationsList.forEach(mutation => {
                if (!mutation.target.closest('iframe')) {  // Skip if the target is within an iframe
                    checkForScoreElement();
                }
            });

            if (checkForScoreElement()) {
                observer.disconnect(); // Stop observing once the score is detected
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
        case "costcodle":
            return """
(function() {
    function checkForOutcome() {
        // Get the game-stats div element
        const gameStatsDiv = document.getElementById('game-stats');

        if (gameStatsDiv) {
            // Check the text content within the game-stats div
            const textContent = gameStatsDiv.textContent;

            if (textContent.includes('You win')) {
                // Send a message back to the app for a win
                window.webkit.messageHandlers.puzzleCompleted.postMessage(true);
                return true;
            } else if (textContent.includes('Better luck next time')) {
                // Send a message back to the app for a loss
                window.webkit.messageHandlers.puzzleFailed.postMessage(true);
                return true;
            }
        }
        
        return false; // Outcome is not yet determined
    }

    // Check immediately on load
    if (!checkForOutcome()) {
        // If not complete, create a MutationObserver to monitor changes in the game-stats div
        const observer = new MutationObserver((mutationsList, observer) => {
            if (checkForOutcome()) {
                observer.disconnect(); // Stop observing once the outcome is detected
            }
        });

        // Start observing the game-stats div for changes
        const gameStatsDiv = document.getElementById('game-stats');
        if (gameStatsDiv) {
            observer.observe(gameStatsDiv, {
                childList: true,   // Monitor changes to child elements
                subtree: true,     // Monitor the entire subtree
                characterData: true // Also observe text changes
            });
        }
    }
})();
"""
        case "box office game":
            return """
(function() {
    function checkForGameOverModal() {
        // Check if the game over modal is present on the page
        const gameOverModal = document.querySelector('.ReactModal__Content.GameOverModal');
        
        if (gameOverModal) {
            console.log('Game Over Modal found.');
            // Send a message back to the app indicating the puzzle is completed
            window.webkit.messageHandlers.puzzleCompleted.postMessage(true);
            return true; // Stop further checks once the modal is detected
        }
        
        return false; // The game over modal is not yet present
    }

    // Check immediately on load
    if (!checkForGameOverModal()) {
        // If not complete, create a MutationObserver to monitor changes in the DOM
        const observer = new MutationObserver((mutationsList, observer) => {
            if (checkForGameOverModal()) {
                observer.disconnect(); // Stop observing once the modal is detected
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
        case "connections":
            return """
(function() {
    function checkForOutcome() {
        // Select the <h2> element with the specific data-testid attribute
        const outcomeHeader = document.querySelector('h2[data-testid="conn-congrats__title"]');

        if (outcomeHeader) {
            const textContent = outcomeHeader.textContent.trim();

            if (textContent === 'Next Time!') {
                // Send a message back to the app for a loss
                window.webkit.messageHandlers.puzzleFailed.postMessage(true);
            } else {
                // Send a message back to the app for a win
                window.webkit.messageHandlers.puzzleCompleted.postMessage(true);
            }
            return true; // Outcome determined
        }
        
        return false; // Outcome is not yet determined
    }

    // Check immediately on load
    if (!checkForOutcome()) {
        // If not complete, create a MutationObserver to monitor changes in the DOM
        const observer = new MutationObserver((mutationsList, observer) => {
            if (checkForOutcome()) {
                observer.disconnect(); // Stop observing once the outcome is detected
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
        case "disorderly":
            return """
(function() {
    function checkForAnswer() {
        // Select all <div> elements on the page
        const divs = document.querySelectorAll('div');

        // Iterate through the divs to find the text "You got the answer"
        for (let div of divs) {
            const textContent = div.textContent.trim();

            if (textContent.includes('You got the answer')) {
                // Send a message back to the app for a win
                window.webkit.messageHandlers.puzzleCompleted.postMessage(true);
                return true; // Stop further checks once the text is found
            }
        }
        
        return false; // The text is not found yet
    }

    // Check immediately on load
    if (!checkForAnswer()) {
        // If not found, create a MutationObserver to monitor changes in the DOM
        const observer = new MutationObserver((mutationsList, observer) => {
            if (checkForAnswer()) {
                observer.disconnect(); // Stop observing once the text is detected
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
        case "food guessr":
            return """
(function() {
    let lastUrl = window.location.href;

    function checkForFinalScoreButton() {
        const buttons = document.querySelectorAll('button');
        const button = Array.from(buttons).find(btn => btn.textContent.trim() === 'Final Score');
        
        if (button) {
            if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.puzzleCompleted) {
                window.webkit.messageHandlers.puzzleCompleted.postMessage(true);
            }
        }
    }

    function detectUrlChange() {
        const currentUrl = window.location.href;
        if (currentUrl !== lastUrl) {
            lastUrl = currentUrl;
            if (currentUrl.includes('foodguessr.com/round-results')) {
                checkForFinalScoreButton();
            }
        }
    }

    // Periodically check for URL changes
    setInterval(detectUrlChange, 500);

})();
"""
        case "guess the game":
            return """
(function() {
    function checkForOutcome() {
        const loseMsg = document.querySelector('h2.lose-msg');
        const winMsg = document.querySelector('h2.win-msg');
        
        if (loseMsg) {
            // Send the message to the iOS app indicating the puzzle failed
            if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.puzzleFailed) {
                window.webkit.messageHandlers.puzzleFailed.postMessage(true);
            }
            observer.disconnect(); // Stop observing after detection
        } else if (winMsg) {
            // Send the message to the iOS app indicating the puzzle is completed
            if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.puzzleCompleted) {
                window.webkit.messageHandlers.puzzleCompleted.postMessage(true);
            }
            observer.disconnect(); // Stop observing after detection
        }
    }

    // Create a MutationObserver to watch for changes in the DOM
    const observer = new MutationObserver(checkForOutcome);

    // Start observing the document body for changes
    observer.observe(document.body, {
        childList: true,    // Monitor additions and removals of child elements
        subtree: true,      // Monitor the entire subtree
        characterData: true // Monitor changes in the text content of nodes
    });

    // Perform an initial check in case the element is already present
    checkForOutcome();
})();
"""
        case "movie grid":
            return """
(function() {
    function checkForCompletion() {
        const paragraphs = document.querySelectorAll('p');
        const regex = /You got \\d+\\/\\d+ correct/;

        for (let p of paragraphs) {
            if (regex.test(p.textContent.trim())) {
                // Delay checking the score by 1 second to allow the page to update
                setTimeout(() => {
                    const updatedMatch = p.textContent.trim().match(/You got (\\d+)\\/\\d+ correct/);
                    if (updatedMatch) {
                        const correctAnswers = updatedMatch[1];
                        const formattedScore = `${correctAnswers}/9`;

                        if (window.webkit && window.webkit.messageHandlers) {
                            if (window.webkit.messageHandlers.puzzleScore) {
                                window.webkit.messageHandlers.puzzleScore.postMessage(formattedScore);
                            }
                        }
                    }
                    observer.disconnect(); // Stop observing once the completion is detected
                }, 2000); // 1 second delay before checking the score

                break;
            }
        }
    }

    const observer = new MutationObserver(checkForCompletion);

    observer.observe(document.body, {
        childList: true,
        subtree: true,
        characterData: true
    });

    checkForCompletion();
})();
"""
        case "movie to movie":
            return """
(function() {
    function checkForScoreboard() {
        const scoreboard = document.querySelector('div.scoreboard');
        
        if (scoreboard) {
            // Send the message to the iOS app indicating the puzzle is completed
            if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.puzzleCompleted) {
                window.webkit.messageHandlers.puzzleCompleted.postMessage(true);
            }
            observer.disconnect(); // Stop observing after detection
        }
    }

    // Create a MutationObserver to watch for changes in the DOM
    const observer = new MutationObserver(checkForScoreboard);

    // Start observing the document body for changes
    observer.observe(document.body, {
        childList: true,    // Monitor additions and removals of child elements
        subtree: true,      // Monitor the entire subtree
        characterData: true // Monitor changes in the text content of nodes
    });

    // Perform an initial check in case the element is already present
    checkForScoreboard();
})();
"""
        case "relatle":
            return """
(function() {
    function checkForOutcome() {
        const paragraphs = document.querySelectorAll('p');

        for (let p of paragraphs) {
            const text = p.textContent.trim();
            if (text.includes("You lost")) {
                // Send the message to the iOS app indicating the puzzle failed
                if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.puzzleFailed) {
                    window.webkit.messageHandlers.puzzleFailed.postMessage(true);
                }
                observer.disconnect(); // Stop observing after detection
                break;
            } else if (text.includes("You won")) {
                // Send the message to the iOS app indicating the puzzle is completed
                if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.puzzleCompleted) {
                    window.webkit.messageHandlers.puzzleCompleted.postMessage(true);
                }
                observer.disconnect(); // Stop observing after detection
                break;
            }
        }
    }

    // Create a MutationObserver to watch for changes in the DOM
    const observer = new MutationObserver(checkForOutcome);

    // Start observing the document body for changes
    observer.observe(document.body, {
        childList: true,    // Monitor additions and removals of child elements
        subtree: true,      // Monitor the entire subtree
        characterData: true // Monitor changes in the text content of nodes
    });

    // Perform an initial check in case the element is already present
    checkForOutcome();
})();
"""
        case "thrice":
            return """
(function() {
    function checkForCompletion() {
        const divs = document.querySelectorAll('div');

        for (let div of divs) {
            const text = div.textContent.trim();
            if (text === "That's a wrap! Thanks for playing.") {
                // Send the message to the iOS app indicating the puzzle is completed
                if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.puzzleCompleted) {
                    window.webkit.messageHandlers.puzzleCompleted.postMessage(true);
                }
                observer.disconnect(); // Stop observing after detection
                break;
            }
        }
    }

    // Create a MutationObserver to watch for changes in the DOM
    const observer = new MutationObserver(checkForCompletion);

    // Start observing the document body for changes
    observer.observe(document.body, {
        childList: true,    // Monitor additions and removals of child elements
        subtree: true,      // Monitor the entire subtree
        characterData: true // Monitor changes in the text content of nodes
    });

    // Perform an initial check in case the element is already present
    checkForCompletion();
})();
"""
        case "travle":
            return """
(function() {
    function checkForResults() {
        const resultsDiv = document.getElementById('resultsModalText');
        
        if (resultsDiv && resultsDiv.textContent.trim() !== '') {
            const text = resultsDiv.textContent.trim();
            if (text.includes("Success")) {
                // Send the message to the iOS app indicating the puzzle is completed
                if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.puzzleCompleted) {
                    window.webkit.messageHandlers.puzzleCompleted.postMessage(true);
                }
            } else {
                // Send the message to the iOS app indicating the puzzle failed
                if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.puzzleFailed) {
                    window.webkit.messageHandlers.puzzleFailed.postMessage(true);
                }
            }
            observer.disconnect(); // Stop observing after detection
        }
    }

    // Create a MutationObserver to watch for changes in the DOM
    const observer = new MutationObserver(checkForResults);

    // Start observing the `resultsModalText` div for changes
    const resultsDiv = document.getElementById('resultsModalText');
    if (resultsDiv) {
        observer.observe(resultsDiv, {
            childList: true,    // Monitor additions and removals of child elements
            subtree: true,      // Monitor the entire subtree
            characterData: true // Monitor changes in the text content of nodes
        });
    }

    // Perform an initial check in case the element is already populated
    checkForResults();
})();
"""
        case "puckdoku":
            return """
(function() {
    function checkForCompletion() {
        // Find all div elements
        const divs = document.querySelectorAll('div');
        const regex = /No shots left/;  // Example logic to detect game over

        for (let div of divs) {
            if (regex.test(div.textContent.trim())) {
                // Game over detected
                console.log("Game over detected!");

                // Now find the score in the format {number_correct} / 9
                const scoreDiv = Array.from(divs).find(div => /(\\d+) \\/ 9/.test(div.textContent.trim()));
                if (scoreDiv) {
                    const scoreMatch = scoreDiv.textContent.match(/(\\d+) \\/ 9/);
                    if (scoreMatch) {
                        const score = scoreMatch[1];
                        console.log(`Score: ${score}`);
                        window.webkit.messageHandlers.puzzleScore.postMessage(`${score}\\/9`);
                    }
                }

                observer.disconnect(); // Stop observing once the game is over
                return;
            }
        }
    }

    const observer = new MutationObserver(function(mutationsList, observer) {
        for (const mutation of mutationsList) {
            // Skip any mutations involving elements with "ad" in their ID
            if (mutation.target.id && mutation.target.id.toLowerCase().includes('ad')) {
                console.log("Skipping ad element");
                continue; // Skip this mutation, it relates to an ad
            }

            checkForCompletion(); // Call your completion check logic if it's not an ad
        }
    });

    // Start observing the body or a specific part of the DOM
    observer.observe(document.body, {
        childList: true,
        subtree: true,
        characterData: true
    });

})();
"""
        default:
            return nil
            
        }
    }

}
