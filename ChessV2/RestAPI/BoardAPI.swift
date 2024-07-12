//
//  BoardAPI.swift
//  ChessV2
//
//  Created by Trần Ân on 8/7/24.
//

import Foundation

struct BoardAPI {
    static func splitConcatenatedJSON(_ concatenatedJSON: String) -> [String] {
        var jsonStrings: [String] = []
        var bracketCount = 0
        var jsonStartIndex: String.Index?
        
        for (index, char) in concatenatedJSON.enumerated() {
            if char == "{" {
                if bracketCount == 0 {
                    jsonStartIndex = concatenatedJSON.index(concatenatedJSON.startIndex, offsetBy: index)
                }
                bracketCount += 1
            } else if char == "}" {
                bracketCount -= 1
                if bracketCount == 0, let startIndex = jsonStartIndex {
                    let jsonEndIndex = concatenatedJSON.index(concatenatedJSON.startIndex, offsetBy: index + 1)
                    let jsonString = String(concatenatedJSON[startIndex..<jsonEndIndex])
                    jsonStrings.append(jsonString)
                    jsonStartIndex = nil
                }
            }
        }
        
        return jsonStrings
    }
    
    static func move(tokenId: String, move: String, gameId: String, completion:@escaping (Bool) -> Void) {
        let urlString = "https://lichess.org/api/board/game/\(gameId)/move/\(move)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            DispatchQueue.main.async {
                completion(false)
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(tokenId)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    DispatchQueue.main.async {
                        completion(true)
                    }
                }
            }
        }
        task.resume()
    }
    
    static func streamBoard(gameId: String, tokenId: String, moveReceice:@escaping (String) -> Void, boardInfoReceive:@escaping (BoardInfo) -> Void, boardStateReceive:@escaping (BoardState) -> Void ) {
        
        let url = URL(string: "https://lichess.org/api/board/game/stream/\(gameId)")!
        
        // Create a URLRequest
        var request = URLRequest(url: url)
        request.setValue("Bearer \(tokenId)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        // Implement URLSessionDataDelegate to handle streaming data
        class StreamDelegate: NSObject, URLSessionDataDelegate {
            private let boardInfoReceive: (BoardInfo) -> Void
            private let moveReceive: (String) -> Void
            private let boardStateReceive:(BoardState) -> Void
            
            init(moveReceive: @escaping (String) -> Void, boardInfoReceive:@escaping (BoardInfo) -> Void, boardStateReceive:@escaping (BoardState) -> Void) {
                self.moveReceive = moveReceive
                self.boardInfoReceive = boardInfoReceive
                self.boardStateReceive = boardStateReceive
            }
            func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
                let decoder = JSONDecoder()
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                    // Handle rare case where Json stick to each other
                    let jsonStringArray = BoardAPI.splitConcatenatedJSON(jsonString)
                    for s in jsonStringArray {
                        guard let data = s.data(using: .utf8) else {
                            return
                        }
                        if let boardState = try? decoder.decode(BoardState.self, from: data) {
                            DispatchQueue.main.async {
                                self.moveReceive(getLatestMove(moves: boardState.moves))
                                self.boardStateReceive(boardState)
                            }
                        } else if let boardInfo = try? decoder.decode(BoardInfo.self, from: data) {
                            DispatchQueue.main.async {
                                print(boardInfo.black.name)
                                self.boardInfoReceive(boardInfo)
                                if !boardInfo.state.moves.isEmpty {
                                    self.moveReceive(getLatestMove(moves: boardInfo.state.moves))
                                }
                            }
                        }
                    }
                }
            }
        }
        
        func getLatestMove(moves: String) -> String {
            if !moves.isEmpty {
                let moveArray = moves.split(separator: " ")
                return String(moveArray[moveArray.count - 1])
            } else {
                return ""
            }
        }
        
        // Use the delegate in the session
        let streamDelegate = StreamDelegate(moveReceive: moveReceice, boardInfoReceive: boardInfoReceive, boardStateReceive: boardStateReceive)
        let streamSession = URLSession(configuration: .default, delegate: streamDelegate, delegateQueue: OperationQueue())
        let streamTask = streamSession.dataTask(with: request)
        
        streamTask.resume()
    }
    
    static func resign(tokenId: String, boardId: String) {
        let urlString = "https://lichess.org/api/board/game/\(boardId)/resign"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(tokenId)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if response is HTTPURLResponse {
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                }
            }
        }
        task.resume()
        
    }
    
    static func seek10minGame(tokenId: String) {
        let urlString = "https://lichess.org/api/board/seek"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(tokenId)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "rated": true,
            "time": 10,
            "increment": 0
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            print("Error serializing JSON: \(error)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
        }
        task.resume()
    }
}
