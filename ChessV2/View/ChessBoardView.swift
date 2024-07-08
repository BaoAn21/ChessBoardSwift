//
//  ChessBoardView.swift
//  ChessV2
//
//  Created by Trần Ân on 5/7/24.
//

import SwiftUI

public struct ChessBoardView: View {
    @ObservedObject var chessBoardController: ChessBoardController = ChessBoardController()
    
    var afterMove: (String)->Void
    
    public var body: some View {
        chessBoardView
        Text("\(chessBoardController.recentMoveToIndex)")
    }
    
    init(chessBoardController: ChessBoardController, afterMove: @escaping (String)->Void) {
        self.chessBoardController = chessBoardController
        self.afterMove = afterMove
    }
    
    @ViewBuilder
    var chessBoardView: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(0..<8) { row in
                GridRow {
                    ForEach((row*8)..<(row*8+8), id: \.self) { i in
                        let piece = chessBoardController.pieces[i]
                        var squareColor: Color {
                            if chessBoardController.recentMoveToIndex == i {
                                return .orange
                            } else if chessBoardController.recentMoveFromIndex == i {
                                return .yellow
                            } else {
                                return .white
                            }
                        }
                        ZStack {
                            ChessPieceView(piece: piece, color: squareColor)
                                .background(.white)
                                .onTapGesture {
                                    if let move = chessBoardController.choose(index: i) {
                                        afterMove(move)
                                    }
                                }
                                .rotationEffect(chessBoardController.orientation ? .degrees(180) : .zero)
                        }
                    }
                }
            }
        }
        .rotationEffect(chessBoardController.orientation ? .degrees(180) : .zero)
    }
    
    
    
}


#Preview {
    ChessBoardView(chessBoardController: ChessBoardController(fen: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"), afterMove: {move in
        print(move)
        
    })
}
