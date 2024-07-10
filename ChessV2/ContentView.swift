//
//  ContentView.swift
//  ChessV2
//
//  Created by Trần Ân on 3/7/24.
//

import SwiftUI

struct ContentView: View {
    let api = "lip_IWZ4ELQzWdJgDsjQOrOS"
    let boardID = "mLEzzBps"
    @StateObject var chessBoardController = ChessBoardController(fen: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1", orientation: false)
    var body: some View {
        ChessBoardView(chessBoardController: chessBoardController) { move in
            BoardAPI.move(tokenId: api, move: move, gameId: boardID)
        }
        .onAppear(perform: {
            BoardAPI.streamBoard(gameId: boardID, tokenId: api) { move in
                let firstMove = chessBoardController.moveFormatToIndex(move: move).0
                let secondMove = chessBoardController.moveFormatToIndex(move: move).1
                _ = chessBoardController.move(fromIndex: firstMove, toIndex: secondMove)
            } boardInfoReceive: { info in
                if info.black.name == "a123baotran" {
                    print("hear")
                    chessBoardController.orientationSwitch()
                }
            }
        })
    }
}

#Preview {
    ContentView()
}
