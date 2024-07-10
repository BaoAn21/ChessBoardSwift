//
//  ChessBoard.swift
//  ChessV2
//
//  Created by Trần Ân on 3/7/24.
//

import Foundation
import SwiftUI

class ChessBoardController: ObservableObject {
    let Ranks = ["1","2","3","4","5","6","7","8"]
    let Files = ["a","b","c","d","e","f","g","h"]
    
    @Published private(set) var pieces = [Piece?]()
    @Published private(set) var recentMoveFromIndex: Int = -1
    @Published private(set) var recentMoveToIndex: Int = -1
    @Published private(set) var orientation = false
    
    
    init(fen: String = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1", orientation: Bool = false) {
        placePieceByFen(fen: fen)
        self.orientation = orientation
    }
    
    func orientationSwitch() {
        self.orientation.toggle()
    }
    
    func choose(index: Int) -> String? {
        if pieces[index] != nil {
            if let alreadyChosenIndex {
                if alreadyChosenIndex != index {
                    resetIsPicked()
                    return move(fromIndex: alreadyChosenIndex, toIndex: index)
                } else {
                    pieces[index]!.isPicked = false
                    return nil
                }
            } else {
                pieces[index]!.isPicked = true
                return nil
            }
        } else {
            if let alreadyChosenIndex {
                resetIsPicked()
                return move(fromIndex: alreadyChosenIndex, toIndex: index)
            } else {
                return nil
            }
        }
    }
    
    func moveFormatToIndex(move: String) -> (Int,Int) {
        let startIndex = move.startIndex
        let middleIndex = move.index(startIndex, offsetBy: 2)

        let firstMove = String(move[startIndex..<middleIndex])
        let secondMove = String(move[middleIndex...])
        return (fromSquareToIndex(square: firstMove), fromSquareToIndex(square: secondMove))
    }
    
    func fromSquareToIndex(square: String) -> Int {
        let splitString = square.split(separator: "")
        let file = splitString[0]
        let rank = splitString[1]
        let rankIndex = Ranks.firstIndex { $0 == rank }
        let fileIndex = Files.firstIndex{ $0 == file }
        return ((7-rankIndex!)*8 + fileIndex!)
    }
    
    func move(fromIndex: Int, toIndex: Int) -> String {
        withAnimation(.easeIn.speed(2)) {
            if pieces[fromIndex] != nil {
                pieces[toIndex] = pieces[fromIndex]
                pieces[fromIndex] = nil
                resetIsPicked()
                recentMoveFromIndex = fromIndex
                recentMoveToIndex = toIndex
            }
        }
        return indexToId(index: fromIndex) + indexToId(index: toIndex)
    }
    
    var alreadyChosenIndex: Int? {
        get {
            for i in pieces.indices {
                if pieces[i] != nil && pieces[i]!.isPicked {
                    return i
                }
            }
            return nil
        }
    }
    
    func indexToId(index: Int) -> String {
        let rankIndex = index / 8
        let fileIndex = index % 8
        return Files[fileIndex] + Ranks.reversed()[rankIndex]
    }
    
    func resetIsPicked() {
        for index in pieces.indices {
            if pieces[index] != nil {
                pieces[index]!.isPicked = false
            }
        }
    }
    
    func placePieceByFen(fen: String) {
        var id: Int = 0
        for char in fen {
            if char.isNumber {
                let emptySlot = Int(String(char))!
                for _ in 1...emptySlot {
                    pieces.append(nil)
                }
            }
            if char.isLetter {
                let piece: Piece
                switch String(char) {
                case "p":
                    piece = Piece(color: .black, type: .pawn)
                case "P":
                    piece = Piece(color: .white, type: .pawn)
                case "R":
                    piece = Piece(color: .white, type: .rook)
                case "r":
                    piece = Piece(color: .black, type: .rook)
                case "B":
                    piece = Piece(color: .white, type: .bishop)
                case "b":
                    piece = Piece(color: .black, type: .bishop)
                case "K":
                    piece = Piece(color: .white, type: .king)
                case "k":
                    piece = Piece(color: .black, type: .king)
                case "Q":
                    piece = Piece(color: .white, type: .queen)
                case "q":
                    piece = Piece(color: .black, type: .queen)
                case "n":
                    piece = Piece(color: .black, type: .knight)
                case "N":
                    piece = Piece(color: .white, type: .knight)
                default:
                    return
                }
                pieces.append(piece)
            }
            id += 1
            if char == " " {
                break
            }
        }
    }
    
    
}

extension Array {
    var only: Element? {
        if (count == 1 ) {
            return first
        } else {
            return nil
        }
    }
}

