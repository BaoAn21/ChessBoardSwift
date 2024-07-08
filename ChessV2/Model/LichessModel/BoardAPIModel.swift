//
//  BoardAPI.swift
//  Chess
//
//  Created by Trần Ân on 8/7/24.
//

import Foundation


struct BoardState: Decodable {
    var type: String
    var moves: String
    var wtime: Int
    var btime: Int
    var winc: Int
    var binc: Int
    var status: String
}

struct BoardInfo: Decodable {
    var id: String
    var variant: Variant
    var speed: String
    var perf: Perf
    var rated: Bool
    var createdAt: Int
    var white: Player
    var black: Player
    var initialFen: String
    var clock: Clock
    var type: String
    var state: BoardState
    
    struct Clock: Decodable {
        var initial: Int
        var increment: Int
    }
    
    struct Player: Decodable {
        var id: String
        var name: String
        var title: String?
        var rating: Int
    }
    struct Perf: Decodable {
        var name: String
    }
    
    struct Variant: Decodable {
        var key: String
        var name: String
        var short: String
    }
}
