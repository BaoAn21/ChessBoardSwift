//
//  ContentView.swift
//  ChessV2
//
//  Created by Trần Ân on 3/7/24.
//

import SwiftUI

struct ChessPlayView: View {
    let api: String
    let boardID: String
    @State var comebackButton = false
    @Binding var navigationComeback: Bool
    
    @State var boardOrientation: Bool = false
    
    @StateObject var chessBoardController = ChessBoardController(fen: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
    
    @StateObject var countDownViewModelW = CountDownViewModel()
    @StateObject var countDownViewModelB = CountDownViewModel()
    var body: some View {
        VStack {
            CountDownClock(countDownViewModel: countDownViewModelB)
            
            ChessBoardViewV2(chessBoardController: chessBoardController, afterMove:  { move in
                BoardAPI.move(tokenId: api, move: move, gameId: boardID) { completion in
//                    if completion {
//                        chessBoardController.makeMoveFromStringMove(move: move)
//                    }
                }
            }, orientation: boardOrientation)
            .onAppear(perform: {
                streamBoard()
            })
            
            CountDownClock(countDownViewModel: countDownViewModelW)
            
            Button {
                BoardAPI.resign(tokenId: api, boardId: boardID)
            } label: {
                Text("resign")
            }
            .disabled(comebackButton)
            .opacity(comebackButton ? 0 : 1)

            Button(action: {
                navigationComeback = false
            }, label: {
                Text("back to menu")
            })
            .disabled(!comebackButton)
            .opacity(comebackButton ? 1 : 0)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    
    
    func streamBoard() {
        BoardAPI.streamBoard(gameId: boardID, tokenId: api) { move in
            let firstMove = chessBoardController.StringMoveToIntMove(move: move).0
            let secondMove = chessBoardController.StringMoveToIntMove(move: move).1
            chessBoardController.makeMove(fromIndex: firstMove, toIndex: secondMove)
        } boardInfoReceive: { info in
            if info.black.name == "a123baotran" {
                print("blackView")
                boardOrientation = true
            }
            countDownViewModelW.setCoundown(mil: info.clock.initial)
            countDownViewModelB.setCoundown(mil: info.clock.initial)
            
        } boardStateReceive: { boardState in
            if boardState.status == "resign" {
                comebackButton = true
            }
            countDownViewModelB.setCoundown(mil: boardState.btime)
            countDownViewModelW.setCoundown(mil: boardState.wtime)
            if (boardState.moves.split(separator: " ").count >= 2) {
                if boardState.moves.split(separator: " ").count % 2 == 0 {
                    countDownViewModelW.startTime()
                    countDownViewModelB.stopCountdown()
                } else {
                    countDownViewModelW.stopCountdown()
                    countDownViewModelB.startTime()
                }
                
            }
        }
    }
    
    
}

#Preview {
    ChessPlayView(api: "df", boardID: "test", navigationComeback: .constant(false), boardOrientation: false)
}
