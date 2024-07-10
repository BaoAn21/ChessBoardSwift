//
//  BoardAPI.swift
//  ChessV2
//
//  Created by Trần Ân on 8/7/24.
//

import Foundation

struct BoardAPI {
    static func move(tokenId: String, move: String, gameId: String) {
        let urlString = "https://lichess.org/api/board/game/\(gameId)/move/\(move)"
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
            
            if let response = response as? HTTPURLResponse {
                print("Status Code: \(response.statusCode)")
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
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
//                 Print the JSON string if decoding fails
//                else if let jsonString = String(data: data, encoding: .utf8) {
//                    print("Received something")
//                }
//                do {
//                    let data = try decoder.decode(BoardInfo.self, from: data)
//                }catch {
//                    print(error)
//                }
            }
        }

        func getLatestMove(moves: String) -> String {
            let moveArray = moves.split(separator: " ")
            return String(moveArray[moveArray.count - 1])
        }

        // Use the delegate in the session
        let streamDelegate = StreamDelegate(moveReceive: moveReceice, boardInfoReceive: boardInfoReceive, boardStateReceive: boardStateReceive)
        let streamSession = URLSession(configuration: .default, delegate: streamDelegate, delegateQueue: OperationQueue())
        let streamTask = streamSession.dataTask(with: request)

        streamTask.resume()
    }
}
