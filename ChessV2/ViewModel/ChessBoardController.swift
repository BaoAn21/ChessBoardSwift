//
//  ChessBoard.swift
//  ChessV2
//
//  Created by Trần Ân on 3/7/24.
//

import Foundation
import SwiftUI

class ChessBoardController: ObservableObject {
    static let Ranks = ["1","2","3","4","5","6","7","8"]
    static let Files = ["a","b","c","d","e","f","g","h"]
    
    @Published private(set) var pieces = [Piece?]()
    @Published private(set) var squares = [Square]()
    
    @Published private(set) var legitMove: [Int:[Int]] = [
        8: [16,24],
        9: [17,25]
    ]
    
    
    init(fen: String = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1") {
        placePieceByFen(fen: fen)
        generateSquare(pieces: pieces)
    }
    
    func generateSquare(pieces: [Piece?]) {
        for i in 0...63 {
            squares.append(Square(id: i))
        }
    }
    
    //    func choose(index: Int) -> String? {
    //        if pieces[index] != nil {
    //            if let alreadyChosenIndex {
    //                if alreadyChosenIndex != index {
    //                    resetIsPicked()
    //                    return move(fromIndex: alreadyChosenIndex, toIndex: index)
    //                } else {
    //                    pieces[index]!.isPicked = false
    //                    return nil
    //                }
    //            } else {
    //                pieces[index]!.isPicked = true
    //                return nil
    //            }
    //        } else {
    //            if let alreadyChosenIndex {
    //                resetIsPicked()
    //                return move(fromIndex: alreadyChosenIndex, toIndex: index)
    //            } else {
    //                return nil
    //            }
    //        }
    //    }
    
    func StringMoveToIntMove(move: String) -> (Int,Int) {
        let startIndex = move.startIndex
        let middleIndex = move.index(startIndex, offsetBy: 2)
        
        let firstMove = String(move[startIndex..<middleIndex])
        let secondMove = String(move[middleIndex...])
        return (ChessBoardController.StringIndexToIntIndex(square: firstMove), ChessBoardController.StringIndexToIntIndex(square: secondMove))
    }
    
    static func StringIndexToIntIndex(square: String) -> Int {
        let splitString = square.split(separator: "")
        let file = splitString[0]
        let rank = splitString[1]
        let rankIndex = Ranks.firstIndex { $0 == rank }
        let fileIndex = Files.firstIndex{ $0 == file }
        return ((7-rankIndex!)*8 + fileIndex!)
    }
    
    
    
//    func move(fromIndex: Int, toIndex: Int) -> String {
//        withAnimation(.easeIn.speed(2)) {
//            if pieces[fromIndex] != nil {
//                pieces[toIndex] = pieces[fromIndex]
//                pieces[fromIndex] = nil
//                resetIsPicked()
//                recentMoveFromIndex = fromIndex
//                recentMoveToIndex = toIndex
//            }
//        }
//        return ChessBoardController.IntIndexToStringIndex(index: fromIndex) + ChessBoardController.IntIndexToStringIndex(index: toIndex)
//    }
    
//    var alreadyChosenIndex: Int? {
//        get {
//            for i in pieces.indices {
//                if pieces[i] != nil && pieces[i]!.isPicked {
//                    return i
//                }
//            }
//            return nil
//        }
//    }
    
    static func IntIndexToStringIndex(index: Int) -> String {
        let rankIndex = index / 8
        let fileIndex = index % 8
        return Files[fileIndex] + Ranks.reversed()[rankIndex]
    }
    
//    func resetIsPicked() {
//        for index in pieces.indices {
//            if pieces[index] != nil {
//                pieces[index]!.isPicked = false
//            }
//        }
//    }
    
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
    
    // Mark: -Testing
    func choose(square: Square) -> [Square] {
        if let index = squares.firstIndex(where: { $0.id == square.id }) {
            // Have that index
            if pieces[square.id] != nil { // Have a piece
                if !square.isChosen { // Not chosen
                    if let chosenSquare = squares.filter({$0.isChosen}).only {
                        // could make a move here
//                        makeMove(fromIndex: chosenSquare.id, toIndex: index)
                        resetChosenSquare()
                        resetCouldGoTo()
                        return [squares[chosenSquare.id], squares[index]]
                    } else {
                        squares[index].isChosen = true
                        // show legit move
                        if let indexes = legitMove[index] {
                            for index in indexes {
                                squares[index].couldGoTo = true
                            }
                        }
                        return [squares[index]]
                    }
                } else { // Already Chosen
                    squares[index].isChosen = false
                    resetCouldGoTo()
                    return [squares[index]]
                }
            } else { // Does not have a piece
                if let chosenSquare = squares.filter({$0.isChosen}).only {
                    // could make a move here
//                    makeMove(fromIndex: chosenSquare.id, toIndex: index)
                    resetChosenSquare()
                    resetCouldGoTo()
                    return [squares[chosenSquare.id], squares[index]]
                } else {
                    return []
                }
            }
        } else {
            return []
        }
    }
    
    func resetCouldGoTo() {
        for index in squares.indices {
            squares[index].couldGoTo = false
        }
    }
    
    func resetChosenSquare() {
        for index in squares.indices {
            squares[index].isChosen = false
        }
    }
    
    func makeMoveWithLegitMove(fromIndex: Int, toIndex: Int) {
        if let movesIndex = legitMove[fromIndex] {
            if movesIndex.contains(toIndex) {
                withAnimation(.easeOut) {
                    if pieces[fromIndex] != nil {
                        pieces[toIndex] = pieces[fromIndex]
                        pieces[fromIndex] = nil
                    }
                }
            }
        }
    }
    
    func makeMove(fromIndex: Int, toIndex: Int) {
        //        if let movesIndex = legitMove[fromIndex] {
        //            if movesIndex.contains(toIndex) {
        withAnimation(.easeOut) {
            if pieces[fromIndex] != nil {
                pieces[toIndex] = pieces[fromIndex]
                pieces[fromIndex] = nil
                resetRecentMove()
                squares[fromIndex].recentMoveFrom = true
                squares[toIndex].recentMoveTo = true
                // handle castle
                if fromIndex == 4 {
                    if toIndex == 2 {
                        pieces[3] = pieces[0]
                        pieces[0] = nil
                    } else if toIndex == 6 {
                        pieces[5] = pieces[7]
                        pieces[7] = nil
                    }
                }
                if fromIndex == 60 {
                    if toIndex == 62 {
                        pieces[61] = pieces[63]
                        pieces[63] = nil
                    } else if toIndex == 58 {
                        pieces[59] = pieces[56]
                        pieces[56] = nil
                    }
                }
            }
        }
    }
    func resetRecentMove() {
        for i in squares.indices {
            squares[i].recentMoveTo = false
            squares[i].recentMoveFrom = false
        }
    }
    
    func makeMoveFromStringMove(move: String) {
        let moves = StringMoveToIntMove(move: move)
        makeMove(fromIndex: moves.0, toIndex: moves.1)
    }
    
    func setLetgitMove(_ legitMove: [Int:[Int]]) {
        self.legitMove = legitMove
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

