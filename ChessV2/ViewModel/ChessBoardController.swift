//
//  ChessBoard.swift
//  ChessV2
//
//  Created by Trần Ân on 3/7/24.
//

import Foundation

class ChessBoardController: ObservableObject {
    
    @Published private(set) var pieces = [Piece?]()
    @Published private(set) var recentMoveFromIndex: Int = -1
    @Published private(set) var recentMoveToIndex: Int = -1
    
    init(fen: String = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1") {
        placePieceByFen(fen: fen)
    }
    
    func choose(index: Int) {
        print(index)
        if pieces[index] != nil {
            if let alreadyChosenIndex {
                if alreadyChosenIndex != index {
                    move(fromIndex: alreadyChosenIndex, toIndex: index)
                    resetIsPicked()
                } else {
                    pieces[index]!.isPicked = false
                }
            } else {
                pieces[index]!.isPicked = true
            }
        } else {
            if let alreadyChosenIndex {
                move(fromIndex: alreadyChosenIndex, toIndex: index)
                resetIsPicked()
            }
        }
    }
    
    func move(fromIndex: Int, toIndex: Int) {
        if pieces[fromIndex] != nil {
            pieces[toIndex] = pieces[fromIndex]!
            pieces[fromIndex] = nil
            recentMoveFromIndex = fromIndex
            recentMoveToIndex = toIndex
        }
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
    
    func resetIsPicked() {
        for index in pieces.indices {
            if pieces[index] != nil {
                pieces[index]!.isPicked = false
            }
        }
    }
    
    func placePieceByFen(fen: String) {
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

