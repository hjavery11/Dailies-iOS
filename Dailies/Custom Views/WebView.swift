//
//  WebView.swift
//  Dailies
//
//  Created by Harrison Javery on 8/26/24.
//

import WebKit
import SwiftUI

struct WebViewScreen: View {
    @Binding var games: [Game]
    @State private var currentIndex: Int
    
    init(games: Binding<[Game]>, currentIndex: Int) {
        self._games = games
        self._currentIndex = State(initialValue: currentIndex)
    }
    
    var body: some View {
        if let url = URL(string: games[currentIndex].url) {
            ZStack {
                WebView(url: url, game: $games[currentIndex])
                    .id(url)
                    .navigationTitle(games[currentIndex].name)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar(.hidden, for: .tabBar)
                    .toolbar {
                        if games.count > 1 {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button {
                                    print("next game")
                                    goToNextGame()
                                } label: {
                                    HStack {
                                        Text("Next")
                                        Image(systemName: "chevron.right")
                                            .font(.callout)
                                            .fontWeight(.semibold)
                                    }
                                }
                            }
                        }
                    }
            }
        }
    }
    
    private func goToNextGame() {
        currentIndex += 1
        if currentIndex > games.count - 1 {
            //go back to first game
            currentIndex = 0
        }
        
    }
}

struct WebView: UIViewRepresentable {
    
    var url: URL
    @Binding var game: Game
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let wkwebView = WKWebView()
        wkwebView.navigationDelegate = context.coordinator
        
        // Register the script message handler to listen for the `loadingFinished` message
        let contentController = wkwebView.configuration.userContentController
        contentController.add(context.coordinator, name: "puzzleFinished")
        contentController.add(context.coordinator, name: "puzzleFailed")
        
        print("Added message handlers for puzzle completion and failure")
        
        wkwebView.load(URLRequest(url:url))
        return wkwebView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        //only load url if its a new url
        if uiView.url?.absoluteString.trimmingTrailingSlash() != url.absoluteString.trimmingTrailingSlash() {
            uiView.load(URLRequest(url: url))
        }
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: WebView
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            //finish loading logic can go here eventually
        }
        
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // You can still use this method for any final tasks after the page has fully loaded
            print("Navigation did finish")
            
            //Inject JS for determining puzzle completion
            if let gameJS = GameData().getJavascript(forGame: parent.game.name) {
                print("added javascript to page for completion of game: \(parent.game.name)")
                webView.evaluateJavaScript(gameJS) { result, error in
                    if let error = error {
                        print("JavaScript evaluation error: \(error)")
                    } else {
                        print("JavaScript injected successfully for game")
                    }
                }
            }
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "puzzleFinished"  {
                if !parent.game.completed {
                    parent.game.completed = true
                    parent.game.won = true
                    UserManager.shared.completeGame(parent.game, win: true)
                    print("finsihed puzzle success")
                }
            } else if message.name == "puzzleFailed" {
                if !parent.game.completed {
                    parent.game.completed = true
                    parent.game.won = false
                    UserManager.shared.completeGame(parent.game, win: false)
                    print("finsihed puzzle failed")
                }
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("Navigation failed: \(error.localizedDescription)")
        }
        
        
        
    }
    
    
    
}


