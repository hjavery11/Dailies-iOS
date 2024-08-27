//
//  WebView.swift
//  Dailies
//
//  Created by Harrison Javery on 8/26/24.
//

import WebKit
import SwiftUI

struct WebViewScreen: View {
    let game: Game
    
    var body: some View {
        WebView(url: game.url)
            .navigationTitle(game.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar) 
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
        
        webview.load(URLRequest(url: url))
    }
    
}
