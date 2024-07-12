//
//  ChessBoardView.swift
//  ChessV2
//
//  Created by Trần Ân on 5/7/24.
//

import SwiftUI

public struct ChessBoardViewV2: View {
    @Namespace var slidingPieceAnimation
    
    private let gridColumns = Array(repeating: GridItem(.flexible(minimum: 10), spacing: 0), count: 8)
    var orientation: Bool
    
    @ObservedObject var chessBoardController: ChessBoardController = ChessBoardController()
    
    var afterMove: (String)->Void
    
    public var body: some View {
        chessGridView
            .rotationEffect(orientation ? .degrees(180) : .zero)
    }
    
    init(chessBoardController: ChessBoardController, afterMove: @escaping (String)->Void, orientation: Bool = false) {
        self.chessBoardController = chessBoardController
        self.afterMove = afterMove
        self.orientation = orientation
    }
    
    var chessGridView: some View {
        LazyVGrid(columns: gridColumns, spacing: 0) {
            ForEach(chessBoardController.squares) { square in
                SquareView(square: square)
                    .rotationEffect(orientation ? .degrees(180) : .zero)
                    .onTapGesture {
                        let move = chessBoardController.choose(square: square)
                        if move.count == 2 {
                            afterMove(move[0].stringId + move[1].stringId)
                        }
                    }
                    .overlay {
                        if let piece = chessBoardController.pieces[square.id] {
                            Image(piece.image)
                                .resizable()
                                .allowsHitTesting(false)
                                .rotationEffect(orientation ? .degrees(180) : .zero)
                                .matchedGeometryEffect(id: piece.id, in: slidingPieceAnimation)
                        }
                    }
            }
        }
    }
}


#Preview {
    ChessBoardViewV2(chessBoardController: ChessBoardController(fen: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"), afterMove: {move in
        print(move)
    },orientation: false)
}
