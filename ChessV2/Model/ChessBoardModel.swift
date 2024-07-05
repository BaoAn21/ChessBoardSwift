//
//  ChessBoardModel.swift
//  ChessV2
//
//  Created by Trần Ân on 3/7/24.
//

import Foundation

struct Piece: Identifiable {
    let id: UUID
    let color: PieceColor
    let type: PieceType
    var isPicked = false
    var image: String {
        switch color {
        case .white:
            switch type {
            case .pawn:
                return "whitePawn"
            case .rook:
                return "whiteRook"
            case .knight:
                return "whiteKnight"
            case .king:
                return "whiteKing"
            case .queen:
                return "whiteQueen"
            case .bishop:
               return "whiteBishop"
            }
        case .black:
            switch type {
            case .pawn:
                return "blackPawn"
            case .rook:
                return "blackRook"
            case .knight:
                return "blackKnight"
            case .king:
                return "blackKing"
            case .queen:
                return "blackQueen"
            case .bishop:
               return "blackBishop"
            }
        }
    }
    
    init(id: UUID = UUID(), color: PieceColor, type: PieceType) {
        self.id = id
        self.color = color
        self.type = type
    }
    
    var fenChar: String {
        switch color {
        case .white:
            switch type {
            case .pawn:
                return "P"
            case .rook:
                return "R"
            case .knight:
                return "N"
            case .king:
                return "K"
            case .queen:
                return "Q"
            case .bishop:
               return "B"
            }
        case .black:
            switch type {
            case .pawn:
                return "p"
            case .rook:
                return "r"
            case .knight:
                return "n"
            case .king:
                return "k"
            case .queen:
                return "q"
            case .bishop:
               return "b"
            }
        }
    }
}

enum PieceColor {
    case white
    case black
}

enum PieceType {
    case pawn
    case rook
    case knight
    case king
    case queen
    case bishop
}
