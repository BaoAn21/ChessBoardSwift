//
//  ChessPieceView.swift
//  ChessV2
//
//  Created by Trần Ân on 6/7/24.
//

import SwiftUI

struct ChessPieceView: View {
    let piece: Piece?
    let color: Color
    var body: some View {
        Group {
            if let piece {
                Rectangle()
                    .stroke()
                    .overlay{
                        Image(piece.image)
                            .resizable()
                            .scaledToFit()
                            .zIndex(1)
                            .background(piece.isPicked ? Color.brown : color)
                    }
            } else {
                Rectangle()
                    .stroke()
                    .background(color)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        
    }
}

#Preview {
    Group {
        ChessPieceView(piece: Piece(color: .black, type: .bishop), color: .blue)
        ChessPieceView(piece: nil, color: .brown)
    }
}
