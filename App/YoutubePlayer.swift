//
//  YoutubePlayer.swift
//  App
//
//  Created by Akashdeep Singh Kaur on 11/11/2025.
//

import SwiftUI
import WebKit

struct YoutubePlayer: UIViewRepresentable {
    let videoId: String
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        configuration.defaultWebpagePreferences = preferences
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        webView.backgroundColor = .clear
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) -> Void {
        guard let baseURL = APIConfig.shared?.youtubeEmbedBaseURL else {
            print("YouTube Embed Base URL not provided")
            return
        }

        let cleanVideoId = videoId.components(separatedBy: "?").first ?? videoId
        
        // Using IFrame Player API fro full embedded frame control
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }
                html, body {
                    width: 100%;
                    height: 100%;
                    overflow: hidden;
                    background-color: #000;
                }
                #player {
                    width: 100%;
                    height: 100%;
                }
            </style>
        </head>
        <body>
            <div id="player"></div>
            <script>
                var tag = document.createElement('script');
                tag.src = "https://www.youtube.com/iframe_api";
                var firstScriptTag = document.getElementsByTagName('script')[0];
                firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

                var player;
                function onYouTubeIframeAPIReady() {
                    player = new YT.Player('player', {
                        height: '100%',
                        width: '100%',
                        videoId: '\(cleanVideoId)',
                        playerVars: {
                            'playsinline': 1,
                            'autoplay': 0,
                            'controls': 1,
                            'rel': 0,
                            'modestbranding': 1,
                            'origin': window.location.origin
                        },
                        events: {
                            'onError': function(event) {
                                console.log('YouTube Player Error: ' + event.data);
                            }
                        }
                    });
                }
            </script>
        </body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: URL(string: baseURL))
    }
}
