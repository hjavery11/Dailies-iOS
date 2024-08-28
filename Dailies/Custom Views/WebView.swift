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
    @State private var isLoading = false
    
    init(games: [Game], currentIndex: Int) {
        self.games = games
        self._currentIndex = State(initialValue: currentIndex)
    }
    
    var body: some View {
        if let url = URL(string: games[currentIndex].url) {
            ZStack {
                WebView(url: url, isLoading: $isLoading)
                    .navigationTitle(games[currentIndex].name)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar(.hidden, for: .tabBar)
                    .toolbar {
                        if games.count > 1 {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button {
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
                if isLoading {
                    ProgressView()
                        .controlSize(.large)
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
    @Binding var isLoading: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let wkwebView = WKWebView()
        wkwebView.navigationDelegate = context.coordinator
        
        // Register the script message handler to listen for the `loadingFinished` message
        let contentController = wkwebView.configuration.userContentController
        contentController.add(context.coordinator, name: "loadingFinished")
        
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
            parent.isLoading = true
            print("is loading true")
            let js = """
                (function() {
                    if (document.readyState === 'interactive' || document.readyState === 'complete') {
                        window.webkit.messageHandlers.loadingFinished.postMessage(true);
                    } else {
                        document.addEventListener('readystatechange', function() {
                            if (document.readyState === 'interactive' || document.readyState === 'complete') {
                                window.webkit.messageHandlers.loadingFinished.postMessage(true);
                            }
                        });
                    }
                })();
                """
            webView.evaluateJavaScript(js) { result, error in
                if let error = error {
                    print("JavaScript evaluation error: \(error)")
                } else {
                    print("JavaScript injected successfully")
                }
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // You can still use this method for any final tasks after the page has fully loaded
            print("Navigation did finish")
        }
        
        // Handle JavaScript messages
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "loadingFinished" {
                parent.isLoading = false
                print("is loading false")
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
            print("Loading failed, setting isLoading to false")
        }
        
        
    }
    
}
