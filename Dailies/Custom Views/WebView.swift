//
//  WebView.swift
//  Dailies
//
//  Created by Harrison Javery on 8/26/24.
//

import WebKit
import SwiftUI

struct WebViewScreen: View {
    let games: [Game]
    @State private var currentIndex: Int
    
    init(games: [Game], currentIndex: Int) {
        self.games = games
        self._currentIndex = State(initialValue: currentIndex)
    }
    
    var body: some View {
        WebView(url: games[currentIndex].url)
            .navigationTitle(games[currentIndex].name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                if games.count > 1 {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Next") {
                            goToNextGame()
                        }
                    }
                }
            }
    }
    
    private func goToNextGame() {
        currentIndex += 1
    }
}

struct WebView: UIViewRepresentable {
    
    let webview: WKWebView
    var url: String
    
    init(url: String) {
        webview = WKWebView(frame: .zero)
        self.url = url
    }
    
    func makeUIView(context: Context) -> WKWebView {
        return webview
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = URL(string: url) else { return }
        
        uiView.load(URLRequest(url: url))
    }
    
}
