//
//  ChessBoardView.swift
//  ChessV2
//
//  Created by Trần Ân on 5/7/24.
//

import SwiftUI

struct ChessBoardView: View {
    @ObservedObject var chessBoardController: ChessBoardController
    
    var body: some View {
        chessBoardView
    }
    
    @Namespace private var animatePiece
    
    var chessBoardView: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(0..<8) { row in
                GridRow {
                    ForEach((row*8)..<(row*8+8), id: \.self) { i in
                        var squareColor: Color {
                            if i == chessBoardController.recentMoveFromIndex {
                                .orange
                            } else if i == chessBoardController.recentMoveToIndex {
                                .yellow
                            } else {
                                .white
                            }
                        }
                        let piece = chessBoardController.pieces[i]
                            Rectangle().stroke()
                                .overlay {
                                    if piece == nil {
                                        EmptyView()
                                    } else {
                                        Image(piece!.image)
                                            .resizable()
                                            .scaledToFit()
                                            .zIndex(1)
                                            .matchedGeometryEffect(id: piece!.id, in: animatePiece)
                                            .background(piece!.isPicked ? Color.brown : nil)
                                            
                                    }
                                }
                                .background(squareColor)
                                .aspectRatio(1.0, contentMode: .fit)
                                .onTapGesture {
                                    withAnimation(.easeInOut.speed(2)) {
                                        chessBoardController.choose(index: i)
                                    }
                                    
                                }
                    }
                }
            }
        }
    }
}

#Preview {
    ChessBoardView(chessBoardController: ChessBoardController(fen: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"))
}
