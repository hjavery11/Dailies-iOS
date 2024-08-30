//
//  WebView.swift
//  Dailies
//
//  Created by Harrison Javery on 8/26/24.
//

import WebKit
import SwiftUI

struct WebViewScreen: View {
    @State var index: Int
    @EnvironmentObject var userManager: UserManager
    var dailiesOnly: Bool
    
    var body: some View {
        var game: Game {
            if dailiesOnly {
                return userManager.games.filter( { $0.isDailyGame })[index]
            } else {
                return userManager.games[index]
            }
        }
        
        if let url = URL(string: game.url) {
            ZStack {
                WebView(game: game, url: url)
                    .id(url)
                    .navigationTitle(game.name)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar(.hidden, for: .tabBar)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                if dailiesOnly {
                                    if index + 1 >= userManager.games.filter({$0.isDailyGame}).count {
                                        index = 0
                                    } else {
                                        index += 1
                                    }
                                } else {
                                    if index + 1 >= userManager.games.count {
                                        index = 0
                                    } else {
                                        index += 1
                                    }
                                }
                                
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

struct WebView: UIViewRepresentable {
    @EnvironmentObject var userManager: UserManager
    var game: Game
    var url: URL
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        print("webview makeUIView")
        let wkwebView = WKWebView()
        wkwebView.navigationDelegate = context.coordinator
        
        // Register the script message handler to listen for the `loadingFinished` message
        let contentController = wkwebView.configuration.userContentController
        contentController.add(context.coordinator, name: "puzzleCompleted")
        contentController.add(context.coordinator, name: "puzzleFailed")
        
        print("Added message handlers for puzzle completion and failure")
        
        wkwebView.load(URLRequest(url: url))
        
        return wkwebView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        //only load url if its a new url
        print("webview - updateUIView")
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
            print("webview - didStartProvisionalNavigation")
        }
        
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // You can still use this method for any final tasks after the page has fully loaded
            print("webview - Navigation did finish")
            
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
            guard let index = parent.userManager.games.firstIndex(where: {$0 == parent.game}) else {
                print("could not find the matching game to mark as completed in games list")
                return
            }
            if message.name == "puzzleCompleted"  {
                if !parent.userManager.games[index].completed {
                    print("received puzzle success")
                    parent.userManager.games[index].completed = true
                    parent.userManager.games[index].won = true
                }
            } else if message.name == "puzzleFailed" {
                print("received puzzle failed")
                parent.userManager.games[index].completed = true
                parent.userManager.games[index].won = false
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("Navigation failed: \(error.localizedDescription)")
        }
        
        
        
    }
    
    
    
}


