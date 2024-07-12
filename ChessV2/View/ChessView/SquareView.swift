//
//  SquareView.swift
//  ChessV2
//
//  Created by Trần Ân on 10/7/24.
//

import SwiftUI

struct SquareView: View {
    let blackSquare = [1,3,5,7,8,10,12,14,17,19,21,23,24,26,28,30,33,35,37,39,40,42,44,46,49,51,53,55,56,58,60,62]
    let square: Square
    var squareColor: Color {
        if square.isChosen {
            return .red
        } else if square.recentMoveFrom {
            return .yellow
        } else if square.recentMoveTo {
            return .orange
        } else {
            if blackSquare.contains(square.id) {
                return .blue
            } else {
                return .white
            }
        }
    }
    
    var body: some View {
        squareColor
            .overlay {
                if square.couldGoTo {
                    Text("X")
                        .font(.largeTitle)
                        .foregroundStyle(.red)
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .border(Color.black)
    }
}

#Preview {
    SquareView(square: Square(id: 0, couldGoTo: true))
}
