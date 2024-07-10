//
//  EventAPIModel.swift
//  ChessV2
//
//  Created by Trần Ân on 10/7/24.
//

import Foundation

struct GameStartEvent: Decodable {
    let type: String
    let game: Game
    
    struct Game: Decodable {
        let gameId: String
        let fullId: String
        let color: String
        let fen: String
        let hasMoved: Bool
        let isMyTurn: Bool
        let lastMove: String
        let opponent: Opponent
        let perf: String
        let rated: Bool
        let secondsLeft: Int
        let source: String
        let status: Status
        let speed: String
        let variant: Variant
        let compat: Compat
        let id: String
        
        struct Opponent: Decodable {
            let id: String
            let rating: Int
            let username: String
        }
        
        struct Status: Decodable {
            let id: Int
            let name: String
        }
        
        struct Variant: Decodable {
            let key: String
            let name: String
        }
        
        struct Compat: Decodable {
            let bot: Bool
            let board: Bool
        }
    }
}

