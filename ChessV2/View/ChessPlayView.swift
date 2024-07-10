//
//  ContentView.swift
//  ChessV2
//
//  Created by Trần Ân on 3/7/24.
//

import SwiftUI

struct ChessPlayView: View {
    let api = "lip_IWZ4ELQzWdJgDsjQOrOS"
    let boardID: String
    @State var comebackButton = false
    @Binding var navigationComeback: Bool
    
    @StateObject var chessBoardController = ChessBoardController(fen: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1", orientation: false)
    var body: some View {
        VStack {
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
                } boardStateReceive: { boardState in
                    if boardState.status == "resign" {
                        comebackButton = true
                    }
                }
            })
            Button(action: {
                navigationComeback = false
            }, label: {
                Text("Button")
            })
            .disabled(!comebackButton)
            .opacity(comebackButton ? 1 : 0)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ChessPlayView(boardID: "test", navigationComeback: .constant(false))
}
