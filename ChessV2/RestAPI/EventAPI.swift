//
//  EventAPI.swift
//  ChessV2
//
//  Created by Trần Ân on 10/7/24.
//

import Foundation

struct EventAPI {
    static func streamEvent(tokenId: String, gameStartReceived:@escaping (GameStartEvent)->Void) {
        let url = URL(string: "https://lichess.org/api/stream/event")!
        
        // Create a URLRequest
        var request = URLRequest(url: url)
        request.setValue("Bearer \(tokenId)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        // Implement URLSessionDataDelegate to handle streaming data
        class StreamDelegate: NSObject, URLSessionDataDelegate {
            
            private let gameStartReceived: (GameStartEvent) -> Void
            
            init(gameStartReceived: @escaping (GameStartEvent) -> Void) {
                self.gameStartReceived = gameStartReceived
            }
            
            func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
                if data.count > 1 {
                    let decoder = JSONDecoder()
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Event: "+jsonString)
                    }
                    
                    do {
                        let gameStartEvent = try decoder.decode(GameStartEvent.self, from: data)
                        DispatchQueue.main.async {
                            self.gameStartReceived(gameStartEvent)
                        }
                    } catch {
                        print("error in EventAPI: \(error)")
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("Error with: "+jsonString)
                        }
                    }
                }
            }
        }
        
        // Use the delegate in the session
        let streamDelegate = StreamDelegate(gameStartReceived: gameStartReceived)
        let streamSession = URLSession(configuration: .default, delegate: streamDelegate, delegateQueue: OperationQueue())
        let streamTask = streamSession.dataTask(with: request)
        
        streamTask.resume()
    }
    
}

